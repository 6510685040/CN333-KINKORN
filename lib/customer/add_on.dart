import 'package:flutter/material.dart';
import 'package:kinkorn/customer/summary_payment.dart';
import 'package:kinkorn/template/curve_app_bar.dart';
import 'package:kinkorn/template/bottom_bar.dart';

class AddOn extends StatefulWidget {
  const AddOn({super.key});

  @override
  _AddOnState createState() => _AddOnState();
}

class _AddOnState extends State<AddOn> {
  int friedEggCount = 0;
  int omeletCount = 0;
  TextEditingController requestController = TextEditingController();

  void incrementFriedEgg() {
    setState(() {
      friedEggCount++;
    });
  }

  void decrementFriedEgg() {
    if (friedEggCount > 0) {
      setState(() {
        friedEggCount--;
      });
    }
  }

  void incrementOmelet() {
    setState(() {
      omeletCount++;
    });
  }

  void decrementOmelet() {
    if (omeletCount > 0) {
      setState(() {
        omeletCount--;
      });
    }
  }

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
            color: Color(0xFFFCF9CA),
          ),

          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CurveAppBar(title: ""),
          ),

          Positioned(
            left: screenWidth * 0.1,
            top: screenHeight * 0.1, // เลื่อนลงมาแค่เล็กน้อย
            child: Column(
              children: [
                Container(
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.2, // ขนาดของรูปเล็กลง
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        offset: Offset(0, 4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: screenWidth * 0.15, // ขนาดไอคอนเล็กลง
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'ข้าวกะเพราหมูสับ',
                  style: TextStyle(
                    //fontFamily: 'GeistFont',
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.06, // ขนาดฟอนต์เล็กลง
                    color: Color(0xFFAF1F1F),
                  ),
                ),
                Text(
                  '฿45',
                  style: TextStyle(
                    //fontFamily: 'GeistFont',
                    fontWeight: FontWeight.w600,
                    fontSize: screenWidth * 0.06, // ขนาดฟอนต์เล็กลง
                    color: Color(0xFFAF1F1F),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.01), // ขยับไปทางซ้าย
                  child: Text(
                    'Add-ons',
                    style: TextStyle(
                      //fontFamily: 'GeistFont',
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.05,
                      color: Color(0xFFAF1F1F),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                AddOnWidget(
                  label: 'ไข่ดาว',
                  count: friedEggCount,
                  onIncrement: incrementFriedEgg,
                  onDecrement: decrementFriedEgg,
                ),
                SizedBox(height: 10),
                AddOnWidget(
                  label: 'ไข่เจียว',
                  count: omeletCount,
                  onIncrement: incrementOmelet,
                  onDecrement: decrementOmelet,
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.01), // ขยับไปทางซ้าย
                  child: Text(
                    'Special Request',
                    style: TextStyle(
                      //fontFamily: 'GeistFont',
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.05,
                      color: Color(0xFFAF1F1F),
                    ),
                  ),
                ),

                SizedBox(height: 10),
            
                Container(
                  width: screenWidth * 0.8, 
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        offset: Offset(0, 4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: requestController,
                    decoration: InputDecoration(
                      hintText: 'Enter your request...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SummaryPayment()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40), // ลด padding
                  decoration: BoxDecoration(
                    color: Color(0xFFAF1F1F),
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
                      //fontFamily: 'GeistFont',
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.045,
                      color: Colors.white,
                    ),
                  ),
                ),
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
}

class AddOnWidget extends StatelessWidget {
  final String label;
  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const AddOnWidget({
    required this.label,
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onDecrement,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFFAF1F1F),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(Icons.remove, color: Colors.white),
          ),
        ),
        SizedBox(width: 15),
        Text(
          '$label x$count',
          style: TextStyle(
            //fontFamily: 'GeistFont',
            fontWeight: FontWeight.w600,
            fontSize: screenWidth * 0.045, // ขนาดฟอนต์เล็กลง
            color: Color(0xFFAF1F1F),
          ),
        ),
        SizedBox(width: 15),
        GestureDetector(
          onTap: onIncrement,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFFAF1F1F),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
