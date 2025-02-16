import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kinkorn/customer/choose_canteen.dart';

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
                top: 40, // Adjusted logo position
                left : 20,
                child: SvgPicture.asset(
                  'assets/images/logo.svg',
                  width: 100,
                  height: 100,
                ),
              ),
              Positioned(
                left: screenWidth * 0.1, // Use percentage-based positioning for responsiveness
                top: screenHeight * 0.2, // Adjusted position based on screen height
                child: Container(
                  width: screenWidth * 0.8, // Responsive width
                  height: screenHeight * 0.6, // Responsive height
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
                top: screenHeight * 0.25, // Adjusted title position
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
                left: screenWidth * 0.35, // Adjusted logo position
                top: screenHeight * 0.29,
                child: Container(
                  width: screenWidth * 0.3, // Responsive width
                  height: screenHeight * 0.15, // Responsive height
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              Positioned(
                left: screenWidth * 0.17, // Adjusted position for restaurant name label
                top: screenHeight * 0.45,
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
                left: screenWidth * 0.16, // Adjusted input field position
                top: screenHeight * 0.47,
                child: Container(
                  width: screenWidth * 0.7, // Responsive width
                  height: screenHeight * 0.06, // Responsive height
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
              Positioned(
                left: screenWidth * 0.17, // Adjusted position for category label
                top: screenHeight * 0.56,
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
                left: screenWidth * 0.16, // Adjusted position for category input field
                top: screenHeight * 0.58,
                child: Container(
                  width: screenWidth * 0.7, // Responsive width
                  height: screenHeight * 0.06, // Responsive height
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
                left: screenWidth * 0.31, // Adjusted position for the Next button
                top: screenHeight * 0.83, // Adjusted button position to fit screen height
                child: GestureDetector(
                  onTap: () {
                    // เปลี่ยนหน้ากลับไปยังหน้า Choose Canteen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ChooseCanteen()),
                    );
                  },
                  child: Container(
                    width: screenWidth * 0.37, // Responsive width
                    height: screenHeight * 0.05, // Responsive height
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
