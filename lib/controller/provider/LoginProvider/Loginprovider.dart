import 'package:Al_Zab_township_guide/Models/LoginModel/LoginModel.dart';
import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  String? _phone;
  String? _password;
  late final LoginModel _model;

  LoginProvider() {
    _model = LoginModel();
  }

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get phone => _phone;
  String? get password => _password;

  // Setters
  void setPhone(String? phone) {
    _phone = phone;
    notifyListeners();
  }

  void setPassword(String? password) {
    _password = password;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> login(
    BuildContext context,
    String? phone,
    String? password,
  ) async {
    if (phone?.isEmpty ?? true) {
      setError('يرجى إدخال رقم الهاتف');
      return;
    }

    if (password?.isEmpty ?? true) {
      setError('يرجى إدخال كلمة المرور');
      return;
    }

    try {
      _setLoading(true);
      clearError();
      await _model.checkData(phone!, password!);
      _phone = phone;
      _password = password;
    } catch (e) {
      setError('حدث خطأ في تسجيل الدخول: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  @override
  void dispose() {
    _isLoading = false;
    super.dispose();
  }
}
