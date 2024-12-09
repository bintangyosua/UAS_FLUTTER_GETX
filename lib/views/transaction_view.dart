import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_getx/components/sidemenu.dart';
import 'package:flutter_getx/controllers/transaction_controller.dart';
import 'package:flutter_getx/models/products.dart';
import 'package:flutter_getx/models/transactions.dart';
import 'package:get/get.dart';

class TransactionView extends StatelessWidget {
  final products = <Product>[].obs; // Daftar produk
  final TransactionController controller = Get.put(TransactionController());
  final nameController = TextEditingController();
  final priceController = TextEditingController();

  TransactionView({super.key});

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
      onConfirm: () {
        // Logika menyelesaikan transaksi, misalnya mengirim data ke server
        controller.addTransaction(Transaction(id: _generateRandomId(), totalPrice: totalPrice));
        products.clear();
        Get.back();
      },
      onCancel: () => Get.back(),
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
                decoration: const InputDecoration(labelText: 'Nama Produk'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Harga'),
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
                    Get.snackbar('Error', 'Nama produk dan harga harus valid');
                  }
                },
                child: Text(product != null ? 'Perbarui' : 'Tambah'),
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
      onConfirm: () {
        // Hapus produk dari daftar
        products.remove(product);
        Get.back();
      },
      onCancel: () => Get.back(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Kasir'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Get.toNamed('/profile');
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialog(),
        child: const Icon(Icons.add),
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
                  title: Text(product.name),
                  subtitle: Text('Harga: Rp${product.price.toStringAsFixed(2)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tombol Edit
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showDialog(product: product),
                      ),
                      // Tombol Hapus
                      IconButton(
                        icon: const Icon(Icons.delete),
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Rp${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: products.isEmpty ? null : completeTransaction,
              child: const Text('Selesaikan Transaksi'),
            ),
          ),
        ],
      ),
    ));
  }
}
