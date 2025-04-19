import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:kinkorn/customer/add_on.dart';  // อย่าลืมนำเข้า AddOn screen
import 'package:kinkorn/template/curve_app_bar.dart';
import 'package:kinkorn/template/bottom_bar.dart';

class ChooseMenuScreen extends StatelessWidget {
  ChooseMenuScreen({super.key});

  final List<Map<String, dynamic>> menuItems = [
    {
      "name": "ข้าวกะเพราหมูสับ",
      "price": 45,
      "image": "assets/im3.png",
    },
    {
      "name": "ข้าวผัดหมู",
      "price": 50,
      "image": "assets/im3.png",
    },
    {
      "name": "ข้าวมันไก่",
      "price": 55,
      "image": "assets/im3.png",
    },
  ];

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
            color: const Color(0xFFFCF9CA),
          ),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CurveAppBar(
              title: "",
            ),
          ),

          Positioned(
            left: screenWidth * 0.07,
            top: screenHeight * 0.09,
            child: Row(
              children: [
                const AutoSizeText(
                  "ครัวสุขใจ โรงอาหารJC",
                  style: TextStyle(
                    //fontFamily: 'GeistFont',
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: Color(0xFFFCF9CA),
                  ),
                  maxLines: 1,
                  minFontSize: 12,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF35AF1F),
                    borderRadius: BorderRadius.circular(21),
                  ),
                  child: Text(
                    "open to order",
                    style: TextStyle(
                      //fontFamily: 'GeistFont',
                      fontWeight: FontWeight.w600,
                      fontSize: screenWidth * 0.03,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: screenHeight * 0.2,
            left: 0,
            right: 0,
            bottom: 60,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final menuItem = menuItems[index];
                  return buildMenuItem(context, menuItem);
                },
              ),
            ),
          ),

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

  Widget buildMenuItem(BuildContext context, Map<String, dynamic> menuItem) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddOn()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFAF1F1F),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              offset: const Offset(0, 4),
              blurRadius: 4,
            ),
          ],
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.image_not_supported, 
                  size: 40, 
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            AutoSizeText(
              menuItem["name"],
              style: const TextStyle(
                //fontFamily: 'GeistFont',
                fontWeight: FontWeight.w800,
                fontSize: 15,
                color: Color(0xFFFCF9CA),
              ),
              maxLines: 1,
              minFontSize: 12,
              overflow: TextOverflow.ellipsis,
            ),
            AutoSizeText(
              "฿${menuItem["price"]}",
              style: const TextStyle(
                //fontFamily: 'GeistFont',
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.white,
              ),
              maxLines: 1,
              minFontSize: 12,
              overflow: TextOverflow.ellipsis,
            ),
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 103,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFFDDC5C),
                borderRadius: BorderRadius.circular(64),
              ),
              child: const Center(
                child: AutoSizeText(
                  "add",
                  style: TextStyle(
                    //fontFamily: 'GeistFont',
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Color(0xFFAF1F1F),
                  ),
                  maxLines: 1,
                  minFontSize: 12,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
