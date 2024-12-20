import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart'; // For date formatting

class DashboardController extends GetxController {
  var dailySales = <int>[].obs;  // Daftar untuk menyimpan total harga transaksi
  var saleDates = <String>[].obs; // Daftar untuk menyimpan tanggal transaksi
  var totalSales = 0.obs;    // Total penjualan hari ini
  var totalTodaySales = 0.00.obs;
  var totalTransactions = 0.obs;  // Jumlah transaksi
  var meanSales = 0.00.obs;
  var totalTodayTransactions = 0.obs;  // Jumlah transaksi hari ini

  // Fungsi untuk memuat data penjualan dari Supabase
  Future<void> loadSalesData() async {
    try {
      // Fetch data from 'transactions' table, including total_price and created_at
      final response = await Supabase.instance.client
          .from('transactions')
          .select('total_price, created_at')
          .order('created_at', ascending: true);

      // Print the response data for debugging purposes
      // Extract sales data and date information
      final List<dynamic> sales = response;
      
      // Map the data and format the date for x-axis labels
      final Map<String, int> salesByDate = sales.fold(
        <String, int>{},
        (map, e) {
          final date = DateFormat('dd MMM').format(DateTime.parse(e['created_at']));
          map[date] = (map[date] ?? 0) + e['total_price'] as int;
          return map;
        },
      );

      // Calculate total sales and total transactions
      dailySales.value = salesByDate.values.toList();
      saleDates.value = salesByDate.keys.toList();
      totalSales.value = dailySales.fold(0, (sum, sale) => sum + sale);
      totalTransactions.value = response.length;
      meanSales.value = totalSales.value / dailySales.length;

      final todayDate = DateFormat('dd MMM').format(DateTime.now());
      totalTodaySales.value = sales
          .where((e) => DateFormat('dd MMM').format(DateTime.parse(e['created_at'])) == todayDate)
          .fold(0.0, (sum, e) => sum + e['total_price']);

      // Calculate total transactions for today
      totalTodayTransactions.value = sales
          .where((e) => DateFormat('dd MMM').format(DateTime.parse(e['created_at'])) == todayDate)
          .length;
      
      print(totalTodaySales);

    } catch (e) {
      // Handle any exceptions or errors that may occur
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }
}

