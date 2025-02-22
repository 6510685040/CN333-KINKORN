import 'package:flutter/material.dart';
import 'package:kinkorn/customer/add_on.dart';
import 'package:kinkorn/template/restaurant_bottom_nav.dart';

class AddPayment extends StatelessWidget {
  const AddPayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFAF1F1F), //AF1F1F
      body: Stack(
        children: [
          //พื้นหลัง Title
          Container( 
            width: MediaQuery.of(context).size.width, //กว้างเท่าหน้าจอ
            height: 100,
            color: Color(0xFFFCF9CA),
          ), //FCF9CA

          //Add Your Payment
          Align(
            alignment: Alignment.topCenter,
            child: Padding(padding: EdgeInsets.only(top: 30),
              child: Text(
                "Add Your Payment",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.087,
                  color: Color(0xFFAF1F1F), //AF1F1F
                ),
              ),
            ),
          ),

          //List of Your Bank Accounts
          Padding(padding: EdgeInsets.only(top: 140),
            child: Align(
              alignment: Alignment.topCenter,
                child: Container( 
                  width: MediaQuery.of(context).size.width * 0.9, //กว้าง 90%
                  height: 160,
                  decoration: BoxDecoration(
                    color: Color(0xFFFCF9CA), //FCF9CA
                    borderRadius: BorderRadius.circular(20), // มุมโค้ง 20px
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // ข้อความเริ่มจากซ้าย (ยกเว้นอันแรก)
                        children: [
                          Align(
                            alignment: Alignment.center, // จัดข้อความแรกตรงกลาง
                            child: Text(
                              "List of Your Bank Accounts",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Color(0xFFAF1F1F), //AF1F1F
                              ),
                            ),
                          ),
                          SizedBox(height: 5), // เว้นระยะห่าง
                          // Bank list
                          Padding(padding: EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "1. Account Name : ครัวสุขใจ",
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFFAF1F1F), //AF1F1F
                                  ),
                                ),
                                Text(
                                  "    Bank : KBANK        Number : 123-4-56789-0",
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFFAF1F1F), //AF1F1F
                                  ),
                                ),
                                Text(
                                  "2. Account Name : ครัวสุขใจ",
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFFAF1F1F), //AF1F1F
                                  ),
                                ),
                                Text(
                                  "    Bank : SCB              Number : 123-4-55555-0",
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFFAF1F1F), //AF1F1F
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
            ),
          ),

          //Add Payment Method
          Padding(padding: EdgeInsets.only(top: 340),
            child: Align(
              alignment: Alignment.topCenter,
                child: Container( 
                  width: MediaQuery.of(context).size.width * 0.9, //กว้าง 90%
                  height: 400,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF), //FCF9CA
                    borderRadius: BorderRadius.circular(20), // มุมโค้ง 20px
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.center, // จัดข้อความตรงกลาง
                            child: Text(
                              "Add Payment Method",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Color(0xFFAF1F1F), //AF1F1F
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          // Accoount Name Input
                          Text(
                            "Account Name",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFFAF1F1F), //AF1F1F
                            ),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 40,
                            child: Align(
                              alignment: Alignment.center, // จัดให้อยู่ตรงกลาง
                              child: TextField(
                                textAlign: TextAlign.center, 
                                decoration: InputDecoration(
                                  labelText: "Enter Your Account Name",
                                  labelStyle: TextStyle(fontSize: 14),
                                  hintText: "Enter Your Account Name",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(color: Color(0xFFD9D9D9), width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Color(0xFFECECEC), //ECECEC
                                  floatingLabelAlignment: FloatingLabelAlignment.center,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          // Bank Name Dropdown
                          Text(
                            "Bank Name",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFFAF1F1F), //AF1F1F
                            ),
                          ),
                          
                        ],
                      ),
                    ),
                  ),
                ),
            ),
          ),
        ],
      ),
      
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
}