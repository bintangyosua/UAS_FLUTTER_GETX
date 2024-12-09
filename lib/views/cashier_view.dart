import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_getx/widgets/sidemenu.dart';
import 'package:flutter_getx/controllers/cashier_controller.dart';
import 'package:flutter_getx/models/products.dart';
import 'package:flutter_getx/models/transactions.dart';
import 'package:get/get.dart';

class CashierView extends StatelessWidget {
  final products = <Product>[].obs; // Daftar produk
  final CashierController controller = Get.put(CashierController());
  final nameController = TextEditingController();
  final priceController = TextEditingController();

  CashierView({super.key});

  void addProduct(Product product) {
    products.add(product);
  }

  int get totalPrice {
    return products.fold(0, (sum, item) => (sum + item.price).toInt());
  }

  int _generateRandomId() {
    final random = Random();
    return random.nextInt(100000);
  }

  void completeTransaction() {
    Get.defaultDialog(
      title: 'Konfirmasi',
      middleText: 'Apakah Anda yakin ingin menyelesaikan transaksi?',
      titleStyle: const TextStyle(color: Colors.black),
      middleTextStyle: const TextStyle(color: Colors.black),
      onConfirm: () {
        // Logika menyelesaikan transaksi, misalnya mengirim data ke server
        controller.addTransaction(Transaction(id: _generateRandomId(), totalPrice: totalPrice));
        products.clear();
        Get.back();
      },
      onCancel: () => Get.back(),
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.black,
      buttonColor: Colors.black, // Button in black color
    );
  }

  void _showDialog({Product? product}) {
    // Jika produk ada, set nama dan harga produk ke dalam controller
    if (product != null) {
      nameController.text = product.name;
      priceController.text = product.price.toString();
    } else {
      nameController.clear();
      priceController.clear();
    }

    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Produk',
                  labelStyle: TextStyle(color: Colors.black), // Black label text
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  labelStyle: TextStyle(color: Colors.black), // Black label text
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final name = nameController.text;
                  final price = double.tryParse(priceController.text) ?? 0.0;

                  if (name.isNotEmpty && price > 0) {
                    if (product != null) {
                      // Update produk yang ada
                      int index = products.indexOf(product);
                      if (index != -1) {
                        products[index] = Product(name: name, price: price);
                      }
                    } else {
                      // Menambahkan produk baru
                      addProduct(Product(name: name, price: price));
                    }
                    Get.back();
                  } else {
                    Get.snackbar('Error', 'Nama produk dan harga harus valid', backgroundColor: Colors.black, colorText: Colors.white);
                  }
                },
                child: Text(product != null ? 'Perbarui' : 'Tambah', style: TextStyle(color: Colors.black),),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white), // Black button
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(Product product) {
    Get.defaultDialog(
      title: 'Konfirmasi Hapus',
      middleText: 'Apakah Anda yakin ingin menghapus produk "${product.name}"?',
      titleStyle: const TextStyle(color: Colors.black),
      middleTextStyle: const TextStyle(color: Colors.black),
      onConfirm: () {
        // Hapus produk dari daftar
        products.remove(product);
        Get.back();
      },
      onCancel: () => Get.back(),
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.black,
      buttonColor: Colors.black, // Button in black color
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background for the whole screen
      appBar: AppBar(
        title: const Text('Halaman Kasir'),
        backgroundColor: Colors.white, // Black AppBar
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialog(),
        child: const Icon(Icons.add),
        backgroundColor: Colors.white, // Black FAB
      ),
      drawer: const Sidemenu(),
      body: Obx(() => Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  title: Text(product.name, style: const TextStyle(color: Colors.black)), // Black text
                  subtitle: Text('Harga: Rp${product.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.black)), // Black text
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tombol Edit
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.black), // Black icon
                        onPressed: () => _showDialog(product: product),
                      ),
                      // Tombol Hapus
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.white), // Black icon
                        onPressed: () => _showDeleteDialog(product),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Harga:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black), // Black text
                ),
                Text(
                  'Rp${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black), // Black text
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: products.isEmpty ? null : completeTransaction,
              child: const Text('Selesaikan Transaksi'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white), // Black button
            ),
          ),
        ],
      )),
    );
  }
}
