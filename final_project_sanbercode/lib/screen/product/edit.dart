import 'package:final_project_sanbercode/blocs/image_cubit/images_cubit.dart';
import 'package:final_project_sanbercode/blocs/product_bloc/product_bloc.dart';
import 'package:final_project_sanbercode/const/palllete.dart';
import 'package:final_project_sanbercode/model/product.dart';
import 'package:final_project_sanbercode/screen/main_screen.dart';

import 'package:final_project_sanbercode/widgets/button_primary.dart';
import 'package:final_project_sanbercode/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProductEditScreen extends StatefulWidget {
  final Product product;

  const ProductEditScreen({super.key, required this.product});

  @override
  State<ProductEditScreen> createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  late TextEditingController productNameController;
  late TextEditingController productDescriptionController;
  late TextEditingController productImageController;
  late TextEditingController productPriceController;
  late TextEditingController productStockController;
  late String? selectedCategory;
  late String imageUrl;
  final List<String> categories = [
    'Kretek',
    'Filter',
    'Elektrik',
  ];

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      context.read<ImagesCubit>().uploadImage(path: image.path);
    }
  }

  Future<void> editImage(String imageUrl) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      context
          .read<ImagesCubit>()
          .editImage(path: image.path, imageUrl: imageUrl);
    }
  }

  @override
  void initState() {
    super.initState();
    productNameController = TextEditingController(text: widget.product.name);
    productDescriptionController =
        TextEditingController(text: widget.product.description);
    productImageController =
        TextEditingController(text: widget.product.imageURL);
    productPriceController =
        TextEditingController(text: widget.product.price.toString());
    productStockController =
        TextEditingController(text: widget.product.stock.toString());
    selectedCategory = widget.product.category.toString();
    imageUrl = widget.product.imageURL;
  }

  @override
  void dispose() {
    productDescriptionController.dispose();
    productNameController.dispose();
    productImageController.dispose();
    productPriceController.dispose();
    productStockController.dispose();
    super.dispose();
  }

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
        title: const Text('Edit Product'),
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: const Text('Produk berhasil diedit'),
              ),
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const MainScreen(),
              ),
              (route) => false,
            );
            context.read<ProductBloc>().add(ReadDataProduct());
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  CustomFormField(
                      text: 'Name', controller: productNameController),
                  CustomFormField(
                      text: 'Description',
                      controller: productDescriptionController),
                  CustomFormField(
                    text: 'Price',
                    controller: productPriceController,
                    keyboardType: TextInputType.number,
                  ),
                  CustomFormField(
                    text: 'Stock',
                    controller: productStockController,
                    keyboardType: TextInputType.number,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 300),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Select Category',
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Pallete.primary,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Pallete.secondary,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        value: selectedCategory,
                        items: categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                      ),
                    ),
                  ),
                  BlocBuilder<ImagesCubit, ImagesState>(
                    builder: (context, imageState) {
                      if (imageState.linkGambar != null &&
                          imageState.linkGambar != imageUrl) {
                        imageUrl = imageState.linkGambar!;
                      }

                      return Column(
                        children: [
                          Container(
                            height: 150,
                            width: 150,
                            margin: const EdgeInsets.all(8),
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.network(
                              fit: BoxFit.cover,
                              imageUrl,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Text('Failed to load image');
                              },
                            ),
                          ),
                          ButtonPrimary(
                            onPressed: () => editImage(imageUrl),
                            text: 'Edit Gambar',
                            size: const Size(300, 50),
                            icon: Icons.image_outlined,
                            isOutline: true,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ButtonPrimary(
                      onPressed: () {
                        context.read<ProductBloc>().add(UpdateProduct(
                              Product(
                                id: widget.product.id,
                                name: productNameController.text,
                                description: productDescriptionController.text,
                                price:
                                    double.parse(productPriceController.text),
                                imageURL: context
                                        .read<ImagesCubit>()
                                        .state
                                        .linkGambar ??
                                    imageUrl,
                                category: selectedCategory ?? 'Kretek',
                                stock: int.parse(productStockController.text),
                              ),
                            ));
                      },
                      text: 'Update Product',
                      size: const Size(350, 50))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
