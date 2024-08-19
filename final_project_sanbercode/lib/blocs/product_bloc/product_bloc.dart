import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:final_project_sanbercode/model/product.dart';
import 'package:final_project_sanbercode/service/product_service.dart';
import 'package:final_project_sanbercode/utils/notification_helper.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductService productService;
  StreamSubscription<List<Product>>? _productSubscription;
  final notificationHelper = NotificationHelper();

  ProductBloc({required this.productService}) : super(ProductInitial()) {
    on<ReadDataProduct>(_onReadDataProduct);
    on<LoadProducts>(_onLoadProducts);
    on<SearchProduct>(_onSearchProduct);
    on<LoadProductById>(_onLoadProductById);
    on<AddProduct>(_onAddProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
  }

  Future<void> _onReadDataProduct(ReadDataProduct event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final productStream = productService.getProducts();
      _productSubscription?.cancel();
      _productSubscription = productStream.listen(
        (products) {
          add(LoadProducts(products));
        },
        onError: (error) {
          print("Stream error: $error");
          emit(ProductError());
        },
      );
    } catch (e) {
      print("Exception: $e");
      emit(ProductError());
    }
  }

  void _onLoadProducts(LoadProducts event, Emitter<ProductState> emit) {
    try {
      emit(ProductLoaded(event.products));
      final productsWithLowStock =
          event.products.where((product) => product.stock < 4).toList();
      if (productsWithLowStock.isNotEmpty) {
        emit(ProductLowStock(productsWithLowStock));
        notificationHelper.initLocalNotifications();
        notificationHelper.showNotification("Stok Hampir Habis Bos!");
      }
      emit(ProductLoaded(event.products));
    } catch (e) {
      emit(ProductError());
    }
  }

  Future<void> _onSearchProduct(SearchProduct event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final results = await productService.searchProducts(event.query);
      emit(ProductLoaded(results));
    } catch (e) {
      emit(ProductError());
    }
  }

  Future<void> _onLoadProductById(LoadProductById event, Emitter<ProductState> emit) async {
    try {
      final product = await productService.getProductById(event.id);
      print("Product detail loaded: ${product.name}");
      emit(ProductByIdLoaded(product));
    } catch (e) {
      print("Error loading product detail: $e");
    }
  }

  Future<void> _onAddProduct(AddProduct event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      await productService.addProduct(event.product);
      emit(ProductAdded());
    } catch (e) {
      emit(ProductError());
    }
  }

  Future<void> _onUpdateProduct(UpdateProduct event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      await productService.updateProduct(event.product);
      emit(ProductUpdated());
    } catch (e) {
      emit(ProductError());
    }
  }

  Future<void> _onDeleteProduct(DeleteProduct event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      await productService.deleteProduct(event.productId);
      add(ReadDataProduct());
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> close() {
    _productSubscription?.cancel();
    return super.close();
  }

  @override
  void onTransition(Transition<ProductEvent, ProductState> transition) {
    super.onTransition(transition);
    print(transition);
  }
}
