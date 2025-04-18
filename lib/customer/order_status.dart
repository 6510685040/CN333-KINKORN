import 'package:flutter/material.dart';
import 'package:kinkorn/customer/waiting_approve.dart';
import 'package:kinkorn/template/curve_app_bar.dart';
import 'package:kinkorn/template/bottom_bar.dart';
import 'package:intl/intl.dart';
import 'package:kinkorn/customer/order_detail.dart';

class OrderStatusCustomer extends StatefulWidget {
  const OrderStatusCustomer({super.key});

  @override
  State<OrderStatusCustomer> createState() => _OrderStatusCustomerState();
}

class _OrderStatusCustomerState extends State<OrderStatusCustomer> {
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double bottomBarHeight = 60.0;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight,
            color: Colors.yellow[100],
            child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center // จัดให้อยู่กึ่งกลางแนวตั้ง
                ),
          ),
          Stack(
            children: [
              const CurveAppBar(title: "Order status"),
              Positioned(
                top: 180,
                bottom: 10, // ปรับตำแหน่งขึ้นลง
                left: 0,
                right: 0,
                child: _buildDatePickerRow(context),
              ),
            ],
          ),
          Positioned.fill(
            top: 0.28 * screenHeight, // ให้ Order List อยู่ใต้ Date Picker
            bottom: bottomBarHeight,
            child: Container(
              padding: const EdgeInsets.all(30),
              child: SingleChildScrollView(
                child: _buildOrderList(),
              ),
            ),
          ),
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

  Widget _buildDatePickerRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDateLabel("From"),
        _buildDatePickerBox(context, _fromDate, true),
        const SizedBox(width: 16),
        _buildDateLabel("Till"),
        _buildDatePickerBox(context, _tillDate, false),
      ],
    );
  }

  Widget _buildDateLabel(String text) {
    return Padding(
      padding: const EdgeInsets.all(3), // ✅ กำหนด padding 3px
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFFB71C1C),
        ),
      ),
    );
  }

  Widget _buildDatePickerBox(
      BuildContext context, DateTime date, bool isFromDate) {
    return GestureDetector(
      onTap: () => _selectDate(context, isFromDate),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(DateFormat("MMM dd, yyyy").format(date),
                style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            const Icon(Icons.calendar_today, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList() {
    return Column(
      children: [
        _buildOrderCard(
          orderId: "cst01250206003",
          timeAgo: "5 mins ago",
          restaurantName: "ร้านกะเพราเด็ด",
          menuItems: ["ข้าวกะเพราหมูสับ + ไข่ดาว x1", "ข้าวผัดไก่ x1"],
          statusText: "Waiting for payment",
          statusColor: Colors.blue,
          timeorder: "Jun 10 , 11:45",
        ),
        _buildOrderCard(
          orderId: "cst01250206002",
          timeAgo: "15 mins ago",
          restaurantName: "ร้านข้าวมันไก่เจ๊แดง",
          menuItems: ["ข้าวมันไก่ทอด x1"],
          statusText: "Waiting for payment confirmation",
          statusColor: Color(0xFFFDDC5C),
          timeorder: "Jun 10 , 10:45",
        ),
        _buildOrderCard(
          orderId: "cst01250206001",
          timeAgo: "30 mins ago",
          restaurantName: "ร้านส้มตำแซ่บเว่อร์",
          menuItems: ["ตำไทย x1", "ไก่ย่าง x1"],
          statusText: "Preparing food",
          statusColor: Colors.grey,
          timeorder: "Jun 10 , 09:45",
        ),
        _buildOrderCard(
          orderId: "cst01250206000",
          timeAgo: "45 mins ago",
          restaurantName: "ร้านข้าวหมูแดง",
          menuItems: ["ข้าวหมูแดง x1"],
          statusText: "Completed",
          statusColor: Colors.green,
          timeorder: "Jun 10 , 08:45",
        ),
        _buildOrderCard(
          orderId: "cst01250206000",
          timeAgo: "45 mins ago",
          restaurantName: "ร้านข้าวหมูแดง",
          menuItems: ["ข้าวหมูแดง x1"],
          statusText: "Completed",
          statusColor: Colors.green,
          timeorder: "Jun 10 , 08:40",
        ),
      ],
    );
  }

  Widget _buildOrderCard({
    required String orderId,
    required String timeAgo,
    required String restaurantName,
    required List<String> menuItems,
    required String statusText,
    required Color statusColor,
    required String timeorder,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFB71C1C),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //ชื่อร้าน
                Text("ร้าน: $restaurantName",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                // เวลาสั่งซื้อ
                Text("เวลาสั่งซื้อ: $timeorder",
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
                const SizedBox(height: 4),
                //แสดงรายการอาหาร
                const Text("Order Summary",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                ...menuItems
                    .map((item) =>
                        Text(item, style: const TextStyle(color: Colors.white)))
                    .toList(),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailPage(
                    orderId: orderId,
                    customerName: "สมชาย ใจดี",
                    phoneNumber: "091-234-5678",
                    restaurantName: restaurantName,
                    canteenName: "โรงอาหารกลาง",
                    orderTime: "10:30 AM",
                    pickupTime: "11:00 AM",
                    menuItems: menuItems,
                    totalAmount: "100.00",
                    statusText: statusText,
                    statusColor: statusColor,
                    timeAgo: timeAgo,
                  ),
                ),
              );
            },
            child: Container(
              width: 120,
              height: 80,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Text(
                statusText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 4.0, // ความเบลอของเงา
                      color: Colors.black54, // สีของเงา
                      offset: Offset(1, 1), // การเลื่อนตำแหน่งของเงา (X, Y)
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
}
