import 'package:flutter/material.dart';
import 'package:kinkorn/customer/summary_payment.dart';
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

          // Ellipse 1
          Positioned(
            left: -50,
            top: -138,
            child: Container(
              width: screenWidth * 1.25,
              height: screenHeight * 0.375,
              decoration: BoxDecoration(
                color: Color(0xFFAF1F1F), // #AF1F1F
                shape: BoxShape.circle,
              ),
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
                    borderRadius: BorderRadius.circular(30),
                    image: DecorationImage(
                      image: AssetImage('assets/im3'), // Example image
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        offset: Offset(0, 4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'ข้าวกะเพราหมูสับ',  // Example food name
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.08, // Adjust text size
                    color: Color(0xFFFCF9CA),
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
            left: screenWidth * 0.25,
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

          // Menu buttons (home, cart, etc.)
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: screenWidth,
              height: 75,
              color: Color(0xFFAF1F1F), // #AF1F1F
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.home, color: Colors.white),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.shopping_cart, color: Colors.white),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.notifications, color: Colors.white),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.more_horiz, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
