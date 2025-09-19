import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Models/ConnectTelegram/TelegramClass.dart';

class TelegramClassProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<TelegramClass> _classes = [];
  
  // يجب تغيير هذا إلى التوكن الحقيقي
  final String _botToken = 'YOUR_BOT_TOKEN_HERE';

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<TelegramClass> get classes => List.unmodifiable(_classes);

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> fetchClasses() async {
    try {
      _setLoading(true);
      clearError();
      
      final url = 'https://api.telegram.org/bot$_botToken/getUpdates';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        // يمكن استخدام هذا لمعالجة البيانات الفعلية من البوت
        // final jsonData = json.decode(response.body);
        
        // معالجة البيانات حسب هيكل API الخاص بالبوت
        // هذا مثال توضيحي - يجب تعديله حسب البيانات الفعلية
        _classes = [
          TelegramClass(id: '1', name: 'صف الأول الابتدائي'),
          TelegramClass(id: '2', name: 'صف الثاني الابتدائي'),
          TelegramClass(id: '3', name: 'صف الثالث الابتدائي'),
          TelegramClass(id: '4', name: 'صف الرابع الابتدائي'),
          TelegramClass(id: '5', name: 'صف الخامس الابتدائي'),
          TelegramClass(id: '6', name: 'صف السادس الابتدائي'),
        ];
        
        notifyListeners();
      } else {
        _setError('فشل في جلب البيانات من الخادم');
      }
    } catch (e) {
      _setError('حدث خطأ في الاتصال: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshClasses() async {
    await fetchClasses();
  }

  @override
  void dispose() {
    _classes.clear();
    super.dispose();
  }
}