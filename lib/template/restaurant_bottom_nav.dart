import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kinkorn/customer/choose_canteen.dart';
import 'package:kinkorn/restaurant/sales_report.dart';
import 'package:kinkorn/restaurant/more_res.dart';
import 'package:kinkorn/restaurant/homepage.dart';
import 'package:kinkorn/restaurant/order_status.dart';

class CustomBottomNav extends StatefulWidget {
  final int initialIndex;

  const CustomBottomNav({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  void navigateWithSlide(BuildContext context, Widget page, int index) {
    if (ModalRoute.of(context)?.settings.name == page.runtimeType.toString()) {
      return; // Already on the page, do nothing
    }

    setState(() {
      currentIndex = index;
    });

    Navigator.pushReplacement(
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFFFDDC5C),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildClickableNavItem(context, 0, Icons.home, "home".tr(), () {
            navigateWithSlide(context, RestaurantDashboard(), 0);
          }),
          buildClickableNavItem(context, 1, Icons.notifications, "status".tr(), () {
            navigateWithSlide(context, OrderStatusRestaurant(), 1);
          }),
          buildClickableNavItem(context, 2, Icons.bar_chart, "sales_report".tr(), () {
            navigateWithSlide(context, SalesReport(), 2);
          }),
          buildClickableNavItem(context, 3, Icons.menu, "more".tr(), () {
            navigateWithSlide(context, MoreRes(), 3);
          }),
          buildClickableNavItem(context, 4, Icons.person_2, "customer".tr(), () {
            navigateWithSlide(context, ChooseCanteen(), 4);
          }),
        ],
      ),
    );
  }

  Widget buildClickableNavItem(BuildContext context, int index, IconData icon, String label, VoidCallback onTap) {
    final bool isSelected = index == currentIndex;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.black : const Color(0xFFAF1F1F), 
              size: 28,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.black : const Color(0xFFAF1F1F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
