import 'package:blood_donation/screen/login_screen.dart';
import 'package:blood_donation/screen/register_screen.dart';
import 'package:flutter/material.dart';

class AuthChoiceScreen extends StatelessWidget {
  const AuthChoiceScreen({super.key});

  static const Color red = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F7),
      appBar: AppBar(
        title: const Text('ابدأ رحلتك'),
        backgroundColor: red,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.bloodtype_rounded, size: 82, color: red),
                const SizedBox(height: 16),
                const Text(
                  'كل تبرع قد ينقذ حياة',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'أنشئ حسابًا أو سجّل دخولك للوصول إلى خدمات التطبيق.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text('تسجيل الدخول'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: red,
                      side: const BorderSide(color: red),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text('إنشاء حساب جديد'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
