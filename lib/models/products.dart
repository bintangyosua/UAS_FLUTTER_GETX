class Product {
  final int? id;
  final String name;
  final double price;

  const Product({
    this.id,
    required this.name,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
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
  Product copyWith({int? quantity, required int qty}) {
    return Product(
      id: this.id,
      name: this.name,
      price: this.price,
    );
  }
}