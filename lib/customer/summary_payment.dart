import 'package:flutter/material.dart';

class SummaryPayment extends StatelessWidget {
  const SummaryPayment({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: Text('Summary Payment')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Payment Summary',
              style: TextStyle(
                fontSize: screenWidth * 0.08,
                fontWeight: FontWeight.bold,
                color: Color(0xFFAF1F1F),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Item: ข้าวกะเพราหมูสับ\nPrice: ฿45',
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                color: Color(0xFFAF1F1F),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Here you can handle the payment process or navigate further
              },
              child: Text('Proceed to Payment'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFFAF1F1F),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
