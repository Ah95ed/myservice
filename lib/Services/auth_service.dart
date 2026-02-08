/// خدمة المصادقة الآمنة
/// تستخدم Firebase Authentication بدلاً من تخزين كلمات المرور
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'secure_storage_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// الحصول على المستخدم الحالي
  User? get currentUser => _auth.currentUser;

  /// التحقق من تسجيل الدخول
  bool get isLoggedIn => _auth.currentUser != null;

  /// تسجيل مستخدم جديد
  Future<UserCredential?> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      print('🔄 Creating account for: $email');

      // التحقق من صحة البيانات
      if (email.isEmpty || password.isEmpty || name.isEmpty || phone.isEmpty) {
        throw FirebaseAuthException(
          code: 'invalid-input',
          message: 'جميع الحقول مطلوبة',
        );
      }

      if (password.length < 6) {
        throw FirebaseAuthException(
          code: 'weak-password',
          message: 'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
        );
      }

      // إنشاء حساب شامل Firebase Auth
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // تحديث البيانات الشخصية
      await userCredential.user?.updateDisplayName(name);

      // حفظ البيانات الإضافية في Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'phone': phone,
        'uid': userCredential.user!.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
        'isActive': true,
      });

      // حفظ البيانات في التخزين الآمن
      await SecureStorageService.saveUserData(
        name: name,
        email: email,
        phone: phone,
        uid: userCredential.user!.uid,
      );

      await SecureStorageService.saveUserEmail(email);
      await SecureStorageService.saveUserId(userCredential.user!.uid);

      print('✅ Account created successfully');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('❌ Auth error: ${e.code}: ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      print('❌ Unexpected error: $e');
      rethrow;
    }
  }

  /// تسجيل الدخول
  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      print('🔄 Signing in: $email');

      if (email.isEmpty || password.isEmpty) {
        throw FirebaseAuthException(
          code: 'invalid-input',
          message: 'البريد وكلمة المرور مطلوبة',
        );
      }

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // تحديث آخر وقت تسجيل دخول
      await _firestore.collection('users').doc(userCredential.user!.uid).update(
        {'lastLogin': FieldValue.serverTimestamp()},
      );

      // جلب بيانات المستخدم وحفظها بشكل آمن
      final userData = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userData.exists) {
        final data = userData.data() as Map<String, dynamic>;
        await SecureStorageService.saveUserData(
          name: data['name'] ?? '',
          email: data['email'] ?? '',
          phone: data['phone'] ?? '',
          uid: userCredential.user!.uid,
        );
        await SecureStorageService.saveUserEmail(email);
        await SecureStorageService.saveUserId(userCredential.user!.uid);
      }

      print('✅ Sign in successful');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('❌ Auth error: ${e.code}: ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      print('❌ Unexpected error: $e');
      rethrow;
    }
  }

  /// تسجيل الخروج
  Future<void> signOut() async {
    try {
      print('🔄 Signing out...');
      await _auth.signOut();
      await SecureStorageService.clearAll();
      print('✅ Sign out successful');
    } catch (e) {
      print('❌ Error signing out: $e');
      rethrow;
    }
  }

  /// إعادة تعيين كلمة المرور
  Future<void> resetPassword(String email) async {
    try {
      print('🔄 Sending password reset email to: $email');
      await _auth.sendPasswordResetEmail(email: email);
      print('✅ Password reset email sent');
    } on FirebaseAuthException catch (e) {
      print('❌ Auth error: ${e.code}: ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      print('❌ Unexpected error: $e');
      rethrow;
    }
  }

  /// معالجة أخطاء Firebase Auth
  Exception _handleAuthException(FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'weak-password':
        message = 'كلمة المرور ضعيفة جداً. استخدم رقم أو حرف خاص.';
        break;
      case 'email-already-in-use':
        message = 'البريد الإلكتروني مستخدم بالفعل.';
        break;
      case 'invalid-email':
        message = 'البريد الإلكتروني غير صحيح.';
        break;
      case 'user-not-found':
        message = 'المستخدم غير موجود. تأكد من البريد أو قم بإنشاء حساب جديد.';
        break;
      case 'wrong-password':
        message = 'كلمة المرور غير صحيحة.';
        break;
      case 'user-disabled':
        message = 'حسابك معطل. تواصل مع الدعم.';
        break;
      case 'too-many-requests':
        message = 'محاولات كثيرة. حاول لاحقاً.';
        break;
      case 'operation-not-allowed':
        message = 'هذه العملية غير مسموحة حالياً.';
        break;
      default:
        message = 'حدث خطأ: ${e.message}';
    }
    return Exception(message);
  }

  /// جلب بيانات المستخدم من Firestore
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      print('❌ Error fetching user data: $e');
      return null;
    }
  }

  /// تحديث بيانات المستخدم
  Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).update(data);
      print('✅ User data updated');
    } catch (e) {
      print('❌ Error updating user data: $e');
      rethrow;
    }
  }
}
