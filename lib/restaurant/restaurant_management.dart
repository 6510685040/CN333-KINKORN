import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kinkorn/restaurant/edit_payment.dart';
import 'package:kinkorn/restaurant/edit_restaurant_info.dart';
import 'package:kinkorn/restaurant/homepage.dart';
import 'package:kinkorn/restaurant/menu_list.dart';
import 'package:kinkorn/restaurant/payment_list.dart';
import 'package:kinkorn/template/restaurant_bottom_nav.dart';

class RestaurantManagementPage extends StatefulWidget {
  const RestaurantManagementPage({Key? key}) : super(key: key);

  @override
  State<RestaurantManagementPage> createState() => _RestaurantManagementPageState();
}

class _RestaurantManagementPageState extends State<RestaurantManagementPage> {
  String _openStatus = 'close';

  @override
  void initState() {
    super.initState();
    _loadOpenStatus();
  }

  Future<void> _loadOpenStatus() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final doc = await FirebaseFirestore.instance.collection('restaurants').doc(userId).get();
    setState(() {
      _openStatus = doc.data()?['openStatus'] ?? 'close';
    });
  }

  Future<void> _toggleOpenStatus() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final newStatus = _openStatus == 'open' ? 'close' : 'open';

    await FirebaseFirestore.instance.collection('restaurants').doc(userId).update({
      'openStatus': newStatus,
    });

    setState(() {
      _openStatus = newStatus;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Status changed to $newStatus')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            width: double.infinity,
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left, size: 40, color: Color(0xFFB71C1C)),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RestaurantDashboard()),
                    );
                  },
                ),
                const SizedBox(width: 0),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Text(
                      "MANAGE RESTAURANT",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.07,
                        color: Color(0xFFAF1F1F),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ),

          // Main content
          Expanded(
            child: Container(
              width: double.infinity,
              color: const Color(0xFFB71C1C),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
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
                            MaterialPageRoute(builder: (context) => EditPaymentPage()),
                          );
                        },
                      ),
                      _buildManagementButton(
                        icon: Icons.store,
                        label: 'Edit Restaurant',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditRestaurantPage()),
                          );
                        },
                      ),
                      _buildManagementButton(
                        icon: Icons.power_settings_new,
                        label: _openStatus.toUpperCase(),
                        onTap: _toggleOpenStatus,
                        iconColor: _openStatus == 'open' ? Colors.green : Colors.grey,
                        textColor: _openStatus == 'open' ? Colors.green : Colors.grey,
                        backgroundColor: _openStatus == 'open' ? Colors.white : const Color(0xFFFFF8E1),
                      ),


                    ],
                  ),
                ],
              ),
            ),
          ),
          //const CustomBottomNav(),
        ],
      ),
    );
  }


  Widget _buildManagementButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color iconColor = const Color(0xFFB71C1C),
    Color textColor = const Color(0xFFB71C1C),
    Color backgroundColor = const Color(0xFFFFF8E1),
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
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
              color: iconColor,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
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
