import 'package:flutter/material.dart';
import 'package:kinkorn/restaurant/edit_payment.dart';
import 'package:kinkorn/restaurant/edit_restaurant_info.dart';
import 'package:kinkorn/restaurant/menu_list.dart';
import 'package:kinkorn/restaurant/payment_list.dart';
import 'package:kinkorn/template/restaurant_bottom_nav.dart';

class RestaurantManagementPage extends StatelessWidget {
  const RestaurantManagementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1), // Light cream background
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            width: double.infinity,
            child: const Text(
              'MANAGE\nRESTAURANT',
              style: TextStyle(
                color: Color(0xFFB71C1C),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Main content with red background
          Expanded(
            child: Container(
              width: double.infinity,
              color: const Color(0xFFB71C1C),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Grid of management options
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    children: [
                      _buildManagementButton(
                        icon: Icons.restaurant_menu,
                        label: 'Edit Menu',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MenuPage()),
                          );
                        },
                      ),
                      _buildManagementButton(
                        icon: Icons.payments_outlined,
                        label: 'Edit Payment',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditPaymentPage()),
                          );
                        },
                      ),
                      _buildManagementButton(
                        icon: Icons.store,
                        label: 'Edit Restaurant',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditRestaurantPage()),
                          );
                        },
                      ),
                      _buildManagementButton(
                        icon: Icons.power_settings_new,
                        label: 'OPEN',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    RestaurantManagementPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Bottom navigation bar
        const CustomBottomNav (),
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
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E1),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 80,
                color: const Color(0xFFB71C1C),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFFB71C1C),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected ? const Color(0xFFB71C1C) : Colors.grey,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? const Color(0xFFB71C1C) : Colors.grey,
          ),
        ),
      ],
    );
  }
}
