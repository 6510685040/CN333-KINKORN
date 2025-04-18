import 'package:flutter/material.dart';
import 'package:kinkorn/restaurant/restaurant_management.dart';
import 'package:kinkorn/restaurant/sales_report.dart';
import 'package:kinkorn/template/curve_app_bar.dart';
import 'package:kinkorn/template/restaurant_bottom_nav.dart';


class RestaurantDashboard extends StatelessWidget {
  const RestaurantDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CurveAppBar(
        title: 'Welcome ร้านใหม่!',
      ),
      backgroundColor: const Color(0xFFFFF8E1), // Light cream background
      body: Column(
        children: [
          // Overview section
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

                  // Status cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatusCard('New order', '0'),
                      _buildStatusCard('Preparing order', '0'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatusCard('Completed', '0'),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Management buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildManagementButton(
                        icon: Icons.restaurant_menu,
                        label: 'Manage your\nrestuarant',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RestaurantManagementPage(),
                            ),
                          );
                        },
                      ),
                      _buildManagementButton(
                        icon: Icons.bar_chart,
                        label: 'Sales report',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SalesReport(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const CustomBottomNav (),
        ],
      ),
    );
  }

  Widget _buildStatusCard(String title, String count) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.yellow.shade100,
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


class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
