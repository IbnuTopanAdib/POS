import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:final_project_sanbercode/model/cart.dart';
import 'package:final_project_sanbercode/model/order.dart';
import 'package:final_project_sanbercode/model/product.dart';
import 'package:final_project_sanbercode/service/cart_service.dart';
import 'package:final_project_sanbercode/service/order_service.dart';
import 'package:final_project_sanbercode/service/product_service.dart';
import 'package:final_project_sanbercode/utils/notification_helper.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartService _cartService = CartService();
  final ProductService _productService = ProductService();
  final OrderService _orderService = OrderService();
  StreamSubscription<List<Cart>>? _cartSubscription;
  final notificationHelper = NotificationHelper();

  CartBloc() : super(CartLoading()) {
    on<LoadCart>(_onLoadCart);
    on<AddProductToCart>(_onAddProductToCart);
    on<IncreaseQuantity>(_onIncreaseQuantity);
    on<DecreaseQuantity>(_onDecreaseQuantity);
    on<CartUpdated>(_onCartUpdated);
    on<SelectProduct>(_onSelectProduct);
    on<SelectAllProducts>(_onSelectAllProducts);
    on<CheckoutSingleProduct>(_onCheckoutSingleProduct);
    on<SelectPaymentMethod>(_onSelectPaymentMethod);
    on<PlaceOrder>(_onPlaceOrder);
  }

  void _onLoadCart(LoadCart event, Emitter<CartState> emit) {
    emit(CartLoading());
    try {
      final cartStream = _cartService.getAllCartsStream();
      _cartSubscription?.cancel();
      _cartSubscription = cartStream.listen((carts) async {
        List<Product> products = [];

        for (var cart in carts) {
          try {
            var product = await _productService.getProductById(cart.productId!);
            products.add(product);
          } catch (e) {
            print(
                "Produk dengan ID ${cart.productId} tidak ditemukan, menghapus dari cart.");
            await _cartService.deleteCartItem(cart.id!);
          }
        }

        List<String> selectedProductIds = [];
        if (state is CheckoutState) {
          selectedProductIds = (state as CheckoutState).selectedProductIds;
        }

        add(CartUpdated(carts, products, selectedProductIds));
      });
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void _onCartUpdated(CartUpdated event, Emitter<CartState> emit) {
    emit(CartLoading());
    try {
      List<String> selectedProductIds = event.selectedProductIds;

      selectedProductIds = selectedProductIds
          .where((productId) =>
              event.products.any((product) => product.id == productId))
          .toList();

      final selectedTotalPrice = event.products
          .where((product) => selectedProductIds.contains(product.id))
          .fold(0.0, (sum, product) {
        final cart = event.carts.firstWhere((c) => c.productId == product.id);
        return sum + (product.price * cart.quantity!);
      });

      emit(CheckoutState(event.carts, event.products,
          selectedProductIds: selectedProductIds,
          selectedTotalPrice: selectedTotalPrice));
    } catch (e) {
      print(e);
    }
  }

  void _onAddProductToCart(
      AddProductToCart event, Emitter<CartState> emit) async {
    try {
      await _cartService.addProductToCart(event.productId, event.quantity);
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void _onIncreaseQuantity(
      IncreaseQuantity event, Emitter<CartState> emit) async {
    try {
      await _cartService.increaseQuantity(event.cartId);
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void _onDecreaseQuantity(
      DecreaseQuantity event, Emitter<CartState> emit) async {
    try {
      await _cartService.decreaseQuantity(event.cartId);
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void _onSelectProduct(SelectProduct event, Emitter<CartState> emit) {
    if (state is CheckoutState) {
      final currentState = state as CheckoutState;
      final selectedProducts =
          List<String>.from(currentState.selectedProductIds);

      if (event.isSelected) {
        selectedProducts.add(event.productId);
      } else {
        selectedProducts.remove(event.productId);
      }
      final selectedTotalPrice = currentState.products
          .where((product) => selectedProducts.contains(product.id))
          .fold(0.0, (sum, product) {
        final cart =
            currentState.carts.firstWhere((c) => c.productId == product.id);
        return sum + (product.price * cart.quantity!);
      });

      emit(currentState.copyWith(
        selectedProductIds: selectedProducts,
        selectedTotalPrice: selectedTotalPrice,
      ));
    }
  }

  void _onSelectPaymentMethod(
      SelectPaymentMethod event, Emitter<CartState> emit) {
    if (state is CheckoutState) {
      final currentState = state as CheckoutState;
      emit(currentState.copyWith(paymentMethod: event.paymentMethod));
    }
  }

  void _onSelectAllProducts(SelectAllProducts event, Emitter<CartState> emit) {
    if (state is CheckoutState) {
      final currentState = state as CheckoutState;
      final selectedProductIds = event.isSelected
          ? currentState.products.map((product) => product.id).toList()
          : <String>[];

      final selectedTotalPrice = currentState.products
          .where((product) => selectedProductIds.contains(product.id))
          .fold(0.0, (sum, product) {
        final cart =
            currentState.carts.firstWhere((c) => c.productId == product.id);
        return sum + (product.price * cart.quantity!);
      });

      emit(currentState.copyWith(
        selectedProductIds: selectedProductIds,
        selectedTotalPrice: selectedTotalPrice,
      ));
    }
  }

  void _onCheckoutSingleProduct(
      CheckoutSingleProduct event, Emitter<CartState> emit) async {
    if (state is CheckoutState) {
      final currentState = state as CheckoutState;
      final selectedProduct = currentState.products
          .firstWhere((product) => product.id == event.productId);

      final cart =
          currentState.carts.firstWhere((c) => c.productId == event.productId);

      final totalPrice = selectedProduct.price * cart.quantity!;
      emit(currentState.copyWith(
        selectedProductIds: [event.productId],
        selectedTotalPrice: totalPrice,
      ));
    }
  }

  void _onPlaceOrder(PlaceOrder event, Emitter<CartState> emit) async {
    if (state is CheckoutState) {
      final currentState = state as CheckoutState;
      final selectedProductIds = currentState.selectedProductIds;
      final selectedProducts = currentState.products
          .where((product) => selectedProductIds.contains(product.id))
          .toList();

      final selectedPayment = currentState.paymentMethod;
      final totalPrice = selectedProducts.fold(
        0.0,
        (sum, product) {
          final cart =
              currentState.carts.firstWhere((c) => c.productId == product.id);
          return sum + (product.price * cart.quantity!);
        },
      );

      final productData = selectedProducts.map((product) {
        final cart =
            currentState.carts.firstWhere((c) => c.productId == product.id);
        return {
          'productId': product.id,
          'quantity': cart.quantity,
          'category': product.category,
          'price': product.price
        };
      }).toList();

      for (final product in selectedProducts) {
        final cart =
            currentState.carts.firstWhere((c) => c.productId == product.id);
        await _productService.decreaseProductStock(product.id, cart.quantity!);
      }

      _orderService.addOrder(OrderModel(
        id: '',
        paymentMethod: selectedPayment,
        transactionDate: DateTime.now(),
        totalPrice: totalPrice,
        products: productData,
      ));
      notificationHelper.initLocalNotifications();
      notificationHelper.showNotification("Berhasil ditambahkan ke order");
      await _cartService.deleteSelectedCarts(selectedProductIds);
      emit(OrderPlaced(productData, totalPrice));
    } else {
      emit(const CartError('Failed to order.'));
    }
  }

  @override
  void onTransition(Transition<CartEvent, CartState> transition) {
    super.onTransition(transition);
    print(transition);
  }
}
