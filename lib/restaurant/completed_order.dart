import 'package:flutter/material.dart';
import 'package:kinkorn/template/curve_app_bar.dart';
import 'package:kinkorn/template/restaurant_bottom_nav.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class CompletedOrderRestaurant extends StatelessWidget {
  const CompletedOrderRestaurant({super.key});

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

          // 🔹 หัวข้อ "Completed Order"
          const Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Completed Order',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color:Color(0xFFFCF9CA)),
              ),
            ),
          ),

          // 🔹 รายการออเดอร์
          Positioned.fill(
            top: 250,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  _buildOrderCard(
                    orderId: "tujc01250206003",
                    timeAgo: "20 mins ago",
                    name: "เจนรดา 091-234-5678",
                    menuItems: [
                      "ข้าวกะเพราหมูสับ + ไข่ดาว x1",
                      "ข้าวผัดไก่ x1",
                    ],
                    pickUpTime: "12:30",
                    totalPrice: "฿100.00",
                  ),
                  _buildOrderCard(
                    orderId: "tujc01250206002",
                    timeAgo: "25 mins ago",
                    name: "พิมมาดา 095-678-5678",
                    menuItems: [
                      "ข้าวกะเพราหมูสับ + ไข่ดาว x1",
                    ],
                    pickUpTime: "12:10",
                    totalPrice: "฿55.00",
                  ),
                  _buildOrderCard(
                    orderId: "tujc01250206001",
                    timeAgo: "28 mins ago",
                    name: "ภคิน 091-234-1234",
                    menuItems: [
                      "ข้าวหมูกระเทียม x1",
                    ],
                    pickUpTime: "12:05",
                    totalPrice: "฿55.00",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(),
    );
  }

  Widget _buildOrderCard({
    required String orderId,
    required String timeAgo,
    required String name,
    required List<String> menuItems,
    required String pickUpTime,
    required String totalPrice,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFB71C1C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // 🔹 Order ID & เวลา
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order ID : $orderId",
                  style: const TextStyle(color: Color(0xFFFCF9CA), fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  timeAgo,
                  style: const TextStyle(color: Color(0xFFFCF9CA), fontSize: 12),
                ),
              ],
            ),
          ),

          // 🔹 ข้อมูลลูกค้า & รายการอาหาร
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔹 ชื่อผู้สั่ง
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.person, color: Colors.white, size: 14),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFFB71C1C),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // 🔹 รายการอาหาร
                      const Text("Order summary", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFFB71C1C))),
                      ...menuItems.map((item) => Text("• $item", style: const TextStyle(fontSize: 12,color:Color(0xFFB71C1C)))),
                      
                      const SizedBox(height: 8),
                      Text(
                        "Pick up time : $pickUpTime",
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFB71C1C)),
                      ),
                    ],
                  ),
                ),
              ),

              // ✅ กล่องราคารวม + สถานะ
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Symbols.restaurant, color: Color(0xFFFCF9CA), size: 40),
                  Text(
                    "Total: $totalPrice",
                    style: const TextStyle(color: Color(0xFFFCF9CA), fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    width: 100,
                    decoration: BoxDecoration(
                      color: Color(0xFF4c9534),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Completed",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}
