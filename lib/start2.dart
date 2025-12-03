import 'package:flutter/material.dart';

class Start2Page extends StatelessWidget {
  const Start2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', width: 150, height: 150),
            const SizedBox(height: 30),

            const Text(
              "AI-тэй хамт өөрийгөө олж мэдээрэй!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            const Text(
              "Бид танд мэдээ, мэдээлэл, тестүүдээр туслах боломжийг олгоно.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),

            const SizedBox(height: 40),

            // Нэвтрэх товч
            // Нэвтрэх товч
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA58BFF),
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text("Нэвтрэх", style: TextStyle(fontSize: 16)),
            ),

            const SizedBox(height: 15),

            // Бүртгүүлэх товч
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/signin');
              },
              child: const Text("Бүртгүүлэх", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
