import 'dart:io'; // ✅ ใช้สำหรับแสดงไฟล์ที่เลือก
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // ✅ ใช้ image_picker
import 'package:kinkorn/template/curve_app_bar.dart';

class EditProfileRestaurant extends StatefulWidget {
  const EditProfileRestaurant({super.key});

  @override
  State<EditProfileRestaurant> createState() => _EditProfileRestaurantState();
}

class _EditProfileRestaurantState extends State<EditProfileRestaurant> {
  File? _image; // ✅ เก็บรูปภาพที่เลือก
  final ImagePicker _picker = ImagePicker(); // ✅ ตัวเลือกภาพ

  // 📌 ฟังก์ชันเลือกภาพจากแกลเลอรี
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // ✅ อัปเดตภาพที่เลือก
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: const Color(0xFFFCF9CA),
            ),
          ),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CurveAppBar(title: ''),
          ),
          // ✅ เนื้อหาส่วนบน (Profile + รูปภาพ)
          Positioned(
            top: 70, // ✅ ขยับ "Profile" ขึ้นไปใกล้ขอบบน
            left: 0,
            right: 0,
            child: Column(
              children: [
                const Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10), // ✅ ระยะห่างระหว่าง "Profile" กับรูปภาพ
                GestureDetector(
                  onTap: _pickImage, // 📌 กดที่รูปเพื่อเลือกภาพใหม่
                  child: Container(
                    width: 80, // ✅ ปรับขนาดสี่เหลี่ยม
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12), // ✅ ทำให้เป็นสี่เหลี่ยมโค้งมน
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
                            child: Image.file(
                              _image!, // ✅ แสดงภาพที่ผู้ใช้เลือก
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            Icons.camera_alt, // ✅ ไอคอนเริ่มต้น
                            color: Colors.grey[700],
                            size: 30,
                          ),
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            top: 220, // ✅ ขยับให้ TextField อยู่ต่ำลงจากรูปโปรไฟล์
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(label: 'Username'),
                  _buildTextField(label: 'Password', obscureText: true),
                  _buildTextField(label: 'Confirm Password', obscureText: true),
                  _buildTextField(label: 'First Name'),
                  _buildTextField(label: 'Last Name'),
                  _buildTextField(label: 'Restaurant Name'),
                  _buildTextField(label: 'Email'),
                  _buildTextField(label: 'Mobile Number'),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFAF1F1F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context); // กลับไปหน้า Profile
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                        child: Text('Save', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({required String label, bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
