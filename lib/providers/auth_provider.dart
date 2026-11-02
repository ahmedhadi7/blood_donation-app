import 'dart:async';

import 'package:blood_donation/data/firebase_auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({FirebaseAuthRepository? repository})
    : _repository = repository ?? FirebaseAuthRepository() {
    _authSubscription = _repository.authStateChanges.listen(
      (user) {
        _user = user;
        _isInitializing = false;
        notifyListeners();
      },
      onError: (_) {
        _isInitializing = false;
        notifyListeners();
      },
    );
  }

  final FirebaseAuthRepository _repository;
  StreamSubscription<User?>? _authSubscription;

  User? _user;
  bool _isInitializing = true;
  bool _isBusy = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isInitializing => _isInitializing;
  bool get isBusy => _isBusy;
  String? get errorMessage => _errorMessage;
  bool get isSignedIn => _user != null;

  Future<bool> signIn({required String email, required String password}) async {
    _startRequest();
    try {
      await _repository.signIn(email: email, password: password);
      
      _user = _repository.currentUser;
      _finishRequest();
      return true;
    } on FirebaseAuthException catch (error) {
      _finishRequest(_friendlyAuthError(error));
      return false;
    } catch (_) {
      _finishRequest('حدث خطأ غير متوقع. حاول مرة أخرى.');
      return false;
    }
  }

  Future<bool> createAccount({
    required String name,
    required String email,
    required String password,
  }) async {
    _startRequest();
    try {
      await _repository.createAccount(
        name: name,
        email: email,
        password: password,
      );
      // Firebase signs the user in automatically after account creation.
      _user = _repository.currentUser;
      _finishRequest();
      return true;
    } on FirebaseAuthException catch (error) {
      _finishRequest(_friendlyAuthError(error));
      return false;
    } catch (_) {
      _finishRequest('حدث خطأ غير متوقع. حاول مرة أخرى.');
      return false;
    }
  }

  Future<void> signOut() async {
    _startRequest();
    try {
      await _repository.signOut();
      _finishRequest();
    } on FirebaseAuthException catch (error) {
      _finishRequest(_friendlyAuthError(error));
    } catch (_) {
      _finishRequest('تعذر تسجيل الخروج. حاول مرة أخرى.');
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _startRequest() {
    _isBusy = true;
    _errorMessage = null;
    notifyListeners();
  }

  void _finishRequest([String? error]) {
    _isBusy = false;
    _errorMessage = error;
    notifyListeners();
  }

  String _friendlyAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'صيغة البريد الإلكتروني غير صحيحة.';
      case 'user-not-found':
      case 'invalid-credential':
      case 'wrong-password':
        return 'البريد الإلكتروني أو كلمة المرور غير صحيحة.';
      case 'email-already-in-use':
        return 'هذا البريد مسجل مسبقًا. جرّب تسجيل الدخول.';
      case 'weak-password':
        return 'كلمة المرور ضعيفة. استخدم 6 أحرف على الأقل.';
      case 'network-request-failed':
        return 'تحقق من اتصال الإنترنت ثم حاول مجددًا.';
      case 'too-many-requests':
        return 'محاولات كثيرة. انتظر قليلًا ثم حاول مجددًا.';
      case 'operation-not-allowed':
        return 'فعّل تسجيل الدخول بالبريد وكلمة المرور من Firebase Console.';
      default:
        return 'تعذر إكمال العملية (${error.code}). حاول مرة أخرى.';
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
