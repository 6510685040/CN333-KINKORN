import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kinkorn/Screen/register_res.dart';
import 'package:kinkorn/customer/choose_canteen.dart';
import 'package:kinkorn/customer/more_cus.dart';
import 'package:kinkorn/customer/order_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kinkorn/restaurant/homepage.dart';
import 'package:kinkorn/customer/your_cart.dart';


class BottomBar extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final int initialIndex;

  const BottomBar({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    this.initialIndex = 0,
  });

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }
  
  void navigateWithSlide(BuildContext context, Widget page, int index) {
  final String? currentRouteName = ModalRoute.of(context)?.settings.name;
  final String targetRouteName = page.runtimeType.toString();

  
  if (currentRouteName == targetRouteName) {
    return; 
  }

  setState(() {
    currentIndex = index;
  });

  Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      settings: RouteSettings(name: targetRouteName),
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
          index: 0,
          icon: Icons.home,
          label: 'home'.tr(), // ✅
          onTap: () {
            navigateWithSlide(context, ChooseCanteen(), 0);
          },
        ),
        bottomBarItem(
          context,
          index: 1,
          icon: Icons.shopping_cart,
          label: 'your_cart'.tr(), // ✅
          onTap: () {
            navigateWithSlide(context, YourCart(), 1);
          },
        ),
        bottomBarItem(
          context,
          index: 2,
          icon: Icons.notifications,
          label: 'status'.tr(), // ✅
          onTap: () {
            navigateWithSlide(context, OrderStatusCustomer(), 2);
          },
        ),
        bottomBarItem(
          context,
          index: 3,
          icon: Icons.more_horiz,
          label: 'more'.tr(), // ✅
          onTap: () {
            navigateWithSlide(context, MoreCus(), 3);
          },
        ),
        bottomBarItem(
          context,
          index: 4,
          icon: Icons.person,
          label: 'restaurant'.tr(), // ✅
          onTap: () => RestaurantCheck(4),
        ),

          ],
        ),
      ),
    );
  }

  // เช็กว่าเคยลงทะเบียนร้านยัง
  Future<void> RestaurantCheck(int index) async {
    setState(() {
      currentIndex = index;
    });
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
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => const RestaurantDashboard()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RegisterRes()),
        );
      }
    }
  }


  Widget bottomBarItem(
  BuildContext context, {
    required int index,
    required IconData icon,
    required String label,
    required VoidCallback onTap
  }) {
    final bool isActive = currentIndex == index;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon, 
            color: isActive ? Colors.yellow : Colors.white, 
          ),
          Text(
            label.tr(), // ✅ แปลตรงนี้
            style: TextStyle(
              color: isActive ? Colors.yellow : Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
