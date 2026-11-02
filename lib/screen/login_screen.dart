import 'package:blood_donation/providers/auth_provider.dart';
import 'package:blood_donation/screen/auth_gate.dart';
import 'package:blood_donation/screen/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hidePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final success = await auth.signIn(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (!mounted) return;
    if (success) {
    
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
      appBar: AppBar(title: const Text('تسجيل الدخول'), backgroundColor: red,
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
                  const Icon(Icons.bloodtype_rounded, size: 72, color: red),
                  const SizedBox(height: 16),
                  const Text('أهلًا بعودتك', textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 28),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
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
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _hidePassword,
                    autofillHints: const [AutofillHints.password],
                    decoration: InputDecoration(
                      labelText: 'كلمة المرور',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _hidePassword = !_hidePassword),
                        icon: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off),
                      ),
                    ),
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'يرجى إدخال كلمة المرور' : null,
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
                        : const Text('دخول'),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: auth.isBusy ? null : () => Navigator.push(
                      context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                    child: const Text('ليس لديك حساب؟ أنشئ حسابًا جديدًا'),
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
