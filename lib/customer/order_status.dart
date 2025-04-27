import 'package:flutter/material.dart';
import 'package:kinkorn/customer/order_sum.dart';
import 'package:kinkorn/customer/waiting_approve.dart';
import 'package:kinkorn/template/curve_app_bar.dart';
import 'package:kinkorn/template/bottom_bar.dart';
import 'package:intl/intl.dart';
import 'package:kinkorn/customer/order_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kinkorn/customer/notification_cus.dart';


class OrderStatusCustomer extends StatefulWidget {
  const OrderStatusCustomer({super.key});

  @override
  State<OrderStatusCustomer> createState() => _OrderStatusCustomerState();
}

class _OrderStatusCustomerState extends State<OrderStatusCustomer> {
  DateTime _fromDate = DateTime.now();
  DateTime _tillDate = DateTime.now();

/*
  // Noti
  final NotificationCus _notificationCus = NotificationCus();
  Set<String> _notifiedOrderIds = {};
  */

  @override
  void initState() {
    super.initState();
    _listenToOrderChanges();
  }

  void _listenToOrderChanges() {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    if (userID == null) return;

    FirebaseFirestore.instance
      .collection('users')
      .doc(userID)
      .collection('orders')
      .snapshots()
      .listen((snapshot) {
        for (var change in snapshot.docChanges) {
          if (change.type == DocumentChangeType.modified) {
            final data = change.doc.data();
            final orderStatus = data?['orderStatus'];
            final orderId = change.doc.id;

            final key = '$orderId|$orderStatus';
            /*
            if (!_notifiedOrderIds.contains(key)) {
              _notificationCus.showNotification('สถานะออเดอร์อัปเดต', 'Your order is now : $orderStatus');
              _notifiedOrderIds.add(key);
            }
            print('🔁 Order: $orderId | ➜ New: $orderStatus');*/
          }
        }
      });
  }

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
  final userId = FirebaseAuth.instance.currentUser?.uid;
  final startDate = DateTime(_fromDate.year, _fromDate.month, _fromDate.day);
  final endDate = DateTime(_tillDate.year, _tillDate.month, _tillDate.day + 1);

  return StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('orders')
      .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
      .where('createdAt', isLessThan: Timestamp.fromDate(endDate))
      .orderBy('createdAt', descending: true)
      .snapshots(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return const Center(child: Text("เกิดข้อผิดพลาดในการโหลดออเดอร์"));
    }

