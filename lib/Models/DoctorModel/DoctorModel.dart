// ignore_for_file: public_member_api_docs, sort_constructors_first
class DoctorModel {
  String? _name, _presence, _specialization, _number, _title;

  DoctorModel({
    String? name,
    String? presence,
    String? specialization,
    String? number,
    String? title,
  }) {
    _name = name;
    _presence = presence;
    _specialization = specialization;
    _number = number;
    _title = title;
  }

  //! getter and setter
  String? get name => _name;
  String? get presence => _presence;
  String? get specialization => _specialization;
  String? get number => _number;
  String? get title => _title;

  set name(String? value) {
    _name = value;
  }

  set time(String? value) {
    _presence = value;
  }

  set sepcialization(String? value) {
    _specialization = value;
  }

  set number(String? value) {
    _number = value;
  }

  set title(String? value) {
    _title = value;
  }
}
