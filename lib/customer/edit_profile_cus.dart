import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kinkorn/template/curve_app_bar.dart';
import 'package:kinkorn/template/bottom_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileCustomer extends StatefulWidget {
  const EditProfileCustomer({super.key});

  @override
  State<EditProfileCustomer> createState() => _EditProfileCustomerState();
}

class _EditProfileCustomerState extends State<EditProfileCustomer> {
  File? _image;
  String? imageProfileUrl;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDoc.exists) {
      final data = userDoc.data();
      setState(() {
        firstNameController.text =  data?['firstName'] ?? '';
        lastNameController.text =  data?['lastName'] ?? '';
        mobileController.text =  data?['mobile'] ?? '';
        imageProfileUrl = data?['imageProfileUrl'];
      });
    }
  }

  Future<void> _saveProfile() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final mobile = mobileController.text.trim();
    if (firstName.isEmpty || lastName.isEmpty || mobile.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    await FirebaseFirestore.instance
      .collection("users")
      .doc(uid)
      .update({
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'mobile': mobileController.text,

    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile update successfully!')),
    );
    Navigator.pop(context);
  }

  // ฟังก์ชันเลือกภาพจากแกลอรี่หรือกล้อง
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final file = File(pickedFile.path);

      // โหลดเข้า storage
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('$uid.jpg');
      await ref.putFile(file);
      final url = await ref.getDownloadURL();

      // เซฟ URL ลง Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'imageProfileUrl': url,
      }, SetOptions(merge: true));

      setState(() {
        _image = file;
        imageProfileUrl = url;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // 🔹 พื้นหลังสีเหลือง
          Positioned.fill(
            child: Container(color: const Color(0xFFFCF9CA)),
          ),
          // 🔹 App Bar โค้ง
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CurveAppBar(title: ''),
          ),
          Positioned(
            top: 70,
            left: 20,
            child: IconButton(
              icon:
                  const Icon(Icons.chevron_left, size: 40, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          // 🔹 หัวข้อ "Profile" และ กล่องรูปภาพ
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _pickImage, // คลิกที่กรอบเพื่อเลือกหรือถ่ายภาพ
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white, // 🔹 พื้นหลังสีขาว
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: _image != null
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_image!, fit: BoxFit.cover),
                      )
                      : imageProfileUrl != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            imageProfileUrl!, fit: BoxFit.cover,
                            errorBuilder: (context, error, StackTrace) => const Icon(Icons.error),
                          ),
                        )
                      : const Icon(Icons.image, size: 40, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 10),
                // ปุ่ม "เลือกภาพ" เมื่อยังไม่มีการเลือกภาพ
                if (_image == null)
                  ElevatedButton(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFAF1F1F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12), // เล็กลง
                      minimumSize: const Size(0, 0), // ขนาดเล็กสุด
                    ),
                    child: Text(
                      _image == null ? 'choose your photo' : 'edit your photo',
                      style: const TextStyle(
                          color: Colors.white, fontSize: 12),
                    ),
                  ),
                // ปุ่มแก้ไขรูปภาพถ้ามีการเลือกรูป
                if (_image != null) // ถ้ามีรูปจะแสดงปุ่มนี้
                  ElevatedButton(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFAF1F1F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12), // เล็กลง
                      minimumSize: const Size(0, 0), // ขนาดเล็กสุด
                    ),
                    child: const Text(
                      'edit your photo',
                      style: TextStyle(
                          color: Colors.white, fontSize: 12), // เล็กลง
                    ),
                  ),
              ],
            ),
          ),
          // 🔹 TextField ส่วนกรอกข้อมูล
          Positioned.fill(
            top: 330, // ขยับลงมาจากกรอบรูป
            bottom: 80,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildTextField(label: 'First Name', controller: firstNameController),
                    const SizedBox(height: 15),
                    _buildTextField(label: 'Last Name', controller: lastNameController),
                    const SizedBox(height: 15),
                    _buildTextField(label: 'Mobile Number', controller: mobileController),
                    const SizedBox(height: 30),
                    // ✅ ปุ่ม Save
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFAF1F1F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: _saveProfile,
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                        child:
                            Text('Save', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label, 
    required TextEditingController controller,
    bool obscureText = false
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFFAF1F1F),
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: 300,
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: Color(0xFFAF1F1F), width: 2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
