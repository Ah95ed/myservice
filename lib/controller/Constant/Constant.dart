import 'package:email_otp/email_otp.dart';

class Constant {
  static const String A_Plus = 'A+';
  static const String A_Minus = 'A-';
  static const String B_Plus = 'B+';
  static const String B_Minus = 'B-';
  static const String O_Plus = 'O+';
  static const String O_Minus = 'O-';
  static const String AB_Plus = 'AB+';
  static const String AB_Minus = 'AB-';
}

class DataSend {
  String collection;

  DataSend(this.collection);
}

class DataOTP {
  EmailOTP? otp;

  DataOTP( {this.otp});
}
// ignore: non_constant_identifier_names
// Enum Service {
// doctore
// }

