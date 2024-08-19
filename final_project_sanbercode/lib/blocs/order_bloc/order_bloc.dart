import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:final_project_sanbercode/model/order.dart';
import 'package:final_project_sanbercode/model/product.dart';
import 'package:final_project_sanbercode/service/order_service.dart';
import 'package:final_project_sanbercode/service/product_service.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  StreamSubscription<List<OrderModel>>? _orderSubscription;
  final OrderService _orderService = OrderService();
  final ProductService _productService = ProductService();

  OrderBloc() : super(OrderInitial()) {
    on<ReadOrderEvent>(_onReadOrderEvent);
    on<LoadOrderEvent>(_onLoadOrderEvent);
    on<FilterOrdersEvent>(_onFilterOrdersEvent);
    on<ClearFilterEvent>(_onClearFilterEvent);
  }

  Future<void> _onReadOrderEvent(ReadOrderEvent event, Emitter<OrderState> emit) async {
    emit(OrderListLoading());
    try {
      final orderStream = _orderService.getOrderList();
      _orderSubscription?.cancel();
      _orderSubscription = orderStream.listen(
        (orderLists) async {
          List<OrderModel> validOrders = [];
          List<Product> validProducts = [];

          for (final order in orderLists) {
            bool allProductsValid = true;
            List<Product> productsForOrder = [];

            for (final productOrder in order.products!) {
              try {
                var product = await _productService.getProductById(productOrder['productId']!);
                productsForOrder.add(product);
              } catch (e) {
                allProductsValid = false;
                await _orderService.deleteOrder(order.id!);
                break;
              }
            }

            if (allProductsValid && productsForOrder.isNotEmpty) {
              validOrders.add(order);
              validProducts.addAll(productsForOrder);
            }
          }

          add(LoadOrderEvent(validOrders, validProducts));
        },
        onError: (error) {
          print('Stream error $error');
          emit(OrderListError(error.toString()));
        },
      );
    } catch (e) {
      emit(OrderListError(e.toString()));
    }
  }

  void _onLoadOrderEvent(LoadOrderEvent event, Emitter<OrderState> emit) {
    emit(OrderListLoading());
    try {
      emit(OrderListLoaded(event.orders, event.products));
    } catch (e) {
      emit(OrderListError(e.toString()));
    }
  }

  Future<void> _onFilterOrdersEvent(FilterOrdersEvent event, Emitter<OrderState> emit) async {
    emit(OrderListLoading());
    try {
      final orderStream = _orderService.getOrderList();
      _orderSubscription?.cancel();
      _orderSubscription = orderStream.listen(
        (orderLists) async {
          List<OrderModel> filteredOrders = [];

          for (final order in orderLists) {
            bool dateInRange = true;
            if (event.startDate != null && event.endDate != null) {
              dateInRange = order.transactionDate != null &&
                  order.transactionDate!.isAfter(event.startDate!) &&
                  order.transactionDate!.isBefore(event.endDate!);
            }

            bool priceInRange = true;
            if (event.minPrice != null && event.maxPrice != null) {
              priceInRange = order.totalPrice != null &&
                  order.totalPrice! >= event.minPrice! &&
                  order.totalPrice! <= event.maxPrice!;
            }

            bool categoryMatches = true;
            if (event.category != null && event.category!.isNotEmpty) {
              var productCategories = await Future.wait(order.products!.map((productOrder) async {
                var product = await _productService.getProductById(productOrder['productId']!);
                return product.category == event.category;
              }));
              categoryMatches = productCategories.contains(true);
            }

            if (dateInRange && priceInRange && categoryMatches) {
              filteredOrders.add(order);
            }
          }

          List<Product> products = [];
          for (final order in filteredOrders) {
            for (final productOrder in order.products!) {
              var product = await _productService.getProductById(productOrder['productId']!);
              products.add(product);
            }
          }

          add(LoadOrderEvent(filteredOrders, products));
        },
        onError: (error) {
          print('Stream error $error');
          emit(OrderListError(error.toString()));
        },
      );
    } catch (e) {
      emit(OrderListError(e.toString()));
    }
  }

  void _onClearFilterEvent(ClearFilterEvent event, Emitter<OrderState> emit) {
    add(ReadOrderEvent());
  }

  @override
  Future<void> close() {
    _orderSubscription?.cancel();
    return super.close();
  }

  @override
  void onTransition(Transition<OrderEvent, OrderState> transition) {
    super.onTransition(transition);
    print(transition);
  }
}
