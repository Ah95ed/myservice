import 'package:flutter/material.dart';

import '../../Helper/Constant/AppConstants.dart';
import '../../Helper/Service/CloudflareService.dart';
import '../../Models/BloodModel/BloodModel.dart';

class CloudflareBloodProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<BloodModel> _bloodDonors = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<BloodModel> get bloodDonors => List.unmodifiable(_bloodDonors);

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

  // جلب قائمة المتبرعين بالدم من Cloudflare
  Future<void> fetchBloodDonors() async {
    try {
      _setLoading(true);
      clearError();

      // استخدام الكاش للتحسين
      final response = await CloudflareCache.getCachedData(
        'blood_donors',
        () => CloudflareService.getBloodDonors(),
        const Duration(minutes: 10),
      );

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> donorsData = response['data'];
        _bloodDonors = donorsData
            .map((donorJson) => BloodModel.fromMap(donorJson))
            .toList();
      } else {
        _setError(response['message'] ?? 'حدث خطأ في جلب البيانات');
      }
    } catch (e) {
      _setError('حدث خطأ في الاتصال: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // إضافة متبرع جديد
  Future<bool> addBloodDonor(BloodModel donor) async {
    try {
      _setLoading(true);
      clearError();

      final response = await CloudflareService.addBloodDonor(donor.toMap());

      if (response['success'] == true) {
        // إضافة المتبرع للقائمة المحلية
        _bloodDonors.add(donor);

        // مسح الكاش لإعادة جلب البيانات المحدثة
        CloudflareCache.clearCache();

        notifyListeners();
        return true;
      } else {
        _setError(response['message'] ?? 'فشل في إضافة المتبرع');
        return false;
      }
    } catch (e) {
      _setError('حدث خطأ في إضافة المتبرع: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // البحث في المتبرعين
  Future<void> searchBloodDonors(String query) async {
    try {
      _setLoading(true);
      clearError();

      final response = await CloudflareService.search(
        query,
        AppConstants.searchTypeBlood,
      );

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> donorsData = response['data'];
        _bloodDonors = donorsData
            .map((donorJson) => BloodModel.fromMap(donorJson))
            .toList();
      } else {
        _setError(response['message'] ?? 'لم يتم العثور على نتائج');
      }
    } catch (e) {
      _setError('حدث خطأ في البحث: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // تحديث المتبرعين
  Future<void> refreshBloodDonors() async {
    CloudflareCache.clearCache();
    await fetchBloodDonors();
  }

  @override
  void dispose() {
    _bloodDonors.clear();
    super.dispose();
  }
}
