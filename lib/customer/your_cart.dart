import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kinkorn/customer/waiting_approve.dart';
import 'package:kinkorn/template/curve_app_bar.dart';
import 'package:kinkorn/template/bottom_bar.dart';
import 'package:kinkorn/provider/cartprovider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class YourCart extends StatefulWidget {
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

    final cartProvider = Provider.of<CartProvider>(context);
    final List<Map<String, dynamic>> orders = cartProvider.cartItems;
    final String restaurantId = cartProvider.restaurantId ?? ''; // Assuming you have a way to get the restaurantId
    final String customerId = cartProvider.customerId ?? ''; // Assuming you have a way to get the customerId
    final double totalAmount = orders.fold(0.0, (sum, order) => sum + (order['quantity'] * order['price']));

    // Function to pick the time
    Future<void> _selectTime() async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (picked != null) {
        setState(() {
          selectedTime = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            picked.hour,
            picked.minute,
          );
        });
      }
    }

    // Function to save order to Firestore
    Future<void> _placeOrder() async {
      if (selectedTime == null) {
        // Display a message if the user has not selected a pickup time
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select a pickup time')));
        return;
      }

      try {
        // Prepare the order data
        final orderData = {
          'customerId': customerId,
          'restaurantId': restaurantId,
          'items': orders,
          'totalAmount': totalAmount,
          'orderStatus': 'Waiting for approve',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'pickupTime': selectedTime,
          'slipUrl': '', // You can update this if you have a way to handle payment slips
          'specialNote': specialNoteController.text,
        };

        // Add order to Firestore in both the user's subcollection and restaurant's subcollection
        await FirebaseFirestore.instance.collection('users').doc(customerId).collection('orders').add(orderData);
        await FirebaseFirestore.instance.collection('restaurants').doc(restaurantId).collection('orders').add(orderData);

        // Navigate to the waiting approve screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WaitingApprove(),
          ),
        );
      } catch (e) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error placing order: $e')));
      }
    }
  
  
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
                        0.23 * screenHeight), // ปรับช่องว่างให้เหมาะสมกับ app bar

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
                        Row(
                          children: [
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
                      'Total : ฿${totalAmount.toStringAsFixed(2)}',
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
                      onPressed: _placeOrder, // Call the function to place the order
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFF35AF1F),
                        padding: EdgeInsets.symmetric(
                            vertical: 15), 
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
