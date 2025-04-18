import 'package:flutter/material.dart';
import 'package:kinkorn/customer/choose_menu.dart';
import 'package:kinkorn/Screen/register_res.dart';
import 'package:kinkorn/customer/choose_canteen.dart';
import 'package:kinkorn/customer/summary_payment.dart';
import 'package:kinkorn/template/curve_app_bar.dart';
import 'package:kinkorn/template/bottom_bar.dart';



class ChooseRestaurantScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFFCF9CA),
      body: Stack(
        children: [

          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CurveAppBar(
              title: "",
            ),
          ),


          // Choose Restaurant....
          Positioned(
            left: screenWidth * 0.07,
            top: screenHeight * 0.09,
            child: Text(
              "Choose Restaurant....",
              style: TextStyle(
                fontFamily: ' GeistFont',
                fontWeight: FontWeight.w700,
                fontSize: screenWidth * 0.08,
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
          // Rectangle 28
          Positioned(
            left: screenWidth * 0.08,
            top: screenHeight * 0.32,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ChooseMenuScreen(), // ไปยังหน้าจอ ChooseMenuScreen
                  ),
                );
              },
              child: Container(
                width: screenWidth * 0.82,
                height: screenHeight * 0.16,
                decoration: BoxDecoration(
                  color: Color(0xFFAF1F1F),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    // Image
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
                            fontFamily: ' GeistFont',
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            color: Color(0xFFAF1F1F),
                                ),
                              ),
                            ),
                      ),
                    // Text Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "ครัวสุขใจ - อาหารนานาชาติ",
                            style: TextStyle(
                              fontFamily: 'GeistFont',
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth * 0.05,
                              color: Color(0xFFFCF9CA),
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Color(0xFF35AF1F),
                              borderRadius: BorderRadius.circular(21),
                            ),
                            child: Text(
                              "open to order",
                              style: TextStyle(
                                fontFamily: 'GeistFont',
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth * 0.03,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Location : SC1/JC canteen",
                            style: TextStyle(
                              fontFamily: ' GeistFont',
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth * 0.03,
                              color: Color(0xFFFCF9CA),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Second Restaurant
          Positioned(
            left: screenWidth * 0.08,
            top: screenHeight * 0.52,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ChooseMenuScreen(), // ไปยังหน้าจอ ChooseMenuScreen
                  ),
                );
              },
              child: Container(
                width: screenWidth * 0.82,
                height: screenHeight * 0.16,
                decoration: BoxDecoration(
                  color: Color(0xFFAF1F1F),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    // Image
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
                            fontFamily: ' GeistFont',
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            color: Color(0xFFAF1F1F),
                                ),
                              ),
                            ),
                      ),
                    // Text Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "ร้านครัวอร่อย",
                            style: TextStyle(
                              fontFamily: ' GeistFont',
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth * 0.06,
                              color: Color(0xFFFCF9CA),
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Color(0xFF35AF1F),
                              borderRadius: BorderRadius.circular(21),
                            ),
                            child: Text(
                              "open to order",
                              style: TextStyle(
                                fontFamily: ' GeistFont',
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth * 0.03,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Location : SC1/JC canteen",
                            style: TextStyle(
                              fontFamily: ' GeistFont',
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth * 0.03,
                              color: Color(0xFFFCF9CA),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
             
             BottomBar(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
          ),


        ],
      ),
    );
  }
}
