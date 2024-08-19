import 'package:final_project_sanbercode/const/palllete.dart';
import 'package:final_project_sanbercode/screen/order_detail.dart';
import 'package:final_project_sanbercode/widgets/filter_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:final_project_sanbercode/blocs/order_bloc/order_bloc.dart';
import 'package:intl/intl.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}


class _OrderListScreenState extends State<OrderListScreen> {
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
   
        title: const Text('Order List'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt_rounded),
            onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) => Dialog(
                child: Expanded(child: FilterForm()),
              ),
            ),
          )
        ],
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderListLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is OrderListLoaded) {
            final orders = state.orders;
            final products = state.products;
            if (orders.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/empty_list.png',
                      height: 200,
                      width: 200,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Order List Not Found.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.white,
                  shadowColor: Colors.black54,
                  child: ListTile(
                    leading: Icon(
                      Icons.shopping_bag_rounded,
                      color: Theme.of(context).primaryColor,
                      size: 40,
                    ),
                    title: Text(
                      'Order ID: ${order.id}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Transaction Date: ${DateFormat('dd-MM-yyyy').format(order.transactionDate!)}',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Total Products: ${order.products?.length ?? 0}',
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Total Price: Rp. ${order.totalPrice}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios_rounded, size: 18),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailScreen(
                            order: order,
                            products: products,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
