class BloodModel {
  const BloodModel({
    required this.name,
    required this.image,
    required this.id,
  });
  final String name;
  final String image;
  final String id;

  BloodModel copyWith({
    String? name,
    String? image,
    String? id,
  }) {
    return BloodModel(
      name: name ?? this.name,
      image: image ?? this.image,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'id': id,
    };
  }

  factory BloodModel.fromMap(Map<String, dynamic> map) {
    return BloodModel(
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      id: map['id'] ?? '',
    );
  }

  @override
  String toString() => 'BloodModel(name: $name, image: $image, id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BloodModel &&
        other.name == name &&
        other.image == image &&
        other.id == id;
  }

  @override
  int get hashCode => name.hashCode ^ image.hashCode ^ id.hashCode;
}
