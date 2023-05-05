import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:moody_final/auth.dart';
import 'package:moody_final/screens/home_screen.dart';
import 'package:moody_final/screens/login_sceen.dart';
import 'package:moody_final/screens/signup_sceen.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const Auth(),
      routes: {
        '/': (context) => const Auth(),
        'homeScreen': (context) => const HomeScreen(),
        'signupScreen': (context) => const SignupScreen(),
        'loginScreen': (context) => const LoginScreen(),
        'mood-related': (context) => const HomeScreen()
      },
    );
  }
}
