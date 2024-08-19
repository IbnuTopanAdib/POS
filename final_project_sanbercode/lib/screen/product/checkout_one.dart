import 'package:final_project_sanbercode/blocs/cart_bloc/cart_bloc.dart';
import 'package:final_project_sanbercode/blocs/payment_list_cubit/payment_list_cubit.dart';
import 'package:final_project_sanbercode/const/palllete.dart';
import 'package:final_project_sanbercode/model/product.dart';
import 'package:final_project_sanbercode/screen/payment_screen.dart';
import 'package:final_project_sanbercode/widgets/button_primary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutOne extends StatefulWidget {
  final Product product;
  const CheckoutOne({super.key, required this.product});

  @override
  State<CheckoutOne> createState() => _CheckoutOneState();
}

class _CheckoutOneState extends State<CheckoutOne> {
  int quantity = 1;

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
        title: const Text('Checkout'),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          final height = MediaQuery.of(context).size.height;
          final width = MediaQuery.of(context).size.width;

          if (state is CheckoutState) {
            return Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: height / 2.5,
                    width: width / 2.5,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(widget.product.imageURL))),
                  ),
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.product.category,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text('Total harga: Rp.${widget.product.price * quantity}'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: quantity == 1
                            ?  Icon(
                                Icons.remove,
                                color: Pallete.primary.withOpacity(0.3),
                                size: 26,
                              )
                            : const Icon(
                                Icons.remove,
                                color: Pallete.primary,
                                size: 26,
                              ),
                        onPressed: () {
                          setState(() {
                            if (quantity > 1) {
                              quantity -= 1;
                            }
                          });
                        },
                      ),
                      Text(
                        '$quantity',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.add,
                          color: Pallete.primary,
                          size: 26,
                        ),
                        onPressed: () {
                          setState(() {
                            quantity += 1;
                          });
                        },
                      ),
                    ],
                  ),
                  ButtonPrimary(
                      onPressed: () {
                        context
                            .read<CartBloc>()
                            .add(AddProductToCart(widget.product.id, quantity));
                        context
                            .read<CartBloc>()
                            .add(CheckoutSingleProduct(widget.product.id));
                        context.read<PaymentListCubit>().load_payment_list();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const PaymentScreen(),
                        ));
                      },
                      text: 'Proceed Payment',
                      size: const Size(150, 60))
                ],
              ),
            );
          } else if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(
              child: Text('Error'),
            );
          }
        },
      ),
    );
  }
}
