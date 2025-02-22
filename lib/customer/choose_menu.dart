import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:kinkorn/customer/add_on.dart';  // อย่าลืมนำเข้า AddOn screen
import 'package:kinkorn/template/curve_app_bar.dart';
import 'package:kinkorn/template/bottom_bar.dart';

class ChooseMenuScreen extends StatelessWidget {
  const ChooseMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

          // App Bar (Curve)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CurveAppBar(
              title: "",
            ),
          ),

          // Title (ครัวสุขใจ)
          Positioned(
            left: screenWidth * 0.07,
            top: screenHeight * 0.09,
            child: Align(
              alignment: Alignment.topLeft,
              child: AutoSizeText(
                "ครัวสุขใจ",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: screenWidth * 0.08, // Size relative to screen width
                  color: Color(0xFFFCF9CA),
                ),
                maxLines: 1,
                minFontSize: 12,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // Rectangle 30 (Red box with food name)
          Positioned(
            left: 25,
            top: 353,
            child: Container(
              width: 165,
              height: 168,
              decoration: BoxDecoration(
                color: Color(0xFFAF1F1F), // #AF1F1F
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    offset: Offset(0, 4),
                    blurRadius: 4,
                  ),
                ],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Food name
                  AutoSizeText(
                    "ข้าวกะเพราหมูสับ",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      height: 20 / 15, // line-height ratio
                      letterSpacing: 0.1,
                      color: Color(0xFFFCF9CA), // #FCF9CA
                    ),
                    maxLines: 1,
                    minFontSize: 12,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Price below food name
                  AutoSizeText(
                    "฿45",
                    style: TextStyle(
                      fontFamily: 'IBM Plex Sans Thai',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      height: 20 / 15,
                      letterSpacing: 0.1,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    minFontSize: 12,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Add button below price
                  Container(
                    margin: EdgeInsets.only(top: 12), // Adjust spacing
                    width: 103,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Color(0xFFFDDC5C), // #FDDC5C (Yellow)
                      borderRadius: BorderRadius.circular(64),
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          // ไปหน้า AddOnScreen เมื่อกดปุ่ม "add"
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddOn()), // ไปยังหน้าจอ AddOn
                          );
                        },
                        child: AutoSizeText(
                          "add",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            letterSpacing: 0.1,
                            color: Color(0xFFAF1F1F), // #AF1F1F (Dark red)
                          ),
                          maxLines: 1,
                          minFontSize: 12,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Frame 11 (with circle and image)
          Positioned(
            left: 45,
            top: 260,
            child: Container(
              width: 150,
              height: 123,
              child: Stack(
                children: [
                  // Ellipse 9
                  Positioned(
                    left: 4,
                    top: 14,
                    child: Container(
                      width: 114,
                      height: 109,
                      decoration: BoxDecoration(
                        color: Color(0xFFD9D9D9), // #D9D9D9
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // im3 (Image)
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 150,
                      height: 123,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/im3.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Bar
          Positioned(
            bottom: 0,
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
