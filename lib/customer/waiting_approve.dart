import 'package:flutter/material.dart';
import 'package:kinkorn/template/curve_app_bar.dart';
import 'package:kinkorn/template/bottom_bar.dart';

class WaitingApprove extends StatelessWidget {
  const WaitingApprove({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight,
            color: Colors.yellow[100],
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // จัดให้อยู่กึ่งกลางแนวตั้ง
              children: [
                CircularProgressIndicator(), // เพิ่มไอคอนโหลด
                SizedBox(height: 20), // เพิ่มระยะห่าง
                Text("Waiting for",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 0.087 * screenWidth,
                      color: Color(0xFFB71C1C),
                    )),
                Text("restaurant to",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 0.087 * screenWidth,
                      color: Color(0xFFB71C1C),
                    )),
                Text("approve your order",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 0.087 * screenWidth,
                      color: Color(0xFFB71C1C),
                    )),
              ],
            ),
          ),

          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CurveAppBar(
              //navดึงมาจากtemplate
              title: "",
            ),
          ),

          //ชื่อร้านอาหาร
          Positioned(
            top: 0.09 * screenHeight,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "ครัวสุขใจ โรงอาหาร JC",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 0.087 * screenWidth,
                  color: Color(0xFFFCF9CA),
                ),
              ),
            ),
          ),

          //footer bar
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
