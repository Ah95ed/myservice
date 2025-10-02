import 'NetworkService.dart';

// فئة لإدارة طلبات Cloudflare
class CloudflareService {
  // رابط Workers الخاص بك على Cloudflare
  static const String _baseUrl =
      'https://your-worker.your-subdomain.workers.dev';

  // يمكنك أيضاً استخدام Custom Domain
  // static const String _baseUrl = 'https://api.yourdomain.com';

  // جلب البيانات من Cloudflare Worker
  static Future<Map<String, dynamic>> getData(String endpoint) async {
    final url = '$_baseUrl/$endpoint';
    return await NetworkService.get(url);
  }

  // إرسال البيانات إلى Cloudflare Worker
  static Future<Map<String, dynamic>> postData(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final url = '$_baseUrl/$endpoint';
    return await NetworkService.post(url, data);
  }

  // تحديث البيانات في Cloudflare Worker
  static Future<Map<String, dynamic>> updateData(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final url = '$_baseUrl/$endpoint';
    return await NetworkService.put(url, data);
  }

  // حذف البيانات من Cloudflare Worker
  static Future<Map<String, dynamic>> deleteData(String endpoint) async {
    final url = '$_baseUrl/$endpoint';
    return await NetworkService.delete(url);
  }

  // === وظائف خاصة بتطبيقك ===

  // جلب قائمة المتبرعين بالدم
  static Future<Map<String, dynamic>> getBloodDonors() async {
    return await getData('blood-donors');
  }

  // إضافة متبرع جديد بالدم
  static Future<Map<String, dynamic>> addBloodDonor(
    Map<String, dynamic> donorData,
  ) async {
    return await postData('blood-donors', donorData);
  }

  // جلب قائمة الأطباء
  static Future<Map<String, dynamic>> getDoctors() async {
    return await getData('doctors');
  }

  // إضافة طبيب جديد
  static Future<Map<String, dynamic>> addDoctor(
    Map<String, dynamic> doctorData,
  ) async {
    return await postData('doctors', doctorData);
  }

  // جلب قائمة أصحاب المهن
  static Future<Map<String, dynamic>> getProfessionals() async {
    return await getData('professionals');
  }

  // إضافة صاحب مهنة جديد
  static Future<Map<String, dynamic>> addProfessional(
    Map<String, dynamic> professionalData,
  ) async {
    return await postData('professionals', professionalData);
  }

  // تسجيل الدخول
  static Future<Map<String, dynamic>> login(
    String phone,
    String password,
  ) async {
    return await postData('auth/login', {'phone': phone, 'password': password});
  }

  // إنشاء حساب جديد
  static Future<Map<String, dynamic>> signup(
    Map<String, dynamic> userData,
  ) async {
    return await postData('auth/signup', userData);
  }

  // إرسال رسالة للمطور
  static Future<Map<String, dynamic>> sendMessageToDeveloper(
    Map<String, dynamic> messageData,
  ) async {
    return await postData('developer/message', messageData);
  }

  // جلب معلومات التطبيق والتحديثات
  static Future<Map<String, dynamic>> getAppInfo() async {
    return await getData('app/info');
  }

  // رفع الصور إلى Cloudflare Images (إذا كان متاحاً)
  static Future<Map<String, dynamic>> uploadImage(
    List<int> imageBytes,
    String fileName,
  ) async {
    // هذا يحتاج إلى معالجة خاصة للملفات
    // يمكن استخدام Cloudflare Images API أو Workers مع KV Storage
    return await postData('images/upload', {
      'fileName': fileName,
      'imageData': imageBytes,
    });
  }

  // البحث في البيانات
  static Future<Map<String, dynamic>> search(String query, String type) async {
    return await getData('search?q=$query&type=$type');
  }
}

// فئة لإدارة Cache مع Cloudflare
class CloudflareCache {
  static const Duration _defaultCacheDuration = Duration(minutes: 5);
  static final Map<String, CacheItem> _cache = {};

  // حفظ البيانات في الكاش
  static void setCache(String key, dynamic data, [Duration? duration]) {
    _cache[key] = CacheItem(
      data: data,
      expiry: DateTime.now().add(duration ?? _defaultCacheDuration),
    );
  }

  // جلب البيانات من الكاش
  static dynamic getCache(String key) {
    final item = _cache[key];
    if (item != null && item.expiry.isAfter(DateTime.now())) {
      return item.data;
    }
    _cache.remove(key);
    return null;
  }

  // مسح الكاش
  static void clearCache() {
    _cache.clear();
  }

  // جلب البيانات مع الكاش
  static Future<Map<String, dynamic>> getCachedData(
    String cacheKey,
    Future<Map<String, dynamic>> Function() fetchFunction, [
    Duration? cacheDuration,
  ]) async {
    // التحقق من الكاش أولاً
    final cachedData = getCache(cacheKey);
    if (cachedData != null) {
      return cachedData;
    }

    // جلب البيانات إذا لم توجد في الكاش
    final data = await fetchFunction();
    setCache(cacheKey, data, cacheDuration);
    return data;
  }
}

// فئة مساعدة للكاش
class CacheItem {
  final dynamic data;
  final DateTime expiry;

  CacheItem({required this.data, required this.expiry});
}
