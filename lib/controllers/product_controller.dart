import 'package:flutter_getx/models/products.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductController extends GetxController {
  final _supabaseClient = Supabase.instance.client;
  var isLoading = false.obs;
  var products = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

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

  void addProduct(Product product) async {
    isLoading(true);
    try {
      final response = await _supabaseClient.from('products').insert(product.toJson());
      fetchProducts();
      Get.snackbar('Success', 'Produk berhasil ditambahkan');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  void editProduct(Product product) async {
  isLoading(true);
  try {
    final response = await _supabaseClient
        .from('products')
        .update(product.toJson()) 
        .eq('id', product.id as Object);

    Get.snackbar('Success', 'Produk berhasil diperbarui');
    fetchProducts();
  } catch (e) {
    Get.snackbar('Error', e.toString());
  } finally {
    isLoading(false);
  }
}

}
