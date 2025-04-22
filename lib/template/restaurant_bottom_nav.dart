import 'package:flutter/material.dart';
import 'package:kinkorn/customer/choose_canteen.dart';
import 'package:kinkorn/restaurant/sales_report.dart';
import 'package:kinkorn/restaurant/more_res.dart';
import 'package:kinkorn/restaurant/homepage.dart';
import 'package:kinkorn/restaurant/order_status.dart';

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});

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
          buildClickableNavItem(context, Icons.home, "home", () {
            navigateWithSlide(context, RestaurantDashboard());
            //Navigator.push(context, MaterialPageRoute(builder: (context) => RestaurantDashboard()));
          }),
          buildClickableNavItem(context, Icons.notifications, "status", () {
            navigateWithSlide(context, OrderStatusRestaurant());
            //Navigator.push(context, MaterialPageRoute(builder: (context) => OrderStatusRestaurant()));
          }),
          buildClickableNavItem(context, Icons.bar_chart, "sale report", () {
            navigateWithSlide(context, SalesReport());
            //Navigator.push(context, MaterialPageRoute(builder: (context) => SalesReport()));
          }),
          buildClickableNavItem(context, Icons.menu, "more", () {
            navigateWithSlide(context, MoreRes());
            //Navigator.push(context, MaterialPageRoute(builder: (context) => MoreRes()));
          }),
          buildClickableNavItem(context, Icons.person_2, "customer", () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChooseCanteen()));
          }),
        ],
      ),
    );
  }

  Widget buildClickableNavItem(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFFAF1F1F), size: 28),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFFAF1F1F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
