import 'package:flutter/material.dart';
import 'package:kinkorn/customer/summary_payment.dart';
import 'package:kinkorn/template/curve_app_bar.dart';
import 'package:kinkorn/template/bottom_bar.dart';

class AddOn extends StatelessWidget {
  const AddOn({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            width: screenWidth,
            height: screenHeight,
            color: Color(0xFFFCF9CA), // #FCF9CA
          ),

          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CurveAppBar(
              title: "",
            ),
          ),

          // Food item: ข้าวกะเพราหมูสับ (example)
          Positioned(
            left: screenWidth * 0.2,  // Positioning based on screen width
            top: screenHeight * 0.1,  // Positioning based on screen height
            child: Column(
              children: [
                Container(
                  width: screenWidth * 0.6,  // Adjust image width
                  height: screenHeight * 0.2, // Adjust image height
                  decoration: BoxDecoration(
                    color: Colors.white,  // White background when no image
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        offset: Offset(0, 4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'ข้าวกะเพราหมูสับ',  // Example food name
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.08, // Adjust text size
                    color: Color(0xFFAF1F1F),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '฿45',
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans Thai',
                    fontWeight: FontWeight.w600,
                    fontSize: screenWidth * 0.08, // Adjust price size
                    color: Color(0xFFAF1F1F),
                  ),
                ),
              ],
            ),
          ),

          // Add to Cart Button
          Positioned(
            bottom: 100,  // Adjust button position
            left: 0,      // Ensure left is 0 to position it properly
            right: 0,     // Ensure right is 0 to position it properly
            child: Center(  // Center widget to make sure it's in the center horizontally
              child: GestureDetector(
                onTap: () {
                  // เมื่อกดปุ่ม Add to Cart จะนำไปที่หน้าจอ SummaryPayment
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SummaryPayment()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  decoration: BoxDecoration(
                    color: Color(0xFFAF1F1F), // สีปุ่ม
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        offset: Offset(0, 4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    'Add to Cart',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.05,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom bar at the bottom of the screen
          Positioned(
            bottom: 0, // Adjusted to ensure it's at the bottom
            left: 0,
            right: 0,
            child: BottomBar(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
            ),
          ),
          
        ],
      ),
    );
  }
}
