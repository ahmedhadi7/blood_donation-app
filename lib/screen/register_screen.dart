import 'package:blood_donation/providers/auth_provider.dart';
import 'package:blood_donation/screen/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final success = await auth.createAccount(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (!mounted) return;
    if (success) {
      // Close RegisterScreen and any auth-choice/welcome routes above AuthGate.
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AuthGate()),
        (route) => false,
      );
      return;
    }
    if (auth.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    const red = Color(0xFFE53935);

    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء حساب'), backgroundColor: red,
        foregroundColor: Colors.white),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.person_add_alt_1, size: 68, color: red),
                  const SizedBox(height: 12),
                  const Text('انضم إلى مجتمع التبرع', textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'الاسم الكامل', prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => (value == null || value.trim().isEmpty)
                        ? 'يرجى إدخال الاسم' : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.newUsername, AutofillHints.email],
                    decoration: const InputDecoration(
                      labelText: 'البريد الإلكتروني', prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      final email = value?.trim() ?? '';
                      if (email.isEmpty) return 'يرجى إدخال البريد الإلكتروني';
                      if (!email.contains('@') || !email.contains('.')) {
                        return 'يرجى إدخال بريد إلكتروني صحيح';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _hidePassword,
                    autofillHints: const [AutofillHints.newPassword],
                    decoration: InputDecoration(
                      labelText: 'كلمة المرور', prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _hidePassword = !_hidePassword),
                        icon: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'يرجى إدخال كلمة المرور';
                      if (value.length < 6) return 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _hideConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'تأكيد كلمة المرور', prefixIcon: const Icon(Icons.lock_reset),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _hideConfirmPassword = !_hideConfirmPassword),
                        icon: Icon(_hideConfirmPassword ? Icons.visibility : Icons.visibility_off),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'يرجى تأكيد كلمة المرور';
                      if (value != _passwordController.text) return 'كلمتا المرور غير متطابقتين';
                      return null;
                    },
                  ),
                  const SizedBox(height: 22),
                  ElevatedButton(
                    onPressed: auth.isBusy ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: red, foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: auth.isBusy
                        ? const SizedBox(width: 22, height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('إنشاء الحساب'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
