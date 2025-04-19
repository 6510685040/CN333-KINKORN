import 'package:flutter/material.dart';
import 'package:kinkorn/template/restaurant_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // format วันที่

class SalesReport extends StatefulWidget {
  @override
  _SalesReportState createState() => _SalesReportState();
}

class _SalesReportState extends State<SalesReport> {
  DateTime? startDate; // วันที่เริ่มต้น
  DateTime? endDate; // วันที่สิ้นสุด
  List<Map<String, String>> selectedSales = [];
  // ค้นหายอดขายตามช่วงวันที่
    void _updateSelectedSales() {
      if (startDate == null || endDate == null) return;

      setState(() {
        selectedSales = salesData.entries
            .where((entry) {
              DateTime entryDate = DateTime.parse(entry.key);
              return entryDate.isAfter(startDate!.subtract(Duration(days: 1))) &&
                    entryDate.isBefore(endDate!.add(Duration(days: 1)));
            })
            .expand((entry) => entry.value)
            .toList();
      });
    }

  Map<String, List<Map<String, String>>> salesData = {
    "2025-02-23": [
      {"menu": "ข้าวกะเพราหมูสับ", "quantity": "2", "price": "90.00"},
      {"menu": "ข้าวผัดไข่", "quantity": "1", "price": "45.00"},
    ],
    "2025-02-24": [
      {"menu": "ข้าวมันไก่", "quantity": "3", "price": "150.00"},
    ],
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
        _updateSelectedSales();
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

    return Scaffold(
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
                  //fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.087,
                  color: Color(0xFFAF1F1F),
                ),
              ),
            ),
          ),

          // title
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
                        // title
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Sales Report for",
                            style: TextStyle(
                              //fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              color: Color(0xFFFCF9CA), //AF1F1F
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "ร้าน ครัวสุขใจ - อาหารนานาชาติ",
                            style: TextStyle(
                              //fontFamily: 'Montserrat',
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
                                      minimumSize: Size(120, 30), //กว้าง, สูง
                                      backgroundColor: Color(0xFFECECEC),
                                      foregroundColor: Colors.black,
                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      elevation: 5,
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
                                      minimumSize: Size(120, 30), //กว้าง, สูง
                                      backgroundColor: Color(0xFFECECEC),
                                      foregroundColor: Colors.black,
                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      elevation: 5,
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

                        // Total sales
                        Align(
                          alignment: Alignment.center, // จัดข้อความแรกตรงกลาง
                          child: Text(
                            "Total Sales",
                            style: TextStyle(
                              //fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              color: Color(0xFFFFFFFF), //AF1F1F
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center, // จัดข้อความแรกตรงกลาง
                          child: Text(
                            // แก้เป็นยอดรวม
                            "135.00 Baht",
                            style: TextStyle(
                              //fontFamily: 'Montserrat',
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
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Order Number
                                Center(
                                  child: Text(
                                    "Order number : 1", 
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: 5),

                                // แสดงวันที่เลือก
                                Center(
                                  child: Text(
                                    "23 Feb 2025  12:30",
                                    //"${DateFormat('dd MMM yyyy HH:mm').format(startDate!)}", 
                                    style: TextStyle(fontSize: 16, color: Colors.black54),
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                                // ตารางสินค้า
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    columnSpacing: 20,
                                    dataRowMinHeight: 30,
                                    dataRowMaxHeight: 35,
                                    border: TableBorder(
                                      horizontalInside: BorderSide.none,
                                      verticalInside: BorderSide.none,
                                      top: BorderSide.none, 
                                      bottom: BorderSide.none,
                                      left: BorderSide.none, 
                                      right: BorderSide.none,
                                    ),
                                    columns: [
                                      DataColumn(label: Text('Menu', style: TextStyle(fontWeight: FontWeight.bold))),
                                      DataColumn(label: Center(child: Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold)))),
                                      DataColumn(label: Center(child: Text('Price\n(Baht)', style: TextStyle(fontWeight: FontWeight.bold)))),
                                    ],
                                    rows: [
                                      // แสดงข้อมูลสินค้า
                                      ...salesData["2025-02-23"]!.map((sale) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Text(sale['menu']!)),
                                            DataCell(Center(child: Text(sale['quantity']!))),
                                            DataCell(Center(child: Text(sale['price']!))),
                                          ]);
                                      }).toList(),

                                      // แสดงผลรวม
                                      DataRow(
                                        cells: [
                                          // รวมจำนวน
                                          DataCell(Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
                                          DataCell(Center(child: Text(
                                            salesData["2025-02-23"]!
                                                .map((sale) => int.parse(sale['quantity']!))
                                                .reduce((a, b) => a + b)
                                                .toString(),
                                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                                          ))),
                                          // รวมราคา
                                          DataCell(Center(child: Text(
                                            salesData["2025-02-23"]!
                                                .map((sale) => double.parse(sale['price']!))
                                                .reduce((a, b) => a + b)
                                                .toStringAsFixed(2),
                                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                                          ))),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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