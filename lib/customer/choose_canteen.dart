import 'package:flutter/material.dart';

class ChooseCanteen extends StatelessWidget {
  const ChooseCanteen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen size
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned(
            left:
                -0.12 * screenWidth, // Adjusting position based on screen width
            top: -0.15 *
                screenHeight, // Adjusting position based on screen height
            child: Container(
              width:
                  1.24 * screenWidth, // Adjusting width based on screen width
              height: 0.37 *
                  screenHeight, // Adjusting height based on screen height
              color: Color(0xFFAF1F1F),
            ),
          ),
          // Title "Where to eat?"
          Positioned(
            left:
                0.07 * screenWidth, // Adjusting position based on screen width
            top: 0.09 *
                screenHeight, // Adjusting position based on screen height
            child: Text(
              "Where ?",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize:
                    0.087 * screenWidth, // Font size based on screen width
                color: Color(0xFFFCF9CA),
              ),
            ),
          ),
          // Canteen boxes (JC and SC Canteen)
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
          // Bottom bar with icons
          Positioned(
            left: 0,
            top: 0.92 *
                screenHeight, // Adjusting position based on screen height
            child: Container(
              width: screenWidth,
              height: 0.18 *
                  screenHeight, // Adjusting height based on screen height
              color: Color(0xFFAF1F1F),
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
                    icon: Icon(Icons.person, color: Colors.white),
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

  Widget canteenBox(BuildContext context,
      {required String canteenName,
      required String location,
      required double screenWidth,
      required double screenHeight}) {
    return Container(
      width: 0.82 * screenWidth, // Width based on screen width
      height: 0.16 * screenHeight, // Height based on screen height
      decoration: BoxDecoration(
        color: Color(0xFFAF1F1F),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Positioned(
            left: 0.18 * screenWidth,
            top: 0.13 * screenHeight,
            child: Text(
              canteenName,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize:
                    0.058 * screenWidth, // Font size based on screen width
                color: Color(0xFFFCF9CA),
              ),
            ),
          ),
          Positioned(
            left: 0.18 * screenWidth,
            top: 0.17 * screenHeight,
            child: Text(
              location,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize:
                    0.025 * screenWidth, // Font size based on screen width
                color: Color(0xFFFFFFFF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
