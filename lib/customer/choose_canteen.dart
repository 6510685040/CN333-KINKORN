import 'package:flutter/material.dart';
import 'package:kinkorn/Screen/register_res.dart';
import 'package:kinkorn/customer/choose_restaurant.dart';
import 'package:kinkorn/customer/summary_payment.dart';

class ChooseCanteen extends StatelessWidget {
  const ChooseCanteen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // พื้นหลังสีเหลือง
          Container(
            width: screenWidth,
            height: screenHeight,
            color: Color(0xFFFCF9CA),
          ),

          // Ellipse 1
          Positioned(
            left: -0.12 * screenWidth,
            top: -0.15 * screenHeight,
            child: Container(
              width: 1.24 * screenWidth,
              height: 0.37 * screenHeight,
              decoration: BoxDecoration(
                color: Color(0xFFAF1F1F),
                borderRadius: BorderRadius.circular(300),
              ),
            ),
          ),

          // Where to eat?
          Positioned(
            left: 0.07 * screenWidth,
            top: 0.09 * screenHeight,
            child: Text(
              "Where to eat?",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 0.087 * screenWidth,
                color: Color(0xFFFCF9CA),
              ),
            ),
          ),
          Positioned(
          left: 36,
          top: 210,
          child: Container(
            width: 340,
            height: 32,
            decoration: BoxDecoration(
              color: Color(0xFFFDFDFD), // #FFFDFD
              borderRadius: BorderRadius.circular(110),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  offset: Offset(0, 4),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ),

          // JC Canteen Box
          Positioned(
            left: 0.08 * screenWidth,
            top: 0.32 * screenHeight,
            child: canteenBox(
              context,
              canteenName: "JC Canteen",
              location:
                  "near location : Faculty of Engineering, Faculty of Journalism and Mass Communication",
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            ),
          ),

          // SC Canteen Box
          Positioned(
            left: 0.08 * screenWidth,
            top: 0.53 * screenHeight,
            child: canteenBox(
              context,
              canteenName: "SC Canteen",
              location: "near location : SC1, SC2, SC3 Building",
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            ),
          ),

          // Bottom Bar
          Positioned(
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
                        MaterialPageRoute(
                            builder: (context) => ChooseCanteen()),
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
                        MaterialPageRoute(
                            builder: (context) => SummaryPayment()),
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
                    onTap: () {},
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
          ),
        ],
      ),
    );
  }

  // Widget สำหรับกล่องของโรงอาหาร (Canteen Box)
  Widget canteenBox(BuildContext context,
      {required String canteenName,
      required String location,
      required double screenWidth,
      required double screenHeight}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChooseRestaurantScreen(),
          ),
        );
      },
      child: Container(
        width: 0.82 * screenWidth,
        height: 0.16 * screenHeight,
        decoration: BoxDecoration(
          color: Color(0xFFAF1F1F),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // Icon หรือรูปในกล่อง
            Container(
              width: 0.27 * screenWidth,
              height: 0.13 * screenHeight,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  "PIC",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: Color(0xFFAF1F1F),
                  ),
                ),
              ),
            ),
            // ข้อความในกล่อง
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  canteenName,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    color: Color(0xFFFCF9CA),
                  ),
                ),
                SizedBox(height: 5),
                SizedBox(
                  width: 0.45 * screenWidth,
                  child: Text(
                    location,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Bottom Bar Item Widget
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
