import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kinkorn/Screen/pendingApproval.dart';
import 'package:kinkorn/restaurant/completed_order.dart';
import 'package:kinkorn/restaurant/preparing_order.dart';
import 'package:kinkorn/restaurant/restaurant_management.dart';
import 'package:kinkorn/restaurant/sales_report.dart';
import 'package:kinkorn/template/curve_app_bar.dart';
import 'package:kinkorn/template/restaurant_bottom_nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kinkorn/restaurant/neworder.dart';

class RestaurantDashboard extends StatefulWidget {
  const RestaurantDashboard({Key? key}) : super(key: key);

  @override
  State<RestaurantDashboard> createState() => _RestaurantDashboardState();
}

class _RestaurantDashboardState extends State<RestaurantDashboard> {
  String restaurantName = 'ร้านใหม่';
  int newOrderCount = 0;
  int preparingOrderCount = 0;
  int completedOrderCount = 0;

  StreamSubscription<QuerySnapshot>? _ordersSubscription;

  @override
  void initState() {
    super.initState();
    fetchRestaurantName();
    checkApprovalStatus();
    listenToOrderChanges();
  }

  @override
  void dispose() {
    _ordersSubscription?.cancel();
    super.dispose();
  }

  Future<void> fetchRestaurantName() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('restaurants')
        .doc(uid)
        .get();

    if (snapshot.exists && snapshot.data() != null) {
      setState(() {
        restaurantName = snapshot['restaurantName'] ?? 'ร้านใหม่';
      });
    }
  }

  Future<void> checkApprovalStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('restaurants').doc(user.uid).get();
      if (!doc.exists || !(doc['isApproved'] ?? false)) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PendingApprovalScreen()),
          );
        }
      }
    }
  }

  void listenToOrderChanges() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final ordersRef = FirebaseFirestore.instance
        .collection('restaurants')
        .doc(uid)
        .collection('orders');

    _ordersSubscription = ordersRef.snapshots().listen((snapshot) {
      int newCount = 0;
      int preparingCount = 0;
      int completedCount = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final status = data['orderStatus'] ?? '';

        // DEBUG PRINT
        print('Order ID: ${doc.id}, status: $status');

        if (status == "Waiting for restaurant approval" ||
            status == "Waiting for payment" ||
            status == "Waiting for payment confirmation") {
          newCount++;
        } else if (status == "Preparing food") {
          preparingCount++;
        } else if (status == "Completed") {
          completedCount++;
        }
      }

      setState(() {
        newOrderCount = newCount;
        preparingOrderCount = preparingCount;
        completedOrderCount = completedCount;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = '${'welcome_res'.tr()} $restaurantName !';

    return Scaffold(
      appBar: CurveAppBar(title: title),
      backgroundColor: const Color(0xFFFFF8E1),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      'over_view'.tr(),
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFB71C1C),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatusCard('new_order'.tr(), '$newOrderCount', onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => NewOrder()));
                      }),
                      _buildStatusCard('status_preparing_food'.tr(), '$preparingOrderCount', onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PreparingOrderRestaurant()));
                      }),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatusCard('status_completed'.tr(), '$completedOrderCount', onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CompletedOrderRestaurant()));
                      }),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: MediaQuery.of(context).size.width * 0.2,
                        child: _buildManagementButton(
                          icon: Icons.restaurant_menu,
                          label: 'manage_res'.tr(),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => RestaurantManagementPage()));
                          },
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: MediaQuery.of(context).size.width * 0.2,
                        child: _buildManagementButton(
                          icon: Icons.bar_chart,
                          label: 'sales_report'.tr(),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SalesReport()));
                          },
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
          const CustomBottomNav(initialIndex: 0),
        ],
      ),
    );
  }

  Widget _buildStatusCard(String title, String count, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.42,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Color(0xFFFDDC5C),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFB71C1C),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              count,
              style: const TextStyle(
                color: Color(0xFFB71C1C),
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'click_here'.tr(),
              style: TextStyle(
                color: Color(0xFFB71C1C),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFB71C1C),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 22, height: 44),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
