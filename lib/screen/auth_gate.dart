import 'package:blood_donation/providers/auth_provider.dart';
import 'package:blood_donation/screen/home_screen.dart';
import 'package:blood_donation/screen/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Chooses the first screen from Firebase's current sign-in state.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.isInitializing) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (auth.isSignedIn) return  HomeScreen();
    return const WelcomeScreen();
  }
}
