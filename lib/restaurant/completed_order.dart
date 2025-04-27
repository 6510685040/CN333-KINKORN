// CompletedOrderRestaurant.dart - แก้ไฟล์เพิ่ม Add-ons ให้ใน Order summary

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kinkorn/restaurant/homepage.dart';
import 'package:kinkorn/restaurant/order_detailRestaurant.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kinkorn/template/curve_app_bar.dart';
import 'package:kinkorn/template/restaurant_bottom_nav.dart';

class CompletedOrderRestaurant extends StatefulWidget {
  const CompletedOrderRestaurant({super.key});

  @override
  State<CompletedOrderRestaurant> createState() => _CompletedOrderRestaurantState();
}

class _CompletedOrderRestaurantState extends State<CompletedOrderRestaurant> {
  late DateTime _fromDate;
  late DateTime _tillDate;

  @override
  void initState() {
    super.initState();
    _fromDate = DateTime.now();
    _tillDate = DateTime.now();
  }

  DateTime _getStartOfDay() => DateTime(_fromDate.year, _fromDate.month, _fromDate.day);
  DateTime _getEndOfDay() => DateTime(_tillDate.year, _tillDate.month, _tillDate.day, 23, 59, 59);

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    DateTime initialDate = isFromDate ? _fromDate : _tillDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
        } else {
          _tillDate = picked;
        }
      });
    }
  }

  Future<String> _getCustomerName(String customerId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(customerId).get();
      if (doc.exists) {
        final data = doc.data()!;
        return '${data['firstName'] ?? ''} ${data['lastName'] ?? ''} ${data['mobile'] ?? ''}';
      }
    } catch (e) {
      print("Error fetching customer: $e");
    }
    return 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    final restaurantId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9CA),
      body: Stack(
        children: [
          const Positioned(top: 0, left: 0, right: 0, child: CurveAppBar(title: '')),
          Positioned(
            top: 75,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.chevron_left, size: 30, color: Color(0xFFFCF9CA)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RestaurantDashboard()),
                );
              },
            ),
          ),
          const Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Completed Orders',
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
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                .collection('restaurants')
                .doc(restaurantId)
                .collection('orders')
                .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(_getStartOfDay()))
                .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(_getEndOfDay()))
                .where('orderStatus', isEqualTo: 'Completed')
                .orderBy('createdAt', descending: true)
                .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No orders found"));
                }
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final createdAt = (data['createdAt'] as Timestamp).toDate();
                    final pickUpTime = DateFormat("HH:mm").format((data['pickupTime'] as Timestamp).toDate());
                    final totalAmount = data['totalAmount'] ?? 0;
                    final status = data['orderStatus'] ?? 'unknown';
                    final customerId = data['customerId'] ?? '';
                    final items = List<Map<String, dynamic>>.from(data['orders'] ?? []);

                    final List<String> menuItems = [];
                    for (var item in items) {
                      final name = item['name'] ?? 'Unnamed';
                      final quantity = item['quantity'] ?? 0;
                      menuItems.add('$name x$quantity');

                      final addons = (item['addons'] is List) ? List<Map<String, dynamic>>.from(item['addons']) : [];

                      for (var addon in addons) {
                        final addonName = addon['name'] ?? 'Unnamed Addon';
                        final addonQty = addon['quantity'] ?? 0;
                        menuItems.add('  • $addonName x$addonQty');
                      }
                    }

                    final timeAgo = _getTimeAgo(createdAt);
                    final statusInfo = _getStatusInfo(status);

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => OrderdetailRestaurant(orderId: doc.id, customerId: customerId),
                        ));
                      },
                      child: FutureBuilder<String>(
                        future: _getCustomerName(customerId),
                        builder: (context, nameSnapshot) {
                          final name = nameSnapshot.data ?? 'Loading...';
                          return _buildOrderCard(
                            orderId: doc.id,
                            timeAgo: timeAgo,
                            name: name,
                            menuItems: menuItems,
                            pickUpTime: pickUpTime,
                            totalPrice: '฿${totalAmount.toStringAsFixed(2)}',
                            statusText: statusInfo['text'],
                            statusColor: statusInfo['color'],
                            statusIcon: statusInfo['icon'],
                          );
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
      //bottomNavigationBar: const CustomBottomNav(),
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
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFAF1F1F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Order ID : $orderId", style: const TextStyle(color: Color(0xFFFCF9CA), fontSize: 14, fontWeight: FontWeight.bold)),
                Text(timeAgo, style: const TextStyle(color: Color(0xFFFCF9CA), fontSize: 12)),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(radius: 12, backgroundColor: Color.fromARGB(255, 250, 176, 47), child: Icon(Icons.person, color: Colors.white, size: 14)),
                          const SizedBox(width: 8),
                          Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFFB71C1C)), overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text("Order summary", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFFB71C1C))),
                      ...menuItems.map((item) => Text(item, style: const TextStyle(fontSize: 12, color: Color(0xFFB71C1C)))),
                      const SizedBox(height: 8),
                      Text("Pick up time : $pickUpTime", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFB71C1C))),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(statusIcon, color: Color(0xFFFCF9CA), size: 40),
                  Text("Total: $totalPrice", style: const TextStyle(color: Color(0xFFFCF9CA), fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    width: 100,
                    decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(8)),
                    child: Text(statusText, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
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

  String _getTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return "just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes} mins ago";
    if (diff.inHours < 24) return "${diff.inHours} hours ago";
    return DateFormat("dd MMM").format(dateTime);
  }

  Map<String, dynamic> _getStatusInfo(String status) {
    switch (status) {
      case "Waiting for restaurant approval":
        return {"text": "Waiting for order\nconfirmation", "color": const Color(0xFF203976), "icon": Symbols.receipt_long};
      case "Waiting for payment":
        return {"text": "Waiting for payment", "color": Colors.yellow, "icon": Symbols.receipt_long};
      case "Waiting for payment confirmation":
        return {"text": "Waiting for payment\nconfirmation", "color": Colors.yellow, "icon": Symbols.receipt_long};
      case "Preparing food":
        return {"text": "Preparing food", "color": const Color.fromARGB(255, 132, 132, 132), "icon": Symbols.skillet};
      case "Completed":
        return {"text": "Completed", "color": Colors.green, "icon": Symbols.restaurant};
      case "Canceled":
        return {"text": "Canceled", "color": Colors.black, "icon": Icons.cancel};
      default:
        return {"text": "Unknown", "color": Colors.grey, "icon": Icons.help_outline};
    }
  }
}
