import 'package:flutter/material.dart';
import 'package:kinkorn/customer/waiting_approve.dart';
import 'package:kinkorn/template/curve_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class OrderSummary extends StatefulWidget {
  const OrderSummary({super.key});

  @override
  _OrderSummaryState createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final List<Map<String, dynamic>> orders = [
      {'name': 'ข้าวกะเพราหมูสับ', 'quantity': 1, 'price': 55.00},
      {'name': 'ข้าวผัดไข่', 'quantity': 1, 'price': 45.00},
    ];

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight,
            color: Colors.yellow[100],
          ),
          // ใช้ CurveAppBar อยู่ที่ตำแหน่งบนสุด
          const CurveAppBar(title: "ครัวสุใจโรงอาหาร JC"),

          Positioned(
            top: 190, // ปรับตำแหน่งให้ติดกับคำว่า "Order summary"
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "Order summary",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 0.087 * screenWidth,
                  color: Color(0xFFB71C1C),
                ),
              ),
            ),
          ),

          // ใช้ SingleChildScrollView แบบที่ไม่ทับกับ AppBar
          Positioned(
            top: 240, // ปรับตำแหน่งให้ข้อมูลอยู่ติดกับ "Order summary"
            left: 0,
            right: 0,
            bottom: 0, // ให้เนื้อหายืดเต็มหน้าจอ
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  ...orders.map((order) {
                    final double totalPrice =
                        order['quantity'] * order['price'];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${order['quantity']}x ${order['name']}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '฿${totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFB71C1C),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        'Total : ฿${orders.fold(0.0, (sum, order) => sum + (order['quantity'] * order['price'])).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      "Payment method",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 0.087 * screenWidth,
                        color: Color(0xFFB71C1C),
                      ),
                    ),
                  ),
                  Center(
                    child: Image.asset(
                      "assets/images/qr.jpg",
                      width: 0.5 * screenWidth,
                    ),
                  ),
                  SizedBox(height: 20),
                  // ปุ่ม 2 อันล่าง
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _pickImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 164, 171, 177),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          "Upload slip",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 20),
                      // ลิงก์ไปหน้า order_status
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    WaitingApprove()), // ไปหน้า Waiting
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF35AF1F),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          "Confirm payment",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  if (_selectedImage != null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Image.file(
                          _selectedImage!,
                          width: 0.5 * screenWidth,
                          height: 200,
                          fit: BoxFit.cover,
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
}
