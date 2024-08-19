import 'package:final_project_sanbercode/const/palllete.dart';
import 'package:final_project_sanbercode/model/product.dart';
import 'package:final_project_sanbercode/widgets/button_primary.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback editFunction;
  final VoidCallback deleteFunction;
  final VoidCallback addCartFunction;
  const ProductCard(
      {super.key,
      required this.product,
      required this.onTap,
      required this.editFunction,
      required this.deleteFunction,
      required this.addCartFunction});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Card(
          color: Colors.grey[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 1,
          shadowColor: Pallete.primary.withOpacity(0.5),
          child: SizedBox(
            height: 350,
            width: 300,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            image: DecorationImage(
                                image: NetworkImage(
                                  product.imageURL,
                                ),
                                fit: BoxFit.cover),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined,
                                      color: Pallete.whiteColor),
                                  onPressed: editFunction,
                                  tooltip: 'Edit',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Pallete.whiteColor),
                                  onPressed: deleteFunction,
                                  tooltip: 'Hapus',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Kategori Produk : ${product.category}',
                          style: const TextStyle(
                              color: Color.fromRGBO(166, 166, 166, 1),
                              fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Stok: ${product.stock}",
                                style: const TextStyle(
                                    color: Color.fromRGBO(72, 72, 72, 1),
                                    fontSize: 14)),
                            Text("Rp ${product.price}",
                                style: const TextStyle(
                                    color: Color.fromRGBO(72, 72, 72, 1),
                                    fontSize: 14)),
                          ],
                        ),
                        const Spacer(),
                        ButtonPrimary(
                          onPressed: addCartFunction,
                          text: 'Add to Cart',
                          size: const Size(30, 40),
                          color: Pallete.primary,
                          icon: Icons.shopping_cart_checkout,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
