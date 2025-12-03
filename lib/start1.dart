import 'package:flutter/material.dart';
import 'dart:async';

class Start1Page extends StatelessWidget {
  const Start1Page({super.key});

  @override
  Widget build(BuildContext context) {
    // 3 секундийн дараа Start2Page руу шилжих
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/start2');
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/logo.png', width: 150, height: 150),
      ),
    );
  }
}
