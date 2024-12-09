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
    controller.loadSalesData();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.white,
      ),
      drawer: const Sidemenu(),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              return Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSummaryList('Total', 'Rp${controller.totalSales.toStringAsFixed(2)}', Icons.attach_money),
                        _buildSummaryList('Keseluruhan', '${controller.totalTransactions}', Icons.numbers),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSummaryList('Total Hari ini', 'Rp${controller.totalTodaySales.toStringAsFixed(2)}', Icons.attach_money),
                        _buildSummaryList('Hari Ini', '${controller.totalTodayTransactions}', Icons.numbers),
                      ],
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 32,),

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

  // Card Summary with title and value (Vertical card layout)
  Widget _buildSummaryList(String title, String value, IconData icon) {
  return Card(
    color: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16), // Added padding for better spacing
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold, // Bold title for emphasis
          overflow: TextOverflow.ellipsis, // Prevent overflow for the title
        ),
        maxLines: 1, // Ensure title fits on one line
        softWrap: false, // Prevent wrapping of title text
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          color: Colors.black,
          overflow: TextOverflow.ellipsis, // Prevent overflow for the subtitle
        ),
        maxLines: 1, // Ensure subtitle fits on one line
        softWrap: false, // Prevent wrapping of subtitle text
      ),
    ),
  );
}


}
