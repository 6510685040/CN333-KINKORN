import 'package:flutter/material.dart';
import 'package:kinkorn/template/curve_app_bar.dart';
import 'package:kinkorn/template/restaurant_bottom_nav.dart'; 

class EditProfileRestaurant extends StatelessWidget {
  const EditProfileRestaurant({super.key});

  @override
  Widget build(BuildContext context) {
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
              icon: const Icon(Icons.chevron_left, size: 40, color: Colors.white),
              onPressed: () {
                Navigator.pop(context); //รอแก้
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
                Container(
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
                  child: const Icon(
                    Icons.image, // 
                    color: Colors.grey,
                    size: 40,
                  ),
                ),
              ],
            ),
          ),
          // 🔹 TextField ส่วนกรอกข้อมูล
          Positioned.fill(
            top: 250, 
            bottom: 80, 
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 80), // ✅ เผื่อให้เลื่อนแล้วไม่ทับปุ่ม
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildTextField(label: 'Username'),
                    _buildTextField(label: 'Password', obscureText: true),
                    _buildTextField(label: 'Confirm Password', obscureText: true),
                    _buildTextField(label: 'First Name'),
                    _buildTextField(label: 'Last Name'),
                    _buildTextField(label: 'Restaurant Name'),
                    _buildTextField(label: 'Email'),
                    _buildTextField(label: 'Mobile Number'),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
          // ✅ ปุ่ม Save ให้อยู่ติดล่างตลอด
          Positioned(
            left: 0,
            right: 0,
            bottom: 40, // ✅ ขยับขึ้นให้ไม่ทับ BottomNav
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFAF1F1F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context); // กลับไปหน้า Profile รอแก้ไปหน้า setting
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                  child: Text('Save', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(), // เพิ่มแถบเมนูด้านล่าง
    );
  }

  Widget _buildTextField({required String label, bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: 300, // ✅ กำหนดความกว้างให้ TextField
        child: TextField(
          obscureText: obscureText,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
    );
  }
}