    final ordersSnapshot = snapshot.data;
    if (ordersSnapshot == null || ordersSnapshot.docs.isEmpty) {
      return const Center(
        child: Text(
          "ไม่พบออเดอร์ในช่วงเวลาที่เลือก",
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      );
    }


  /*
  return FutureBuilder<QuerySnapshot>(
    future: FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('orders')
        .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('createdAt', isLessThan: Timestamp.fromDate(endDate))
        .orderBy('createdAt', descending: true)
        .get(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (snapshot.hasError) {
        return const Center(child: Text("เกิดข้อผิดพลาดในการโหลดออเดอร์"));
      }

      final ordersSnapshot = snapshot.data;
      if (ordersSnapshot == null || ordersSnapshot.docs.isEmpty) {
        return const Center(
          child: Text(
            "ไม่พบออเดอร์ในช่วงเวลาที่เลือก",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        );
      }*/

      /*
      //no orders
      if (ordersSnapshot == null || ordersSnapshot.docs.isEmpty) {
        return const Center(
          child: Text(
            "ยังไม่มีออเดอร์ในขณะนี้",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        );
      }*/

      //have orders
      return Column(
        children: ordersSnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final orderStatus = data['orderStatus'] ?? '';
          final createdAt = (data['createdAt'] as Timestamp?)?.toDate();
          final formattedTime = createdAt != null
              ? DateFormat("MMM dd, HH:mm").format(createdAt)
              : '';
          final menuList = List<Map<String, dynamic>>.from(data['orders'] ?? []);
            final List<Map<String, dynamic>> menuItems = menuList.map((item) {
              final addons = (item['addons'] as List<dynamic>?)?.map((addon) {
                return {
                  'name': addon['name'] ?? '',
                  'quantity': addon['quantity'] ?? 0,
                  'price': addon['price'] ?? 0,
                };
              }).toList() ?? [];

              return {
                'name': item['name'] ?? '',
                'quantity': item['quantity'] ?? 1,
                'addons': addons,
              };
            }).toList();


          final restaurantId = menuList.isNotEmpty ? menuList[0]['restaurantId'] ?? '' : '';

          Color statusColor = Colors.grey;
          if (orderStatus == "Waiting for restaurant approval") {
            statusColor = const Color.fromARGB(255, 94, 35, 93);
          }
            else if (orderStatus == "Waiting for payment") {
            statusColor = const Color.fromARGB(255, 32, 56, 118);
          } else if (orderStatus == "Waiting for payment confirmation") {
            statusColor = const Color(0xFFFDDC5C);
          } else if (orderStatus == "Preparing food") {
            statusColor = Color.fromARGB(255, 132, 132, 132);
          } else if (orderStatus == "Completed") {
            statusColor = Colors.green;
          } else if (orderStatus == "Canceled") {
            statusColor = Colors.black;
          }

          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('restaurants')
                .doc(restaurantId)
                .get(),
            builder: (context, restaurantSnapshot) {
              String restaurantName = "ไม่พบชื่อร้านอาหาร";
              if (restaurantSnapshot.hasData && restaurantSnapshot.data!.exists) {
                restaurantName = restaurantSnapshot.data!.get('restaurantName') ?? 'ไม่พบชื่อร้านอาหาร';
              }

              return GestureDetector(
                onTap: () {
                  // Navigate based on order status
                  if (orderStatus == "Waiting for restaurant approval") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WaitingApprove(
                          orderId: doc.id,
                          userId: FirebaseAuth.instance.currentUser!.uid,
                        ),
                      ),
                    );
                  } else if (orderStatus == "Waiting for payment") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderSummary(
                          orderId: doc.id,
                          restaurantId: restaurantId,
                        ),
                      ),
                    );
                  }                 
                  else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailPage(
                          orderId: doc.id,
                          userId: FirebaseAuth.instance.currentUser!.uid,
                        ),
                      ),
                    );
                  }
                },
                child: _buildOrderCard(
                  orderId: doc.id,
                  timeAgo: "",
                  restaurantName: restaurantName,
                  menuItems: menuItems,
                  statusText: orderStatus,
                  statusColor: statusColor,
                  timeorder: formattedTime,
                ),
              );
            },
          );
        }).toList(),
      );
    },
  );
}



  Widget _buildOrderCard({
  required String orderId,
  required String timeAgo,
  required String restaurantName,
  required List<Map<String, dynamic>> menuItems,
  required String statusText,
  required Color statusColor,
  required String timeorder,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFB71C1C),
      borderRadius: BorderRadius.circular(15),
      boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 5)],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ซ้าย: รายการ
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                restaurantName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Order summary",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              ...menuItems.expand((item) {
  final List<Map<String, dynamic>> addons = List<Map<String, dynamic>>.from(item['addons'] ?? []);
  
  return [
    Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          margin: const EdgeInsets.only(right: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '${item['quantity']}x',
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: Text(
            item['name'],
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
          ...addons.map((addon) => Padding(
            padding: const EdgeInsets.only(left: 30, bottom: 2),
            child: Row(
               children: [
                const Text('• ', style: TextStyle(color: Colors.white, fontSize: 12)),
                Text(
                  addon['name'],
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                const SizedBox(width: 8),
                Text(
                  "x${addon['quantity']}",
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          )),
        ];
      }).toList(),

                  ],
          ),
        ),
        // ขวา: เวลา + สถานะ
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              timeorder,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 130,
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  statusText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black26,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}




}
