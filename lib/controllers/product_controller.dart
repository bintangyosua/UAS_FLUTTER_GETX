import 'package:flutter_getx/models/products.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductController extends GetxController {
  final _supabaseClient = Supabase.instance.client;
  var isLoading = false.obs;
  var products = <Product>[].obs;  // Daftar produk yang akan ditampilkan

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  // Mengambil produk dari Supabase
  void fetchProducts() async {
    isLoading(true);
    try {
      final response = await _supabaseClient.from('products').select();
      products.value = (response as List).map((e) => Product.fromJson(e)).toList();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  // Fungsi untuk menambah produk baru
  void addProduct(Product product) async {
    isLoading(true);
    try {
      final response = await _supabaseClient.from('products').insert(product.toJson());
      fetchProducts();  // Refresh data produk setelah berhasil ditambahkan
      Get.snackbar('Success', 'Produk berhasil ditambahkan');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  // Fungsi untuk mengedit produk
  void editProduct(Product product) async {
    isLoading(true);
    try {
      final response = await _supabaseClient.from('products').update(product.toJson()).eq('id', product.id as Object);
      fetchProducts();  // Refresh data produk setelah berhasil diupdate
      Get.snackbar('Success', 'Produk berhasil diperbarui');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
