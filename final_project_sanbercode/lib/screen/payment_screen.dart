import 'package:final_project_sanbercode/blocs/cart_bloc/cart_bloc.dart';
import 'package:final_project_sanbercode/blocs/payment_list_cubit/payment_list_cubit.dart';
import 'package:final_project_sanbercode/const/palllete.dart';
import 'package:final_project_sanbercode/model/payment_list.dart';
import 'package:final_project_sanbercode/screen/main_screen.dart';
import 'package:final_project_sanbercode/screen/status_screen.dart';
import 'package:final_project_sanbercode/widgets/button_primary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selectedMethod;

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
        title: const Text('Payment List'),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CheckoutState) {
            return Column(
              children: [
                Expanded(
                  child: BlocBuilder<PaymentListCubit, PaymentListState>(
                    builder: (context, state) {
                      if (state is PaymentListLoaded) {
                        final paymentList = state.paymentlist;
                        return ListView.builder(
                          itemCount: paymentList.length,
                          itemBuilder: (context, index) {
                            PaymentType paymentType = paymentList[index];
                            return Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(paymentType.type),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Column(
                                      children:
                                          paymentType.methods.map((method) {
                                        return RadioListTile<String>(
                                          title: Text(method.name),
                                          value: method.name,
                                          groupValue: _selectedMethod,
                                          onChanged: (String? value) {
                                            setState(() {
                                              _selectedMethod = value;
                                            });
                                            context.read<CartBloc>().add(
                                                SelectPaymentMethod(value!));
                                          },
                                          secondary: Image.network(
                                            height: 35,
                                            method.imageLink,
                                            fit: BoxFit.fitHeight,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: const Color.fromRGBO(210, 210, 210, 0.69),
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ButtonPrimary(
                          onPressed: () => cancelDialog(context),
                          text: 'Cancel Order',
                          size: const Size(120, 60)),
                      ButtonPrimary(
                          onPressed: () {
                            if (_selectedMethod != null) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const StatusScreen(),
                                ),
                                (route) => false,
                              );
                              context.read<CartBloc>().add(PlaceOrder());
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Please select a payment method'),
                                ),
                              );
                            }
                          },
                          text: 'Checkout',
                          size: const Size(120, 60)),
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

  void cancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('Are you sure want to cancel order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const MainScreen()));
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
