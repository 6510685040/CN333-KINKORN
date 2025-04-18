import 'package:flutter/material.dart';
import 'package:kinkorn/customer/choose_canteen.dart';
import 'package:kinkorn/restaurant/sales_report.dart';
import 'package:kinkorn/restaurant/more_res.dart';
import 'package:kinkorn/restaurant/homepage.dart';

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});

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
          buildClickableNavItem(context, Icons.home, "home", () {
            
          }),
          buildClickableNavItem(context, Icons.notifications, "status", () {
          
          }),
          buildClickableNavItem(context, Icons.bar_chart, "sale report", () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SalesReport()));
          }),
          buildClickableNavItem(context, Icons.menu, "more", () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MoreRes()));
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
