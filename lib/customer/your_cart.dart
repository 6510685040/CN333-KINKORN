import 'package:flutter/material.dart';
import 'package:kinkorn/customer/waiting_approve.dart';
import 'package:kinkorn/template/curve_app_bar.dart';
import 'package:kinkorn/template/bottom_bar.dart';
import 'package:kinkorn/provider/cartprovider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class YourCart extends StatelessWidget {
  const YourCart({super.key});

  @override
  _YourCartState createState() => _YourCartState();

  
}

class _YourCartState extends State<YourCart> {
  DateTime? selectedTime; // Variable to store the selected time
  final TextEditingController specialNoteController = TextEditingController(); // Special note text controller

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final List<Map<String, dynamic>> orders = [
      {'name': 'ข้าวกะเพราหมูสับ', 'quantity': 1, 'price': 55.00},
      {'name': 'ข้าวผัดไข่', 'quantity': 1, 'price': 45.00},
    ];

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight,
            color: Colors.yellow[100],
          ),

          // Move "Your Cart" to the CurveAppBar
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CurveAppBar(
              title: "Your Cart",  // Set "Your Cart" as the title in the app bar
            ),
          ),

          //สรุปรายการเมนูที่จะสั่ง
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // จัดให้อยู่ชิดซ้าย
              children: [
                SizedBox(
                    height:
                        0.3 * screenHeight), // เพิ่มช่องว่างด้านบนให้เลื่อนลงมา

                // รายการอาหาร
                ...orders.map((order) {
                  final double totalPrice = order['quantity'] * order['price'];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${order['quantity']}x ${order['name']}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '฿${totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 18),
                            ),
                            IconButton(
                              onPressed: () {
                                cartProvider.removeFromCart(order); // Remove item from cart
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),

                SizedBox(
                    height: 10), // Spacer เพื่อให้ Total กับปุ่มไม่ติดกันเกินไป

                // Total
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0), // เว้นขอบซ้าย-ขวา
                  child: Container(
                    width: double
                        .infinity, // กว้างเต็มพื้นที่ที่เหลือหลังจากเว้นขอบ
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Color(0xFFB71C1C), // สีแดง
                      borderRadius:
                          BorderRadius.circular(8.0), // มุมโค้งนิดหน่อย
                    ),
                    child: Text(
                      'Total : ฿${orders.fold(0.0, (sum, order) => sum + (order['quantity'] * order['price'])).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),

                SizedBox(height: 20), // ระยะห่างจาก Total

                // Pickup time selection
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Pickup Time:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _selectTime,
                        child: Text(
                          selectedTime == null
                              ? 'Pick a Time'
                              : 'Picked Time: ${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')}',
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20), // Special note field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: specialNoteController,
                    decoration: InputDecoration(
                      labelText: 'Special Note (optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                SizedBox(height: 20), // ระยะห่างจาก Special Note

                // ปุ่ม Proceed to Payment
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0), // เว้นขอบซ้าย-ขวา 16px
                  child: SizedBox(
                    width: double
                        .infinity, // ทำให้ปุ่มกว้างเต็มจอ (เว้นจาก Padding)
                    child: ElevatedButton(
                      //ลิงก์ไปหน้าอื่น
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  WaitingApprove()), // ไปหน้า Waiting
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFF35AF1F),
                        padding: EdgeInsets.symmetric(
                            vertical: 15), // ความสูงของปุ่ม
                        textStyle: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: Text('Order now'),
                    ),
                  ),
                ),
              ],
            ),
          ),

          //footer bar
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
