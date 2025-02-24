import 'package:flutter/material.dart';
import 'package:kinkorn/template/restaurant_bottom_nav.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // ใช้ format วันที่

class SalesReport extends StatefulWidget {
  @override
  _SalesReportState createState() => _SalesReportState();
}

class _SalesReportState extends State<SalesReport> {
  DateTime? startDate; // วันที่เริ่มต้น
  DateTime? endDate; // วันที่สิ้นสุด
  Map<String, String> salesData = { // ตัวอย่างข้อมูลยอดขายตามวันที่
    "2025-02-23": "ยอดขาย: 10,000 บาท",
    "2025-02-24": "ยอดขาย: 15,500 บาท",
    "2025-02-25": "ยอดขาย: 7,200 บาท",
  };

  // ฟังก์ชันเลือกวันที่
  Future<void> _selectDate(BuildContext context, bool isStart) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
          if (endDate != null && startDate!.isAfter(endDate!)) {
            endDate = null; // รีเซ็ตวันที่สิ้นสุดถ้าน้อยกว่าวันที่เริ่ม
          }
        } else {
          if (startDate != null && picked.isBefore(startDate!)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("วันที่สิ้นสุดต้องมากกว่าหรือเท่ากับวันที่เริ่มต้น")),
            );
          } else {
            endDate = picked;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedStartDate = startDate != null
        ? DateFormat('yyyy-MM-dd').format(startDate!)
        : "Start Date";

    String formattedEndDate = endDate != null
        ? DateFormat('yyyy-MM-dd').format(endDate!)
        : "Last Date";

    // ค้นหายอดขายตามช่วงวันที่
    List<String> selectedSales = [];
    if (startDate != null && endDate != null) {
      DateTime current = startDate!;
      while (current.isBefore(endDate!.add(Duration(days: 1)))) {
        String key = DateFormat('yyyy-MM-dd').format(current);
        if (salesData.containsKey(key)) {
          selectedSales.add("$key : ${salesData[key]}");
        }
        current = current.add(Duration(days: 1));
      }
    }

    return Scaffold(
      //appBar: AppBar(title: Text("SALES REPORT")),
      backgroundColor: Color(0xFFAF1F1F),
      body: Stack(
        children: [
          // พื้นหลัง Title
          Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            color: Color(0xFFFCF9CA),
          ),

          // SALES REPORT
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 30),
              child: Text(
                "SALES REPORT",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.087,
                  color: Color(0xFFAF1F1F),
                ),
              ),
            ),
          ),

          //title
          Padding(
            padding: EdgeInsets.only(top: 110),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.center, // จัดข้อความแรกตรงกลาง
                          child: Text(
                            "Sales Report for",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              color: Color(0xFFFCF9CA), //AF1F1F
                            ),
                          ),
                        ),

                        Align(
                          alignment: Alignment.center, // จัดข้อความแรกตรงกลาง
                          child: Text(
                            "ร้าน ครัวสุขใจ - อาหารนานาชาติ",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              color: Color(0xFFFCF9CA), //AF1F1F
                            ),
                          ),
                        ),

                        // เลือกวันที่
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Since ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFCF9CA))),
                                  SizedBox(width: 5),
                                  ElevatedButton(
                                    onPressed: () => _selectDate(context, true),
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(120, 30), //กว้าง สูง
                                      backgroundColor: Color(0xFFECECEC),
                                      foregroundColor: Colors.black,
                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0), // ขนาดของปุ่ม
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      elevation: 5, // เพิ่มเงาให้ปุ่ม
                                    ),
                                    child: Text(formattedStartDate,
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                                  ),
                                  SizedBox(width: 10),
                                  Text("Till ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFCF9CA))),
                                  SizedBox(width: 5),
                                  ElevatedButton(
                                    onPressed: () => _selectDate(context, false),
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(120, 30), //กว้าง สูง
                                      backgroundColor: Color(0xFFECECEC),
                                      foregroundColor: Colors.black,
                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0), // ขนาดของปุ่ม
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      elevation: 5, // เพิ่มเงาให้ปุ่ม
                                    ),
                                    child: Text(formattedEndDate,
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),

                        Align(
                          alignment: Alignment.center, // จัดข้อความแรกตรงกลาง
                          child: Text(
                            "Total Sales",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              color: Color(0xFFFFFFFF), //AF1F1F
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center, // จัดข้อความแรกตรงกลาง
                          child: Text(
                            "0.00 Baht",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              color: Color(0xFFFFFFFF), //AF1F1F
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        // แสดงยอดขายของช่วงวันที่ที่เลือก
                        Container(
                          padding: EdgeInsets.all(15),
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.5,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: selectedSales.isNotEmpty
                                ? Column(
                                    children: selectedSales.map((sale) => Text(sale)).toList(),
                                  )
                                : Text("No orders within the date you selected.",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFAF1F1F)),
                                textAlign: TextAlign.center,),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]
      ),
    bottomNavigationBar: const CustomBottomNav(),
    );
  }
}