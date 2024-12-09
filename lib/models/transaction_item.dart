class TransactionItem {
  final int? id;
  final String name;
  final double price;
  int quantity;

  TransactionItem({
    this.id,
    required this.name,
    required this.price,
    required this.quantity
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      quantity: json['quantity'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }

  // Fungsi untuk membuat salinan produk dengan quantity yang baru
  TransactionItem copyWith({int? quantity, required int qty}) {
    return TransactionItem(
      id: id,
      name: name,
      price: price,
      quantity: qty
    );
  }
}