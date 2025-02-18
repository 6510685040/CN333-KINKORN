import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:kinkorn/template/curve_app_bar.dart';
import 'package:kinkorn/template/restaurant_bottom_nav.dart';

class OrderStatusRestaurant extends StatefulWidget {
  const OrderStatusRestaurant({super.key});

  @override
  State<OrderStatusRestaurant> createState() => _OrderStatusRestaurantState();
}

class _OrderStatusRestaurantState extends State<OrderStatusRestaurant> {
  DateTime _fromDate = DateTime.now();
  DateTime _tillDate = DateTime.now();

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    DateTime initialDate = isFromDate ? _fromDate : _tillDate;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != initialDate) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
        } else {
          _tillDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9CA),
      body: Stack(
        children: [
          const Positioned(top: 0, left: 0, right: 0, child: CurveAppBar(title: '')),

          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.chevron_left, size: 30, color:Color(0xFFFCF9CA)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),

          const Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Order Status',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFFCF9CA)),
              ),
            ),
          ),

          Positioned(
            top: 220,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("From", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red)),
                const SizedBox(width: 8),
                _buildDatePickerBox(context, _fromDate, true),
                const SizedBox(width: 16),
                const Text("Till", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red)),
                const SizedBox(width: 8),
                _buildDatePickerBox(context, _tillDate, false),
              ],
            ),
          ),

          Positioned.fill(
            top: 260,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  _buildOrderCard(
                    orderId: "tujc01250206003",
                    timeAgo: "1 min ago",
                    name: "เจนรดา 091-234-5678",
                    menuItems: ["ข้าวกะเพราหมูสับ + ไข่ดาว x1", "ข้าวผัดไก่ x1"],
                    pickUpTime: "12:30",
                    totalPrice: "฿100.00",
                    statusText: "Waiting for order\nconfirmation",
                    statusColor: Color(0xFF203976),
                    statusIcon: Symbols.receipt_long,
                  ),
                  _buildOrderCard(
                    orderId: "tujc01250206002",
                    timeAgo: "25 mins ago",
                    name: "พิมมาดา 095-678-5678",
                    menuItems: ["ข้าวกะเพราหมูสับ + ไข่ดาว x1"],
                    pickUpTime: "12:10",
                    totalPrice: "฿55.00",
                    statusText: "Preparing food",
                    statusColor: Colors.grey[700]!,
                    statusIcon: Symbols.skillet,
                  ),
                  _buildOrderCard(
                    orderId: "tujc01250206001",
                    timeAgo: "28 mins ago",
                    name: "ภคิน 091-234-1234",
                    menuItems: ["ข้าวหมูกระเทียม x1"],
                    pickUpTime: "12:05",
                    totalPrice: "฿55.00",
                    statusText: "Completed",
                    statusColor: Colors.green,
                    statusIcon: Symbols.restaurant,
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

  Widget _buildDatePickerBox(BuildContext context, DateTime date, bool isFromDate) {
    return GestureDetector(
      onTap: () => _selectDate(context, isFromDate),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(DateFormat("MMM dd, yyyy").format(date), style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            const Icon(Icons.calendar_today, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard({
    required String orderId,
    required String timeAgo,
    required String name,
    required List<String> menuItems,
    required String pickUpTime,
    required String totalPrice,
    required String statusText,
    required Color statusColor,
    required IconData statusIcon,
  }) {
    return Container(
    //margin: const EdgeInsets.only(bottom: 16),
    margin: const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      color: const Color(0xFFAF1F1F),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      children: [
        // 🔹 แถวบนสุด (Order ID & Time)
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
                style: const TextStyle(color:Color(0xFFFCF9CA), fontSize: 12),
              ),
            ],
          ),
        ),

        // 🔹 เนื้อหาออเดอร์
        Row(
          children: [
            // ✅ กล่องข้อมูลลูกค้า & รายการอาหาร
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
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFFB71C1C)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // 🔹 รายการอาหาร
                    const Text("Order summary", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ...menuItems.map((item) => Text("• $item", style: const TextStyle(fontSize: 12))),
                    
                    const SizedBox(height: 8),
                    Text("Pick up time : $pickUpTime", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFB71C1C))),
                  ],
                ),
              ),
            ),

            // ✅ กล่องราคารวม + สถานะ
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(statusIcon, color: Color(0xFFFCF9CA), size: 40),
                Text(
                  "Total: $totalPrice",
                  style: const TextStyle(color: Color(0xFFFCF9CA), fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  width: 100, 
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center, 
                    softWrap: true, 
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
