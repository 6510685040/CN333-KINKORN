import 'package:flutter/material.dart';
import 'package:kinkorn/template/curve_app_bar.dart';
import 'package:kinkorn/template/bottom_bar.dart';


class SummaryPayment extends StatelessWidget {
  const SummaryPayment({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // ใช้ CurveAppBar
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CurveAppBar(
              title: "Payment Summary",
            ),
          ),

          // เนื้อหาหลักของหน้า
          Positioned(
            top: 250, // เลื่อนลงมาให้พ้น CurveAppBar
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  Text(
                    'Item: ข้าวกะเพราหมูสับ\nPrice: ฿45',
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      color: Color(0xFFAF1F1F),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      // จัดการการชำระเงินหรือนำทางต่อไป
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFFAF1F1F),
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text('Proceed to Payment'),
                  ),
                ],
              ),
            ),
          ),
          
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
