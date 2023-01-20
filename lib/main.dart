import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:the_serve_admin/screens/auth/login_page.dart';
import 'package:the_serve_admin/screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyB9YBhU-IkoYp-S-7UAq7_dUDdrYWJSklc",
    appId: "1:629251471094:web:d4271deedfe5a5a0075ed7",
    messagingSenderId: "629251471094",
    projectId: "theserve-5c90b",
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LandingPage(),
    );
  }
}
