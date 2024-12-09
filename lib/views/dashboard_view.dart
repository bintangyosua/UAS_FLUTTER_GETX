import 'package:flutter/material.dart';
import 'package:flutter_getx/widgets/sidemenu.dart';
import 'package:flutter_getx/controllers/dashboard_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

class DashboardView extends StatelessWidget {
  final DashboardController controller = Get.put(DashboardController());

  DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Memanggil fungsi untuk memuat data saat halaman dibuka
    controller.loadSalesData();

    return Scaffold(
      backgroundColor: Colors.white, // White background for the whole screen
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.white, // Black AppBar
      ),
      drawer: const Sidemenu(), // Sidebar menu
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ringkasan Penjualan
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSummaryCard('Total Penjualan', 'Rp${controller.totalSalesToday.toStringAsFixed(2)}'),
                  _buildSummaryCard('Jumlah Transaksi', '${controller.totalTransactions}'),
                ],
              );
            }),
            const SizedBox(height: 32),

            // Grafik Penjualan
            const Text(
              'Grafik Penjualan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 8),
            Obx(() {
              return controller.dailySales.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      height: 250,
                      child: LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: true, drawHorizontalLine: true),
                          titlesData: FlTitlesData(
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                interval: 1,
                                showTitles: true,
                                getTitlesWidget: (double value, TitleMeta meta) {
                                  int index = value.toInt();
                                  if (index >= 0 && index < controller.saleDates.length) {
                                    return Text(
                                      controller.saleDates[index],
                                      style: const TextStyle(fontSize: 10, color: Colors.black),
                                    );
                                  } else {
                                    return const Text('');
                                  }
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: true, border: Border.all(color: Colors.black)),
                          lineBarsData: [
                            LineChartBarData(
                              spots: controller.dailySales.asMap().entries.map((entry) {
                                return FlSpot(entry.key.toDouble(), entry.value.toDouble());
                              }).toList(),
                              isStrokeCapRound: true,
                              color: Colors.black, // Black color for the line chart
                            ),
                          ],
                        ),
                      ),
                    );
            }),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Card Ringkasan Penjualan
  Widget _buildSummaryCard(String title, String value) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: Colors.white, // White card background
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black), // Black title
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black), // Black value text
            ),
          ],
        ),
      ),
    );
  }
}
