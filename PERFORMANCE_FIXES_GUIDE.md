# دليل تحسين الأداء وإصلاح تسريبات الذاكرة
## Performance & Memory Leak Fixes

---

## 🚀 الإصلاحات الفورية

### إصلاح #1: Timer Leaks في SplashScreen

#### الملف: `lib/view/screens/MyCustomSplashScreen.dart`

**المشكلة الحالية:**
```dart
Timer(Duration(seconds: 2), () {
  setState(() { ... });
});
```
إذا خرج المستخدم من الشاشة قبل انتهاء التايمر، سيستمر التنفيذ مما قد يسبب crash.

**الإصلاح:**

```dart
class _MyCustomSplashScreenState extends State<MyCustomSplashScreen> {
  Timer? _timer1;
  Timer? _timer2;
  Timer? _timer3;
  bool _mounted = true;

  @override
  void initState() {
    super.initState();
    _startAnimations();
  }

  void _startAnimations() {
    _timer1 = Timer(Duration(seconds: 2), () {
      if (!_mounted) return;
      setState(() {
        _opacity1 = 1.0;
      });
    });

    _timer2 = Timer(Duration(seconds: 2), () {
      if (!_mounted) return;
      setState(() {
        _opacity2 = 1.0;
      });
    });

    _timer3 = Timer(Duration(seconds: 4), () {
      if (!_mounted) return;
      checkIsLogin();
    });
  }

  @override
  void dispose() {
    _mounted = false;
    _timer1?.cancel();
    _timer2?.cancel();
    _timer3?.cancel();
    super.dispose();
  }
  
  // ... بقية الكود
}
```

---

### إصلاح #2: إضافة Debouncing للبحث

#### الملف: `lib/controller/provider/Provider.dart`

**المشكلة:** البحث يحدث مع كل ضغطة مفتاح، مما يسبب استهلاك عالي.

**الإصلاح:**

```dart
import 'dart:async';

class Providers with ChangeNotifier {
  Timer? _debounce;
  
  void onSearchTextChanged(String query) {
    // إلغاء التايمر السابق إن وجد
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    // إنشاء تايمر جديد
    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchName(query);
    });
  }
  
  Future<void> searchName(String? name) async {
    if (name == null || name.isEmpty) {
      search = [];
      notifyListeners();
      return;
    }

    // استخدام where بكفاءة أعلى
    search = s.where((e) => 
      (e['name'] as String).toLowerCase().contains(name.toLowerCase())
    ).toList();
    
    notifyListeners();
  }
  
  @override
  void dispose() {
    _debounce?.cancel();
    number.dispose();
    super.dispose();
  }
}
```

**تحديث TextField:**
```dart
TextField(
  controller: number,
  onChanged: (value) {
    read.onSearchTextChanged(value); // استخدام الدالة الجديدة
  },
)
```

---

### إصلاح #3: تحسين إنشاء Widgets

#### الملف: `lib/controller/provider/Provider.dart`

**المشكلة:** Widgets تُنشأ في كل build

```dart
final bodys = [
  DoctorScreen(),
  ProfessionsScreen(),
  // ...
];
```

**الإصلاح:**

```dart
class Providers with ChangeNotifier {
  // إنشاء واحد فقط عند الحاجة
  late final List<Widget> bodys = [
    DoctorScreen(),
    ProfessionsScreen(),
    BloodScreen(),
    TheCars(),
    SatotaScreen(),
  ];
  
  // ... بقية الكود
}
```

---

### إصلاح #4: تحسين استخدام SharedPreferences

#### إنشاء PreferencesService منظم

```dart
// lib/Services/preferences_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static SharedPreferences? _prefs;
  
  // مفاتيح ثابتة لتجنب الأخطاء
  static const String _keyIsRegistered = 'isRegister';
  static const String _keyShowSplash = 'spalsh';
  static const String _keyLanguage = 'lang';
  static const String _keyUserName = 'nameUser';
  static const String _keyUserEmail = 'emailUser';
  static const String _keyUserPhone = 'phoneUser';
  
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  // Getters مع قيم افتراضية
  static bool get isRegistered => _prefs?.getBool(_keyIsRegistered) ?? false;
  static bool get showSplash => _prefs?.getBool(_keyShowSplash) ?? false;
  static String get language => _prefs?.getString(_keyLanguage) ?? 'ar';
  static String? get userName => _prefs?.getString(_keyUserName);
  static String? get userEmail => _prefs?.getString(_keyUserEmail);
  static String? get userPhone => _prefs?.getString(_keyUserPhone);
  
  // Setters
  static Future<bool> setRegistered(bool value) async {
    return await _prefs?.setBool(_keyIsRegistered, value) ?? false;
  }
  
  static Future<bool> setShowSplash(bool value) async {
    return await _prefs?.setBool(_keyShowSplash, value) ?? false;
  }
  
  static Future<bool> setLanguage(String value) async {
    return await _prefs?.setString(_keyLanguage, value) ?? false;
  }
  
  static Future<bool> setUserData({
    required String name,
    required String email,
    required String phone,
  }) async {
    await _prefs?.setString(_keyUserName, name);
    await _prefs?.setString(_keyUserEmail, email);
    return await _prefs?.setString(_keyUserPhone, phone) ?? false;
  }
  
  // مسح البيانات
  static Future<bool> clearUserData() async {
    await _prefs?.remove(_keyUserName);
    await _prefs?.remove(_keyUserEmail);
    await _prefs?.remove(_keyUserPhone);
    return await _prefs?.setBool(_keyIsRegistered, false) ?? false;
  }
  
  static Future<bool> clearAll() async {
    return await _prefs?.clear() ?? false;
  }
}
```

