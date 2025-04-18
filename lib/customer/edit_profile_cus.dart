import 'package:flutter/material.dart';
import 'package:kinkorn/template/curve_app_bar.dart';
import 'package:kinkorn/template/bottom_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileCustomer extends StatefulWidget {
  const EditProfileCustomer({super.key});

  @override
  _EditProfileCustomerState createState() => _EditProfileCustomerState();
}

class _EditProfileCustomerState extends State<EditProfileCustomer> {
  File? _image; // ตัวแปรเก็บไฟล์รูปภาพที่เลือก

  // ฟังก์ชันเลือกภาพจากแกลอรี่หรือกล้อง
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery); // เลือกจากแกลอรี่
    // หรือใช้ ImageSource.camera สำหรับถ่ายภาพจากกล้อง

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // เก็บ path ของไฟล์ภาพ
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
            top: 40,
            left: 16,
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
            top: 50,
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
                    child: _image == null
                        ? const Icon(
                            Icons.image, // ถ้าไม่มีรูปจะแสดงเป็นไอคอน
                            color: Colors.grey,
                            size: 40,
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _image!, // แสดงภาพที่เลือก
                              fit: BoxFit.cover,
                            ),
                          ),
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
                    child: const Text(
                      'choose your photo',
                      style: TextStyle(
                          color: Colors.white, fontSize: 12), // เล็กลง
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
            top: 280, // ขยับลงมาจากกรอบรูป
            bottom: 80,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildTextField(label: 'Username'),
                    _buildTextField(label: 'Password', obscureText: true),
                    _buildTextField(
                        label: 'Confirm Password', obscureText: true),
                    _buildTextField(label: 'First Name'),
                    _buildTextField(label: 'Last Name'),
                    _buildTextField(label: 'Restaurant Name'),
                    _buildTextField(label: 'Email'),
                    _buildTextField(label: 'Mobile Number'),
                    const SizedBox(height: 15),
                    // ✅ ปุ่ม Save
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFAF1F1F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
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
          //footer bar
          Positioned(
            bottom: 0, // Adjusted to ensure it's at the bottom
            left: 0,
            right: 0,
            child: BottomBar(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({required String label, bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
          const SizedBox(height: 4),
          SizedBox(
            width: 300,
            child: TextField(
              obscureText: obscureText,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
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
