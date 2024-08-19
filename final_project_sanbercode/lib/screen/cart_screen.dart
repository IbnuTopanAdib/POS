import 'package:final_project_sanbercode/blocs/cart_bloc/cart_bloc.dart';
import 'package:final_project_sanbercode/blocs/payment_list_cubit/payment_list_cubit.dart';
import 'package:final_project_sanbercode/const/palllete.dart';
import 'package:final_project_sanbercode/screen/payment_screen.dart';
import 'package:final_project_sanbercode/widgets/button_primary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: const Text('Cart'),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CheckoutState) {
            final allSelected =
                state.products.length == state.selectedProductIds.length;
            if (state.products.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/empty_cart.png',
                      height: 200,
                      width: 200,
                    ),
                    const Text(
                      'Cart is Empty.',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      final product = state.products[index];
                      final cart = state.carts
                          .firstWhere((c) => c.productId == product.id);
                      final isSelected =
                          state.selectedProductIds.contains(product.id);

                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      width: 1,
                                      color: Pallete.primary.withOpacity(0.5)),
                                  image: DecorationImage(
                                    image: NetworkImage(product.imageURL),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      product.category,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Rp. ${product.price.toString()}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: cart.quantity == 1
                                              ? const Icon(
                                                  Icons.delete,
                                                  color: Pallete.primary,
                                                  size: 26,
                                                )
                                              : const Icon(
                                                  Icons.remove,
                                                  color: Pallete.primary,
                                                  size: 26,
                                                ),
                                          onPressed: () {
                                            context.read<CartBloc>().add(
                                                DecreaseQuantity(cart.id!));
                                          },
                                        ),
                                        Text(
                                          '${cart.quantity}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.add,
                                            color: Pallete.primary,
                                            size: 26,
                                          ),
                                          onPressed: () {
                                            context.read<CartBloc>().add(
                                                IncreaseQuantity(cart.id!));
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Checkbox(
                                value: isSelected,
                                onChanged: (value) {
                                  context
                                      .read<CartBloc>()
                                      .add(SelectProduct(product.id, value!));
                                },
                                activeColor: Pallete.primary,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  color: Color.fromRGBO(210, 210, 210, 0.69),
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: allSelected,
                            onChanged: (value) {
                              context
                                  .read<CartBloc>()
                                  .add(SelectAllProducts(value!));
                            },
                            activeColor: Pallete.primary,
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          const Text(
                            'Semua',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Text(
                        'Total: Rp. ${state.selectedTotalPrice}',
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      ButtonPrimary(
                          onPressed: state.selectedProductIds.isNotEmpty
                              ? () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const PaymentScreen(),
                                  ));

                                  context
                                      .read<PaymentListCubit>()
                                      .load_payment_list();
                                }
                              : null,
                          text: 'Checkout',
                          size: const Size(120, 60))
                    ],
                  ),
                )
              ],
            );
          } else if (state is CartError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
