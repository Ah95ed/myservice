// ignore_for_file: public_member_api_docs, sort_constructors_first
class DoctorModel {
  const DoctorModel({
    required this.name,
    required this.presence,
    required this.specialization,
    required this.number,
    required this.title,
  });

  final String name;
  final String presence;
  final String specialization;
  final String number;
  final String title;

  DoctorModel copyWith({
    String? name,
    String? presence,
    String? specialization,
    String? number,
    String? title,
  }) {
    return DoctorModel(
      name: name ?? this.name,
      presence: presence ?? this.presence,
      specialization: specialization ?? this.specialization,
      number: number ?? this.number,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'presence': presence,
      'specialization': specialization,
      'number': number,
      'title': title,
    };
  }

  factory DoctorModel.fromMap(Map<String, dynamic> map) {
    return DoctorModel(
      name: map['name'] ?? '',
      presence: map['presence'] ?? '',
      specialization: map['specialization'] ?? '',
      number: map['number'] ?? '',
      title: map['title'] ?? '',
    );
  }

  @override
  String toString() {
    return 'DoctorModel(name: $name, presence: $presence, specialization: $specialization, number: $number, title: $title)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DoctorModel &&
        other.name == name &&
        other.presence == presence &&
        other.specialization == specialization &&
        other.number == number &&
        other.title == title;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        presence.hashCode ^
        specialization.hashCode ^
        number.hashCode ^
        title.hashCode;
  }
}
