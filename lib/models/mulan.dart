class Mulan {
  final String? id;
  final String nama;
  final String story;

  const Mulan({
     this.id,
    required this.nama,
    required this.story,
  });

  factory Mulan.fromJson(Map<String, dynamic> json) {
    return Mulan(
      id: json['id'],
      nama: json['nama'],
      story: json['story'],
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'story': story,
    };
  }
}
