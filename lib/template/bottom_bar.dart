import 'package:flutter/material.dart';
import 'package:kinkorn/Screen/register_res.dart';
import 'package:kinkorn/customer/choose_canteen.dart';
import 'package:kinkorn/customer/summary_payment.dart';
import 'package:kinkorn/customer/more_cus.dart';

class BottomBar extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;

  const BottomBar({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0.92 * screenHeight,
      child: Container(
        width: screenWidth,
        height: 0.08 * screenHeight,
        color: Color(0xFFAF1F1F),
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
                  MaterialPageRoute(builder: (context) => ChooseCanteen()),
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
                  MaterialPageRoute(builder: (context) => SummaryPayment()),
                );
              },
            ),
            bottomBarItem(
              context,
              icon: Icons.notifications,
              label: "Status",
              onTap: () {},
            ),
            bottomBarItem(
              context,
              icon: Icons.more_horiz,
              label: "More",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MoreCus()),
                );
              },
            ),
            bottomBarItem(
              context,
              icon: Icons.person,
              label: "Restaurant",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterRes()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Bottom Bar Item Widget
  Widget bottomBarItem(BuildContext context,
      {required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          Text(
            label,
            style: TextStyle(
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
