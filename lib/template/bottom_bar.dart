import 'package:flutter/material.dart';
import 'package:kinkorn/Screen/register_res.dart';
import 'package:kinkorn/customer/choose_canteen.dart';
import 'package:kinkorn/customer/more_cus.dart';
import 'package:kinkorn/customer/order_status.dart';
import 'package:kinkorn/customer/waiting_approve.dart';
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
  void navigateWithSlide(BuildContext context, Widget page) {
  // Check if the current widget and the target widget are of the same type
  if (ModalRoute.of(context)?.settings.name == page.runtimeType.toString()) {
    return; // Already on the page, do nothing
  }

  Navigator.push(
    context,
    PageRouteBuilder(
      settings: RouteSettings(name: page.runtimeType.toString()),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    ),
  );
}

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
                navigateWithSlide(context, ChooseCanteen());
              },
            ),
            bottomBarItem(
              context,
              icon: Icons.shopping_cart,
              label: "Your Cart",
              onTap: () {
                navigateWithSlide(context, YourCart());

              },
            ),
            bottomBarItem(
              context,
              icon: Icons.notifications,
              label: "Status",
              onTap: () {
                navigateWithSlide(context, OrderStatusCustomer());
              },
            ),
            bottomBarItem(
              context,
              icon: Icons.more_horiz,
              label: "More",
              onTap: () {
                navigateWithSlide(context, MoreCus());
                },
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
