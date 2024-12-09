import 'package:flutter_getx/models/transactions.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionController extends GetxController {
  var transactions = <Transaction>[].obs;
  final _transaction = Supabase.instance.client;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    findTransaction();
  }

  void findTransaction() async {
    isLoading(true);
    final res = await _transaction.from('transactions').select();
    final data = res as List;
    transactions.value = data.map((e) => Transaction.fromJson(e)).toList();
    isLoading(false);
  }


  void addTransaction(Transaction transaction) async {
    try {
      isLoading(true);
      await _transaction.from('transactions').insert(transaction.toJson());
      Get.snackbar('Success', 'Berhasil menambahkan Data');
      findTransaction();
/// the error and displays an error message in a snackbar.
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}