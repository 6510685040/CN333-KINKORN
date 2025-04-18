import 'package:flutter/material.dart';
import 'package:kinkorn/Screen/register_res.dart';
import 'package:kinkorn/customer/choose_canteen.dart';
import 'package:kinkorn/customer/more_cus.dart';
import 'package:kinkorn/customer/order_status.dart';
import 'package:kinkorn/customer/summary_payment.dart';
import 'package:kinkorn/customer/more_cus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kinkorn/restaurant/homepage.dart';
import 'package:kinkorn/customer/your_cart.dart';


class BottomBar extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;

  const BottomBar({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0.92 * widget.screenHeight,
      child: Container(
        width: widget.screenWidth,
        height: 0.08 * widget.screenHeight,
        color: const Color(0xFFAF1F1F),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            bottomBarItem(
              context,
              icon: Icons.home,
              label: "Home",
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ChooseCanteen()),
                );
              },
            ),
            bottomBarItem(
              context,
              icon: Icons.shopping_cart,
              label: "Your Cart",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => YourCart()),
                );
              },
            ),
            bottomBarItem(
              context,
              icon: Icons.notifications,
              label: "Status",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OrderStatusCustomer()),
                );
              },
            ),
            bottomBarItem(
              context,
              icon: Icons.more_horiz,
              label: "More",
              onTap: () {Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MoreCus()),
                );},
            ),
            bottomBarItem(
              context,
              icon: Icons.person,
              label: "Restaurant",
              onTap: RestaurantCheck,
            ),
          ],
        ),
      ),
    );
  }

  // เช็กว่าเคยลงทะเบียนร้านยัง
  Future<void> RestaurantCheck() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final data = doc.data() as Map<String, dynamic>? ?? {};
    final roles = data['roles'] ?? [];
    final restaurantName = data['restaurantName'] ?? '';

    if (roles.contains('res') && restaurantName.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RestaurantDashboard()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RegisterRes()),
      );
    }
  }
}


  Widget bottomBarItem(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
