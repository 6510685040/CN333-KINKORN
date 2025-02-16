import 'package:flutter/material.dart';

class RegisterRes extends StatelessWidget {
  const RegisterRes({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          color: Color(0xFFAF1F1F),
          child: Stack(
            children: [
              Positioned(
                left: 15 * screenWidth / 412,
                top: 28 * screenHeight / 917,
                child: Image.asset(
                  'assets/image.png',
                  width: 379 * screenWidth / 412,
                  height: 101 * screenHeight / 917,
                ),
              ),
              Positioned(
                left: 43 * screenWidth / 412,
                top: 177 * screenHeight / 917,
                child: Container(
                  width: 326 * screenWidth / 412,
                  height: 689 * screenHeight / 917,
                  decoration: BoxDecoration(
                    color: Color(0xFFFCF9CA),
                    borderRadius: BorderRadius.circular(32),
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
              Positioned(
                left: 43 * screenWidth / 412,
                top: 177 * screenHeight / 917,
                child: Container(
                  width: 326 * screenWidth / 412,
                  height: 689 * screenHeight / 917,
                  decoration: BoxDecoration(
                    color: Color(0xFFFCF9CA),
                    borderRadius: BorderRadius.circular(32),
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
              Positioned(
                left: 0,
                right: 0,
                top: 225 * screenHeight / 917,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Restaurant Register',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      height: 20 / 16,
                      color: Color(0xFFAF1F1F),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 147 * screenWidth / 412,
                top: 269 * screenHeight / 917,
                child: Container(
                  width: 120 * screenWidth / 412,
                  height: 116 * screenHeight / 917,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Positioned(
                left: 70 * screenWidth / 412,
                top: 413 * screenHeight / 917,
                child: Text(
                  'Restaurant Name',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    height: 20 / 16,
                    color: Color(0xFFAF1F1F),
                  ),
                ),
              ),
              Positioned(
                left: 67 * screenWidth / 412,
                top: 439 * screenHeight / 917,
                child: Container(
                  width: 282 * screenWidth / 412,
                  height: 45 * screenHeight / 917,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Color(0xFFD9D9D9)),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Center(
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: 'Enter your restaurant name',
                          hintStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFAF1F1F).withOpacity(0.8),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),  // เพิ่มเว้นระยะห่างจาก Restaurant Name ไป Category
              Positioned(
                left: 70 * screenWidth / 412,
                top: 510 * screenHeight / 917,
                child: Text(
                  'Category',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    height: 20 / 16,
                    color: Color(0xFFAF1F1F),
                  ),
                ),
              ),
              Positioned(
                left: 67 * screenWidth / 412,
                top: 536 * screenHeight / 917,
                child: Container(
                  width: 282 * screenWidth / 412,
                  height: 45 * screenHeight / 917,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Color(0xFFD9D9D9)),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Center(
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: 'Choose your restaurant category',
                          hintStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFAF1F1F).withOpacity(0.8),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 130 * screenWidth / 412,
                top: 761 * screenHeight / 917,
                child: GestureDetector(
                  onTap: () {
                    // เพิ่ม onTap() ให้ปุ่ม Next ทำงานได้
                    print("Next button tapped");
                  },
                  child: Container(
                    width: 152 * screenWidth / 412,
                    height: 42 * screenHeight / 917,
                    decoration: BoxDecoration(
                      color: Color(0xFFAF1F1F),
                      borderRadius: BorderRadius.circular(64),
                    ),
                    child: Center(
                      child: Text(
                        'Next',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 