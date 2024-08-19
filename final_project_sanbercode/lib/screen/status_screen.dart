import 'package:final_project_sanbercode/blocs/cart_bloc/cart_bloc.dart';
import 'package:final_project_sanbercode/screen/main_screen.dart';
import 'package:final_project_sanbercode/widgets/button_primary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/status_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is OrderPlaced) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle,
                          color: Colors.white, size: 80),
                      const SizedBox(height: 20),
                      const Text(
                        'Order placed successfully!',
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      ButtonPrimary(
                          onPressed: () {
                            downloadPDFDialog(context, state as OrderPlaced);
                          },
                          text: 'Download PDF',
                          size: const Size(250, 50)),
                      const SizedBox(height: 20),
                      ButtonPrimary(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MainScreen(),
                              ),
                              (route) => false,
                            );
                          },
                          text: 'Back To Home',
                          size: const Size(250, 50)),
                    ],
                  ),
                ),
              );
            } else if (state is CartError) {
              return Center(child: Text('Error: ${state.message}'));
            }  else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  void downloadPDFDialog(BuildContext context, OrderPlaced orderState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content:
            const Text('You are about to generate the report order. Proceed?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              generateAndSavePDF(orderState);
              Navigator.of(context).pop();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  Future<void> generateAndSavePDF(OrderPlaced orderState) async {
    final image = await imageFromAssetBundle('assets/images/logo.png');
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(18.00),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Align(
                  alignment: pw.Alignment.topCenter,
                  child: pw.Image(image, width: 100, height: 100),
                ),
                pw.SizedBox(height: 20),
                pw.Center(
                  child: pw.Text('Order Report',
                      style: const pw.TextStyle(fontSize: 24)),
                ),
                pw.SizedBox(height: 20),
                pw.Text('Order Date: ${DateTime.now().toLocal()}',
                    style: const pw.TextStyle(fontSize: 18)),
                pw.SizedBox(height: 20),
                pw.Text('Products:', style: const pw.TextStyle(fontSize: 18)),
                pw.Table(
                  border: pw.TableBorder.all(),
                  children: [
                    pw.TableRow(children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Product ID',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Quantity',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Price (Rp)',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Category',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ]),
                    ...orderState.productData.map((product) {
                      return pw.TableRow(children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(product['productId'].toString()),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(product['quantity'].toString()),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(product['price'].toString()),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(product['category'].toString()),
                        ),
                      ]);
                    }).toList(),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Text('Total Price: Rp ${orderState.totalPrice}',
                    style: const pw.TextStyle(fontSize: 18)),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }
}
