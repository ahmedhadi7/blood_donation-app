import 'package:blood_donation/firebase_options.dart';
import 'package:blood_donation/providers/auth_provider.dart';
import 'package:blood_donation/providers/donor_provider.dart';
import 'package:blood_donation/screen/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DonorProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFFE53935),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFE53935),
            secondary: const Color(0xFFFF8A00),
          ),
          textTheme: GoogleFonts.cairoTextTheme(),
          useMaterial3: true,
        ),
        home: const WelcomeScreen(),
      ),
    );
  }
}
