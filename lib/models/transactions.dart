import 'package:intl/intl.dart';

class Transaction {
  final int? id;
  final int totalPrice;

  const Transaction({
     this.id,
    required this.totalPrice,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      totalPrice: json['total_amount'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'total_price': totalPrice,
    };
  }

  static String formatRupiah(double amount) {
    final format = NumberFormat.simpleCurrency(locale: 'id_ID');
    return format.format(amount);
  }
}
