class Favorite {
  final int id;

  Favorite({required this.id});

  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(id: map['id']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id};
  }
}
