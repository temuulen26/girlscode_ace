import 'package:flutter/material.dart';
import 'home.dart';
import 'start1.dart';
import 'start2.dart';
import 'signin.dart';
import 'loginin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ACE App',
      initialRoute: '/start1',
      routes: {
        '/start1': (context) => const Start1Page(),
        '/start2': (context) => const Start2Page(),
        '/signin': (context) => const SignInPage(),
        '/home': (context) => const HomePage(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}
