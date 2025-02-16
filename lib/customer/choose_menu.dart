import 'package:flutter/material.dart';
import 'package:kinkorn/customer/add_on.dart'; 

class ChooseMenuScreen extends StatelessWidget {
  const ChooseMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Background
        Container(
          width: screenWidth,
          height: screenHeight,
          color: Color(0xFFFCF9CA), // #FCF9CA
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


        Positioned(
            left: screenWidth * 0.07,
            top: screenHeight * 0.09,
            child: Text(
              "ครัวสุขใจ - อาหารนานาชาติ",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: screenWidth * 0.08,
                color: Color(0xFFFCF9CA),
              ),
            ),
          ),
        
        // Search Box (Rectangle 30)
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
        
        // Item Container (Rectangle 30, Rectangle 31, Rectangle 32)
        buildItem(screenWidth, screenHeight, 25, 323, 'im3', 'ข้าวกะเพราหมูสับ', 45),
        buildItem(screenWidth, screenHeight, 113, 323, 'im1', 'ข้าวผัดไข่', 45),
        buildItem(screenWidth, screenHeight, 220, 323, 'im4', 'ข้าวหมูกระเทียม', 55),

        // ปุ่ม Add ที่จะไปหน้าจอ AddOnScreen
        Positioned(
          left: screenWidth * 0.75,
          top: screenHeight * 0.75,
          child: GestureDetector(
            onTap: () {
              // นำไปที่ AddOnScreen เมื่อกดปุ่ม Add
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddOn()),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                'Add',
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
      ],
    );
  }

  Widget buildItem(double screenWidth, double screenHeight, double left, double top, String imageUrl, String name, double price) {
    return Positioned(
      left: left,
      top: top,
      child: Column(
        children: [
          Container(
            width: screenWidth * 0.38,
            height: screenHeight * 0.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              image: DecorationImage(
                image: AssetImage('assets/$imageUrl'), // เปลี่ยนตาม path ของรูป
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
            name,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.04,
              color: Color(0xFFFCF9CA), // #FCF9CA
            ),
          ),
          SizedBox(height: 4),
          Text(
            '฿$price',
            style: TextStyle(
              fontFamily: 'IBM Plex Sans Thai',
              fontWeight: FontWeight.w600,
              fontSize: screenWidth * 0.04,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
    
  }
}
