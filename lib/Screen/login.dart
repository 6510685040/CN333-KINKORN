import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
<<<<<<< HEAD
import 'register.dart';
import 'package:kinkorn/customer/choose_canteen.dart';

class LoginScreen extends StatelessWidget {
=======
import 'package:form_field_validator/form_field_validator.dart';
import 'package:kinkorn/Screen/register.dart';
import 'package:kinkorn/customer/choose_canteen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
>>>>>>> b6e4b3030174274a19ac199aa70f1d4121b06625
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ฟังก์ชันตรวจสอบการเข้าสู่ระบบ
  /*Future<void> _loginUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? registeredEmail = prefs.getString('registeredEmail');
    String? registeredPassword = prefs.getString('registeredPassword');

    // เปรียบเทียบข้อมูลจากฟอร์มกับข้อมูลที่บันทึก
    if (usernameController.text == registeredEmail && passwordController.text == registeredPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ChooseCanteen()),
      );
    } else {
      // ถ้าไม่ตรงจะมีข้อความเตือน
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect email or password')),
      );
    }
  } */

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;
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
<<<<<<< HEAD
                  width: 100,
                  height: 100,
=======
                   width: screenWidth * 0.8, 
>>>>>>> b6e4b3030174274a19ac199aa70f1d4121b06625
                ),
                const SizedBox(height: 40),

                // กล่องฟอร์ม Login
                Form(
                  key: _formKey, // ใช้ฟอร์ม key
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    width: 326,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Username Input
                        const Text(
                          'Email',
                          style: TextStyle(
                            fontFamily: 'Geist',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xFFAF1F1F),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: usernameController, // ผูกกับ Controller
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
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: const BorderSide(
                                  color: Color(0xFFD9D9D9), width: 2),
                            ),
                          ),
                          validator: RequiredValidator(errorText: "Please fill username"), // ใช้ RequiredValidator
                        ),
                        const SizedBox(height: 20),

                        // Password Input
                        const Text(
                          'Password',
                          style: TextStyle(
                            fontFamily: 'Geist',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xFFAF1F1F),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: passwordController, // ผูกกับ Controller
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
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: const BorderSide(
                                  color: Color(0xFFD9D9D9), width: 2),
                            ),
                          ),
                          validator: (value) => RequiredValidator(errorText: "Please fill password")(value), // ใช้ RequiredValidator
                        ),
                        const SizedBox(height: 30),

                        // Login Button
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
                              ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Login  successfully!')),
                            );

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ChooseCanteen()),
                            );
                              // ตรวจสอบฟอร์มก่อน
                             /* if (_formKey.currentState?.validate() ?? false) {
                                _loginUser(); // ใช้ฟังก์ชัน login
                              } else {
                                // ถ้าฟอร์มไม่ถูกต้องจะแสดงข้อความผิดพลาด
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please fill in all fields')),
                                );
                              }
                              */
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontFamily: 'Geist',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Create an account
                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'or ',
                                  style: TextStyle(
                                    fontFamily: 'Geist',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Color(0xFFAF1F1F),
                                  ),
                                ),
                                TextSpan(
                                  text: 'Create an account',
                                  style: TextStyle(
                                    fontFamily: 'Geist',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Color(0xFFAF1F1F),
                                    decoration: TextDecoration.underline, // ใส่เส้นใต้เพื่อให้ดูเหมือนลิงก์
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // Navigate to RegisterScreen
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterScreen(),
                                        ),
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
