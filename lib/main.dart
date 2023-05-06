import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:moody_final/auth.dart';
import 'package:moody_final/screens/home_screen.dart';
import 'package:moody_final/screens/login_screen.dart';
import 'package:moody_final/screens/signup_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Moody App',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      // home: const Auth(),
      routes: {
        '/': (context) => const Auth(),
        // '/': (context) => const HomeScreen(),
        'homeScreen': (context) => const HomeScreen(),
        'signupScreen': (context) => const SignupScreen(),
        'loginScreen': (context) => const LoginScreen(),
      },
    );
  }
}
