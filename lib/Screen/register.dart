import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  @override
Widget build(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFAF1F1F),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
  
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFAF1F1F),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.08), // ขยับลง 8%
                child: SvgPicture.asset(
                  'assets/images/logo.svg',
                  width: screenWidth * 0.8,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                width: screenWidth * 0.85,
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
                      buildTextField(
                          "Email", "Enter your email", emailController,
                          validator: MultiValidator([
                            RequiredValidator(errorText: "Email is required"),
                            EmailValidator(errorText: "Invalid email format"),
                          ])),
                      buildTextField(
                          "Password", "Enter your password", passwordController,
                          obscureText: true,
                          validator: RequiredValidator(
                              errorText: "Password is required")),
                      buildTextField("Confirm Password",
                          "Confirm your password", confirmPasswordController,
                          obscureText: true, validator: (value) {
                        if (value != passwordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      }),
                      buildTextField("First Name", "Enter your first name",
                          firstNameController,
                          validator: RequiredValidator(
                              errorText: "First name is required")),
                      buildTextField("Last Name", "Enter your last name",
                          lastNameController,
                          validator: RequiredValidator(
                              errorText: "Last name is required")),
                      buildTextField("Mobile Number",
                          "Enter your mobile number", mobileController,
                          validator: RequiredValidator(
                              errorText: "Mobile number is required")),
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
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              try {
                                // Register with Firebase
                                UserCredential userCredential =
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                                List<dynamic> currentRoles = [];
                                currentRoles.add('customer');

                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(userCredential.user?.uid)
                                    .set({
                                  'firstName': firstNameController.text,
                                  'lastName': lastNameController.text,
                                  'mobile': mobileController.text,
                                  'roles': currentRoles
                                });

                           
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Account created successfully!')),
                                );
                            
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()),
                                );
                              } on FirebaseAuthException catch (e) {
                                // Handle registration errors
                                String message =
                                    'An error occurred. Please try again.';
                                if (e.code == 'email-already-in-use') {
                                  message = 'This email is already registered.';
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(message)),
                                );
                              }
                            }
                          },
                          child: const Text(
                            'Create Account',
                            style: TextStyle(
                              //fontFamily: 'GeistFont',
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
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 สร้าง Widget Reusable สำหรับ TextFormField
  Widget buildTextField(
      String label, String hint, TextEditingController controller,
      {bool obscureText = false, String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            //fontFamily: 'GeistFont',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xFFAF1F1F),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(color: Color(0xFFD9D9D9), width: 2),
            ),
          ),
          validator: validator,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
