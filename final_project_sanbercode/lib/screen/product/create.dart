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

class ProductCreateScreen extends StatefulWidget {
  const ProductCreateScreen({super.key});

  @override
  State<ProductCreateScreen> createState() => _ProductCreateScreenState();
}

class _ProductCreateScreenState extends State<ProductCreateScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productDescriptionController =
      TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  final TextEditingController productStockController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  String? selectedCategory;
  final List<String> categories = [
    'Kretek',
    'Filter',
    'Elektrik',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    productNameController.dispose();
    productDescriptionController.dispose();
    productPriceController.dispose();
    productStockController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

    Future<void> deleteImage(String imageUrl) async {
      final confirmDelete = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Konfirmasi'),
          content:
              const Text('Apakah Anda ingin membatalkan pembuatan produk?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      if (confirmDelete == true) {
        if (imageUrl.isNotEmpty) {
          await context.read<ImagesCubit>().deleteImage(imageUrl: imageUrl);
        }
        Navigator.of(context).pop();
      }
    }

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
        leading: BackButton(
          onPressed: () async {
            final imageUrl = context.read<ImagesCubit>().state.linkGambar ?? '';
            await deleteImage(imageUrl);
          },
        ),
        title: const Text('Create Product'),
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Produk berhasil ditambahkan'),
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
              child: Align(
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
                      controller: productDescriptionController,
                    ),
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
                            print('Category selected: $selectedCategory');
                          },
                        ),
                      ),
                    ),
                    BlocBuilder<ImagesCubit, ImagesState>(
                      builder: (context, imageState) {
                        return Column(
                          children: [
                            Visibility(
                              visible: imageState.linkGambar != null,
                              child: Column(
                                children: [
                                  Container(
                                    height: 150,
                                    width: 150,
                                    margin: const EdgeInsets.all(8),
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Image.network(
                                      fit: BoxFit.cover,
                                      imageState.linkGambar ?? '',
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Text(
                                            'Failed to load image');
                                      },
                                    ),
                                  ),
                                  ButtonPrimary(
                                    onPressed: () =>
                                        editImage(imageState.linkGambar ?? ''),
                                    text: 'Edit Gambar',
                                    size: Size(300, 50),
                                    icon: Icons.image_outlined,
                                    isOutline: true,
                                  ),
                                ],
                              ),
                            ),
                            if (imageState.linkGambar == null &&
                                !imageState.isLoading)
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: ButtonPrimary(
                                  onPressed: pickImage,
                                  text: 'Upload Gambar',
                                  size: const Size(300, 50),
                                  icon: Icons.image,
                                  isOutline: true,
                                ),
                              ),
                            if (imageState.isLoading)
                              CircularProgressIndicator(
                                value: imageState.uploadProgress,
                                backgroundColor: Colors.grey,
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
                          if (productPriceController.text.isEmpty ||
                              productStockController.text.isEmpty ||
                              double.tryParse(productPriceController.text) ==
                                  null ||
                              int.tryParse(productStockController.text) ==
                                  null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Harap isi data dengan benar!'),
                              ),
                            );
                            return;
                          }
                          print('Selected Category: $selectedCategory');

                          context.read<ProductBloc>().add(AddProduct(
                                Product(
                                  id: '',
                                  name: productNameController.text,
                                  description:
                                      productDescriptionController.text,
                                  price:
                                      double.parse(productPriceController.text),
                                  imageURL: context
                                          .read<ImagesCubit>()
                                          .state
                                          .linkGambar ??
                                      '',
                                  category: selectedCategory ?? 'Kretek',
                                  stock: int.parse(productStockController.text),
                                ),
                              ));
                          context.read<ImagesCubit>().deleteImageLink();
                        },
                        text: 'Buat Product',
                        size: const Size(320, 50))
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
