import 'package:flutter/material.dart';
import 'package:kinkorn/template/curve_app_bar.dart';
import 'package:kinkorn/template/restaurant_bottom_nav.dart';
import 'package:kinkorn/restaurant/status_complete.dart';

class StatusPreparing extends StatelessWidget {
  const StatusPreparing({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9CA),
      body: Stack(
        children: [
          // 🔹 App Bar
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CurveAppBar(title: ''),
          ),
           // 🔹 ปุ่มย้อนกลับ
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.chevron_left, size: 30, color: Color(0xFFFCF9CA)),
              onPressed: () {
                Navigator.pop(context);
              },    
            ),
          ),

          // 🔹 หัวข้อ "Order details"
          const Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Order details',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFCF9CA),
                ),
              ),
            ),
          ),

          // 🔹 เนื้อหาหลัก
          Positioned.fill(
            top: 250,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ การ์ดแดงหลัก
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB71C1C),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🔹 "Preparing food" + เวลา
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Color(0xFF848484),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Preparing food',
                                  style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const Text(
                                '30 mins ago',
                                style: TextStyle(color: Color(0xFFFCF9CA), fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // 🔹 Order ID + ชื่อผู้สั่ง
                          const Text(
                            'Order ID : tujc01250206003',
                            style: TextStyle(color:Color(0xFFFCF9CA), fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 14,
                                child: Icon(Icons.person, color: Colors.red),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'เจนรดา 091-234-5678',
                                style: TextStyle(color: Color(0xFFFCF9CA), fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // 🔹 ชื่อร้าน + ตำแหน่งร้าน
                          const Text(
                            'ครัวสุขใจ - อาหารนานาชาติ\nLocation : SCI/JC canteen',
                            style: TextStyle(color: Color(0xFFFCF9CA), fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),

                          // 🔹 เวลาออเดอร์ + เวลารับอาหาร
                          const Text(
                            'Order time : 19/02/2025 11:45\nPick up time : 12:30',
                            style: TextStyle(color: Color(0xFFFCF9CA), fontSize: 16),
                          ),
                          const SizedBox(height: 16),

                          // ✅ กล่องเมนูสีขาว
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Menu',
                                  style: TextStyle(color: Color(0xFFAF1F1F), fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('ข้าวกะเพราหมูสับ + ไข่ดาว x1',style: TextStyle(color: Color(0xFFAF1F1F), fontWeight: FontWeight.bold)),
                                    Text('฿55.00',style: TextStyle(color: Color(0xFFAF1F1F), fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('ข้าวผัดไข่ x1',style: TextStyle(color: Color(0xFFAF1F1F), fontWeight: FontWeight.bold)),
                                    Text('฿45.00',style: TextStyle(color: Color(0xFFAF1F1F), fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // ✅ Total
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Color(0xFFFDDC5C),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text(
                                'Total  100.00  baht',
                                style: TextStyle(color: Color(0xFFAF1F1F),fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          //ปุ่ม Check payment details and Order is ready to pick up
                          // Check payment details
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                            backgroundColor:Color(0xFFB7B7B7),
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                              ),
                              elevation: 5, // ✅ ทำให้ปุ่มลอยขึ้น
                              shadowColor: Colors.black.withOpacity(0.3),
                            ),
                            onPressed: () {},
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Center(
                                child: Text(
                                  'Check payment details',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Order is ready to pick up
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF5E235D),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 5, // ✅ ทำให้ปุ่มลอยขึ้น
                              shadowColor: Colors.black.withOpacity(0.3),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => StatusComplete()),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Center(
                                child: Text(
                                  'Order is ready to pick up',
                                  style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
}