**تحديث service.dart:**

```dart
// lib/Helper/Service/service.dart
import 'package:Al_Zab_township_guide/Services/preferences_service.dart';

// حذف أو تعطيل:
// SharedPreferences? shared;

Future<void> init() async {
  // استخدام الخدمة الجديدة
  await PreferencesService.init();
  
  await initLang(PreferencesService.language);
  packageInfo = await PackageInfo.fromPlatform();
}
```

---

### إصلاح #5: إضافة const constructors

**في جميع أنحاء الكود:**

```dart
// قبل:
Icon(Icons.search, color: Colors.white, size: 22.0)

// بعد:
const Icon(Icons.search, color: Colors.white, size: 22.0)

// قبل:
SizedBox(width: getWidth(4))

// بعد:
SizedBox(width: getWidth(4)) // لا يمكن جعله const لأنه يعتمد على function

// لكن يمكن:
const SizedBox(width: 16) // إذا كانت قيمة ثابتة
```

**قاعدة عامة:** استخدم `const` لكل widget لا يتغير.

---

### إصلاح #6: إضافة Caching للصور والبيانات

#### إضافة cached_network_image

```yaml
# pubspec.yaml
dependencies:
  cached_network_image: ^3.3.1
```

#### الاستخدام:

```dart
// بدلاً من Image.network
CachedNetworkImage(
  imageUrl: imageUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
  maxHeightDiskCache: 1000,
  maxWidthDiskCache: 1000,
)
```

#### إضافة Caching للبيانات

احفظ النتائج المتكررة محليا (مثلا باستخدام SharedPreferences أو قاعدة محلية)
لتقليل طلبات الشبكة وتحسين سرعة الواجهة.

---

### إصلاح #7: تحسين استخدام ListView

**استخدم ListView.builder بدلاً من ListView عادي:**

```dart
// قبل:
ListView(
  children: items.map((item) => ItemWidget(item)).toList(),
)

// بعد:
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ItemWidget(items[index]);
  },
)

// أو الأفضل:
ListView.separated(
  itemCount: items.length,
  separatorBuilder: (context, index) => Divider(),
  itemBuilder: (context, index) => ItemWidget(items[index]),
)
```

---

### إصلاح #8: معالجة Streams بشكل صحيح

**إذا كنت تستخدم Streams:**

```dart
class SomeProvider with ChangeNotifier {
  StreamSubscription<dynamic>? _subscription;
  
  void listenToData() {
    _subscription = someStream.listen((snapshot) {
      // معالجة البيانات
    });
  }
  
  @override
  void dispose() {
    _subscription?.cancel(); // مهم جداً!
    super.dispose();
  }
}
```

---

### إصلاح #9: تحسين GlobalKey

```dart
class _MainScreenState extends State<MainScreen> {
  // إنشاء مرة واحدة فقط
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  // لا تعيد إنشاءه في build()
}
```

---

### إصلاح #10: استخدام Isolates للعمليات الثقيلة

**لعمليات التشفير أو المعالجة الثقيلة:**

```dart
import 'dart:isolate';

Future<String> heavyComputation(String data) async {
  return await Isolate.run(() {
    // عملية حسابية ثقيلة
    return processData(data);
  });
}
```

---

## 📊 قياس الأداء

### استخدام Flutter DevTools

```bash
flutter pub global activate devtools
flutter pub global run devtools
```

### إضافة Performance Overlay

```dart
MaterialApp(
  showPerformanceOverlay: true, // في وضع التطوير فقط
  // ...
)
```

---

## ✅ قائمة التحقق

- [ ] إصلاح Timer leaks
- [ ] إضافة Debouncing
- [ ] استخدام late final للـ Widgets
- [ ] إنشاء PreferencesService
- [ ] إضافة const constructors
- [ ] تطبيق cached_network_image
- [ ] استخدام ListView.builder
- [ ] إلغاء Stream subscriptions
- [ ] تحسين GlobalKey
- [ ] اختبار الأداء

---

**تم الإنشاء:** 5 فبراير 2026  
**الأولوية:** عالية 🟠
