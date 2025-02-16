import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'login.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        color: const Color(0xFFAF1F1F),
        child: Stack(
          children: [
            // Image 1
            Positioned(
              left: screenWidth * 0.04, // 4% of screen width
              top: screenHeight * 0.1, // 10% of screen height
              child: SvgPicture.asset(
                'assets/images/logo.svg',
                width: screenWidth * 0.92, // 92% of screen width
                height: screenHeight * 0.11, // 11% of screen height
                fit: BoxFit.cover,
              ),
            ),
            // Rectangle 2 (Form container)
            Positioned(
              left: screenWidth * 0.1, // 10% of screen width
              top: screenHeight * 0.25, // 25% of screen height
              child: Container(
                width: screenWidth * 0.8, // 80% of screen width
                height: screenHeight * 0.7, // 70% of screen height
                decoration: BoxDecoration(
                  color: const Color(0xFFFCF9CA),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      offset: const Offset(0, 4),
                      blurRadius: 4,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(32),
                ),
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Username
                      const Text(
                        'Username',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFFAF1F1F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Enter your username',
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(
                                color: Color(0xFFD9D9D9), width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Password
                      const Text(
                        'Password',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFFAF1F1F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(
                                color: Color(0xFFD9D9D9), width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Confirm Password
                      const Text(
                        'Confirm Password',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFFAF1F1F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Confirm your password',
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(
                                color: Color(0xFFD9D9D9), width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // First name
                      const Text(
                        'First name',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFFAF1F1F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Enter your first name',
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(
                                color: Color(0xFFD9D9D9), width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Last name
                      const Text(
                        'Last name',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFFAF1F1F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Enter your last name',
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(
                                color: Color(0xFFD9D9D9), width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Email
                      const Text(
                        'Email',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFFAF1F1F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(
                                color: Color(0xFFD9D9D9), width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Mobile number
                      const Text(
                        'Mobile number',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFFAF1F1F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Enter your mobile number',
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(
                                color: Color(0xFFD9D9D9), width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Create Account Button
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFAF1F1F),
                            minimumSize: const Size(152, 42),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(64),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          },
                          child: const Text(
                            'Create Account',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
