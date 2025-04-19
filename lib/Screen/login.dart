import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kinkorn/customer/choose_canteen.dart';
import 'register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // หาก login สำเร็จ
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ChooseCanteen()),
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = e.message ?? "Login failed.";
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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
                SvgPicture.asset('assets/images/logo.svg', width: 100, height: 100),
                const SizedBox(height: 40),
                Container(
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Email',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xFFAF1F1F),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: TextFormField(
                            controller: _emailController,
                            validator: (value) =>
                                value == null || value.isEmpty ? 'Please enter your email' : null,
                            decoration: const InputDecoration(
                              hintText: 'Enter your Email',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),


                        const Text('Password', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xFFAF1F1F))),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                        
                          child: TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          validator: (value) => value == null || value.isEmpty ? 'Please enter your password' : null,
                          decoration: InputDecoration(
                            hintText: 'Enter your password',
                            //filled: true,
                            //fillColor: Colors.white,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility ,color: Color(0xFFAF1F1F)),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                        ),
                        ),
                        const SizedBox(height: 20),

                        if (_errorMessage != null)
                          Text(_errorMessage!, style: const TextStyle(color: Color(0xFFAF1F1F))),

                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFAF1F1F),
                              minimumSize: const Size(152, 42),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(64),
                              ),
                            ),
                            onPressed: _isLoading ? null : _login,
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text('Login', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'or ',
                                  style: TextStyle(fontSize: 14, color: Color(0xFFAF1F1F)),
                                ),
                                TextSpan(
                                  text: 'Create an account',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFFAF1F1F),
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const RegisterScreen()),
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                        )
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
