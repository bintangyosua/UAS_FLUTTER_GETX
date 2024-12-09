import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_getx/models/transaction_item.dart';
import 'package:flutter_getx/widgets/sidemenu.dart';
import 'package:flutter_getx/controllers/cashier_controller.dart';
import 'package:flutter_getx/controllers/product_controller.dart';
import 'package:flutter_getx/models/products.dart';
import 'package:flutter_getx/models/transactions.dart';
import 'package:get/get.dart';

class CashierView extends StatelessWidget {
  final products = <TransactionItem>[].obs; // Daftar produk transaksi dengan quantity
  final CashierController controller = Get.put(CashierController());
  final ProductController productController = Get.put(ProductController());
  final nameController = TextEditingController();
  final priceController = TextEditingController();

  CashierView({super.key});

  void addProduct(Product product) {
    // Cek apakah produk sudah ada di daftar transaksi
    final existingItem = products.firstWhereOrNull((item) => item.id == product.id);

    if (existingItem != null) {
      // Jika produk sudah ada, tambahkan kuantitasnya
      existingItem.quantity++;
    } else {
      // Jika produk belum ada, tambahkan produk baru
      products.add(TransactionItem(
        id: product.id,
        name: product.name,
        price: product.price,
        quantity: 1, // Default quantity is 1
      ));
    }
  }

  void _increaseQuantity(TransactionItem item) {
    // Directly change the quantity of the item, then trigger a UI update
    item.quantity++;
    products.refresh(); // This triggers a rebuild of the list
  }

  void _decreaseQuantity(TransactionItem item) {
    // If quantity is greater than 1, reduce it; otherwise, remove the item
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      // Remove the product from the list when quantity reaches 1 and the decrease action is triggered
      products.remove(item);
    }
    products.refresh(); // Trigger the UI update after quantity change or removal
  }

  int get totalPrice {
    return products.fold(0, (sum, item) => sum + (item.price * item.quantity).toInt());
  }

  int _generateRandomId() {
    final random = Random();
    return random.nextInt(100000);
  }

  void completeTransaction() {
    Get.defaultDialog(
      title: 'Konfirmasi',
      backgroundColor: Colors.white,
      middleText: 'Apakah Anda yakin ingin menyelesaikan transaksi?',
      titleStyle: const TextStyle(color: Colors.black),
      middleTextStyle: const TextStyle(color: Colors.black),
      onConfirm: () {
        // Logika menyelesaikan transaksi
        controller.addTransaction(Transaction(id: _generateRandomId(), totalPrice: totalPrice));
        products.clear(); // Clear products after transaction completion
        Get.back(); // Close the dialog
      },
      onCancel: () => Get.back(),
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.black,
      buttonColor: Colors.black,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Halaman Kasir'),
        backgroundColor: Colors.white,
      ),
      drawer: const Sidemenu(),
      endDrawer: Obx(() {
        if (productController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Drawer(
            backgroundColor: Colors.white,
            child: ListView.builder(
              itemCount: productController.products.length,
              itemBuilder: (context, index) {
                final product = productController.products[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('Rp${product.price}'),
                  trailing: const Icon(Icons.add), // Add icon here
                  onTap: () {
                    addProduct(product);
                  },
                );
              },
            ),
          );
        }
      }),
      body: Obx(() {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (products.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    'Belum ada produk di dalam daftar transaksi. Klik button kanan atas untuk menambahkan produk.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            if (products.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final item = products[index];
                    return ListTile(
                      title: Text(item.name, style: const TextStyle(color: Colors.black)),
                      subtitle: Text('Harga: ${Transaction.formatRupiah(item.price)} x ${item.quantity}', style: const TextStyle(color: Colors.black)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Tombol tambah kuantitas
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.black),
                            onPressed: () {
                              _increaseQuantity(item); // Increase quantity
                            },
                          ),
                          Text(item.quantity.toString(), style: const TextStyle(color: Colors.black, fontSize: 18)),
                          // Tombol kurangi kuantitas
                          IconButton(
                            icon: const Icon(Icons.remove, color: Colors.black),
                            onPressed: () {
                              _decreaseQuantity(item); // Decrease quantity
                            },
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Text(
                    '${Transaction.formatRupiah(totalPrice as double)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: products.isEmpty ? null : completeTransaction,
                child: const Text('Selesaikan Transaksi'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              ),
            ),
          ],
        );
      }),
    );
  }
}
