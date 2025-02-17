import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFFFFCC4D), // สีเหลืองตามดีไซน์
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
          _buildNavItem(Icons.home, "home"),
          _buildNavItem(Icons.notifications, "status"),
          _buildNavItem(Icons.bar_chart, "sale report"),
          _buildNavItem(Icons.menu, "more"),
          _buildNavItem(Icons.logout, "customer"),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Color(0xFFAF1F1F), size: 28),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFFAF1F1F),
          ),
        ),
      ],
    );
  }
}
