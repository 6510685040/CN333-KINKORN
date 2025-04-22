import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // นำเข้า SvgPicture
import 'login.dart'; // นำเข้า LoginScreen

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ใช้ Future.delayed เพื่อไปหน้า Login อัตโนมัติ
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFAF1F1F),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo หรือ รูปภาพด้านบน
                SvgPicture.asset(
                  'assets/images/logo.svg',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 40),
                const Text(
                  "Application for ordering food",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                const Text(
                  "@THAMMASAT UNIVERSITY",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

