import 'package:final_project_sanbercode/blocs/cart_bloc/cart_bloc.dart';
import 'package:final_project_sanbercode/blocs/count_cart_cubit/count_cart_cubit.dart';
import 'package:final_project_sanbercode/const/palllete.dart';
import 'package:final_project_sanbercode/screen/cart_screen.dart';
import 'package:final_project_sanbercode/screen/product/detail.dart';
import 'package:final_project_sanbercode/screen/product/edit.dart';
import 'package:final_project_sanbercode/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:final_project_sanbercode/blocs/product_bloc/product_bloc.dart';
import 'package:final_project_sanbercode/screen/product/create.dart';

class ProductIndexScreen extends StatefulWidget {
  const ProductIndexScreen({super.key});

  @override
  State<ProductIndexScreen> createState() => _ProductIndexScreenState();
}

class _ProductIndexScreenState extends State<ProductIndexScreen> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(ReadDataProduct());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Pallete.primary, Pallete.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          foregroundColor: Pallete.whiteColor,
          title: const Text('Products'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const CartScreen()));
              }, icon: BlocBuilder<CountCartCubit, CountCartState>(
                  builder: (context, state) {
                if (state is TotalQuantityLoaded) {
                  return IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const CartScreen()));
                    },
                    icon: Badge(
                      backgroundColor: Pallete.blackColor,
                      textColor: Pallete.whiteColor,
                      label: Text(state.totalQuantity.toString()),
                      child: const Icon(Icons.shopping_cart_outlined),
                    ),
                  );
                } else {
                  return IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const CartScreen()));
                      },
                      icon: const Icon(Icons.shopping_cart_outlined));
                }
              })),
            ),
          ],
        ),
      ),
      body: BlocConsumer<ProductBloc, ProductState>(listener: (context, state) {
        if (state is ProductLowStock) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Low Stock!'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Beberapa produk memiliki stok kurang dari 4:'),
                    ...state.lowStockProducts.map((product) => Text(
                          '${product.name} (Stock: ${product.stock})',
                        )),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }, builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ProductLoaded) {
          return Column(
            children: [
              _buildSearchField(context),
              if (state.products.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/empty_product.png',
                          height: 200,
                          width: 200,
                        ),
                        const Text(
                          'Product Not Found.',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      final product = state.products[index];
                      return Align(
                        alignment: Alignment.center,
                        child: ProductCard(
                          product: product,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => DetailScreen(
                                          product: product,
                                        )));
                          },
                          editFunction: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductEditScreen(product: product),
                              ),
                            );
                          },
                          deleteFunction: () {
                            context
                                .read<ProductBloc>()
                                .add(DeleteProduct(product.id));
                          },
                          addCartFunction: () {
                            context
                                .read<CartBloc>()
                                .add(AddProductToCart(product.id, 1));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Added to Cart",
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        } else if (state is ProductError) {
          return const Center(
            child: Text('Error'),
          );
        } else {
          return const Center(
            child: Text('Unknown state'),
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ProductCreateScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search), // Ikon kaca pembesar
          labelText: 'Search Products',
          labelStyle:
              const TextStyle(color: Pallete.primary), // Ubah warna label
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), // Border melengkung
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Pallete.primary), // Border saat fokus
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onSubmitted: (query) {
          context.read<ProductBloc>().add(SearchProduct(query));
        },
      ),
    );
  }
}
