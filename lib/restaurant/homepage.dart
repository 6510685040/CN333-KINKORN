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

  @override
  void initState() {
    super.initState();
    fetchRestaurantName();
    checkApprovalStatus();
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

  @override
  Widget build(BuildContext context) {
    String title = 'Welcome $restaurantName !';

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
                  const Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB71C1C),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatusCard('New order', '0', onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => NewOrder()));
                      }),
                      _buildStatusCard('Preparing order', '0', onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PreparingOrderRestaurant()));
                      }),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatusCard('Completed', '0', onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CompletedOrderRestaurant()));
                      }),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildManagementButton(
                        icon: Icons.restaurant_menu,
                        label: 'Manage your\nrestuarant',
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RestaurantManagementPage()));
                        },
                      ),
                      _buildManagementButton(
                        icon: Icons.bar_chart,
                        label: 'Sales report',
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SalesReport()));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const CustomBottomNav(),
        ],
      ),
    );
  }

  Widget _buildStatusCard(String title, String count, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
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
            const Text(
              'Click here',
              style: TextStyle(
                color: Color(0xFFB71C1C),
                fontSize: 12,
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
          borderRadius: BorderRadius.circular(25),
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
            ),
          ],
        ),
      ),
    );
  }
}
