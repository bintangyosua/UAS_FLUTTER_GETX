import 'package:flutter/material.dart';
import 'package:flutter_getx/controllers/product_controller.dart';
import 'package:flutter_getx/models/products.dart';
import 'package:flutter_getx/models/transactions.dart';
import 'package:flutter_getx/widgets/sidemenu.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';

class ProductView extends StatelessWidget {
  final ProductController controller = Get.put(ProductController());

  ProductView({super.key});

  int _generateRandomId() {
    final random = Random();
    return random.nextInt(100000);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Daftar Produk'),
        backgroundColor: Colors.white,
      ),
      drawer: const Sidemenu(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final product = controller.products[index];
            return ListTile(
              title: Text(product.name, style: const TextStyle(color: Colors.black)),
              subtitle: Text('Harga: ${Transaction.formatRupiah(product.price)}', style: const TextStyle(color: Colors.black)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.black),
                    onPressed: () => _showProductDialog(context, product),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.black),
                    onPressed: () => _showDeleteDialog(product),
                  ),
                ],
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductDialog(context),
        child: const Icon(Icons.add),
        backgroundColor: Colors.white,
      ),
    );
  }

  // Dialog untuk menambah atau mengedit produk
  void _showProductDialog(BuildContext context, [Product? product]) {
  final nameController = TextEditingController(text: product?.name ?? '');
  final priceController = TextEditingController(text: product != null ? product.price.toString() : '');

  Get.dialog(
    Dialog(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Produk',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                labelText: 'Harga',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text;
                final price = double.tryParse(priceController.text) ?? 0.0;

                if (name.isNotEmpty && price > 0) {
                  // Jika kita sedang mengedit, gunakan ID produk yang sudah ada
                  final updatedProduct = Product(
                    id: product?.id ?? _generateRandomId(),  // Gunakan ID yang ada jika produk sudah ada
                    name: name,
                    price: price,
                  );

                  if (product != null && product.id != null) {
                    // Jika produk sudah ada, lakukan edit
                    controller.editProduct(updatedProduct);
                  } else {
                    // Jika produk baru, lakukan tambah
                    controller.addProduct(updatedProduct);
                  }

                  Get.back();
                } else {
                  Get.snackbar('Error', 'Nama, harga, dan kuantitas produk harus valid');
                }
              },
              child: Text(product != null ? 'Perbarui Produk' : 'Tambah Produk'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            ),
          ],
        ),
      ),
    ),
  );
}


  // Dialog konfirmasi untuk menghapus produk
  void _showDeleteDialog(Product product) {
    Get.defaultDialog(
      backgroundColor: Colors.white,
      title: 'Konfirmasi Hapus',
      middleText: 'Apakah Anda yakin ingin menghapus produk "${product.name}"?',
      onConfirm: () async {
        // Hapus produk dari Supabase
        try {
          await Supabase.instance.client.from('products').delete().eq('id', product.id as Object);
          controller.fetchProducts();  // Refresh data produk
          Get.snackbar('Success', 'Produk berhasil dihapus');
        } catch (e) {
          Get.snackbar('Error', e.toString());
        }
        Get.back();
      },
      onCancel: () => Get.back(),
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.black,
      buttonColor: Colors.black,
    );
  }
}
