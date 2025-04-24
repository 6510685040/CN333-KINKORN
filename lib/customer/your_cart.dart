/*import 'dart:convert';
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
  DateTime? selectedTime;
  final TextEditingController specialNoteController = TextEditingController();

  @override
  void dispose() {
    specialNoteController.dispose();
    super.dispose();
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
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

  Future<void> _placeOrder(BuildContext context, CartProvider cartProvider) async {
  final customerId = FirebaseAuth.instance.currentUser?.uid;
  final orders = cartProvider.cartItems;
  final totalAmount = cartProvider.totalPrice;

  if (customerId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Missing customer ID')),
    );
    return;
  }

  if (selectedTime == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please select a pickup time')),
    );
    return;
  }

  try {
    final restaurantId = orders[0]['restaurantId'];
    for (var item in orders) {
      if (item['restaurantId'] != restaurantId) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You can only order from one restaurant')),
        );
        return;
      }
    }

    final userOrderRef = FirebaseFirestore.instance
        .collection('users')
        .doc(customerId)
        .collection('orders')
        .doc(); 

    final combinedOrderData = {
      'customerId': customerId,
      'orders': orders,
      'totalAmount': totalAmount,
      'orderStatus': 'Waiting for restaurant approval',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'pickupTime': selectedTime ?? DateTime.now(),
      'slipUrl': '',
      'specialNote': specialNoteController.text.isEmpty ? '' : specialNoteController.text,
    };


    final restaurantOrderRef = FirebaseFirestore.instance
        .collection('restaurants')
        .doc(restaurantId)
        .collection('orders')
        .doc(userOrderRef.id); 

    final resOrderData = {
      'customerId': customerId,
      'items': orders,
      'totalAmount': totalAmount,
      'orderStatus': 'Waiting for restaurant approval',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'pickupTime': selectedTime ?? DateTime.now(),
      'slipUrl': '',
      'specialNote': specialNoteController.text.isEmpty ? null : specialNoteController.text,
    };

  
    final mainOrderRef = FirebaseFirestore.instance.collection('orders').doc(userOrderRef.id);

    final mainOrderData = {
      'customerId': customerId,
      'restaurantId': restaurantId,
      'orders': orders,
      'totalAmount': totalAmount,
      'orderStatus': 'Waiting for restaurant approval',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'pickupTime': selectedTime ?? DateTime.now(),
      'slipUrl': '',
      'specialNote': specialNoteController.text.isEmpty ? '' : specialNoteController.text,
    };


    await userOrderRef.set(combinedOrderData);
    await restaurantOrderRef.set(resOrderData);
    await mainOrderRef.set(mainOrderData); 
 
    cartProvider.clearCart();
    specialNoteController.clear();
    selectedTime = null;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => WaitingApprove(
        userId: customerId,
        orderId: userOrderRef.id,
      )),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error placing order: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final orders = cartProvider.cartItems;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(width: screenWidth, height: screenHeight, color: Colors.yellow[100]),
          const Positioned(top: 0, left: 0, right: 0, child: CurveAppBar(title: "Your Cart")),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.23),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...orders.map((order) {
                    final totalPrice = order['quantity'] * order['price'];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${order['quantity']}x ${order['name']}',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              Text('฿${totalPrice.toStringAsFixed(2)}',
                                  style: TextStyle(fontSize: 18)),
                              IconButton(
                                onPressed: () {
                                  cartProvider.removeFromCart(order);
                                },
                                icon: Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),

                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFFB71C1C),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Total : ฿${cartProvider.totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Select Pickup Time:',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _selectTime,
                          child: Text(selectedTime == null
                              ? 'Pick a Time'
                              : 'Picked Time: ${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')}'),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: specialNoteController,
                      decoration: InputDecoration(
                        labelText: 'Special Note (optional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () => _placeOrder(context, cartProvider),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Color(0xFF35AF1F),
                            padding: EdgeInsets.symmetric(vertical: 15),
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
}*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:kinkorn/customer/waiting_approve.dart';
import 'package:kinkorn/template/curve_app_bar.dart';
import 'package:kinkorn/template/bottom_bar.dart';
import 'package:kinkorn/provider/cartprovider.dart';

class YourCart extends StatefulWidget {
  const YourCart({super.key});

  @override
  _YourCartState createState() => _YourCartState();
}

class _YourCartState extends State<YourCart> {
  DateTime selectedTime = DateTime.now(); // กำหนดค่า default ไม่ให้เป็น null

  final TextEditingController specialNoteController = TextEditingController();

  @override
  void dispose() {
    specialNoteController.dispose();
    super.dispose();
  }

  void _showCupertinoTimePicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          height: 250,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: selectedTime,
                  use24hFormat: true,
                  onDateTimeChanged: (DateTime newTime) {
                    setState(() {
                      selectedTime = DateTime(
                        selectedTime.year,
                        selectedTime.month,
                        selectedTime.day,
                        newTime.hour,
                        newTime.minute,
                      );
                    });
                  },
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Done'),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _placeOrder(BuildContext context, CartProvider cartProvider) async {
    final customerId = FirebaseAuth.instance.currentUser?.uid;
    final orders = cartProvider.cartItems;
    final totalAmount = cartProvider.totalPrice;

    if (customerId == null || orders.isEmpty) return;

    try {
      final restaurantId = orders[0]['restaurantId'];
      for (var item in orders) {
        if (item['restaurantId'] != restaurantId) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('You can only order from one restaurant')),
          );
          return;
        }
      }

      final userOrderRef = FirebaseFirestore.instance
          .collection('users')
          .doc(customerId)
          .collection('orders')
          .doc();

      final orderData = {
        'customerId': customerId,
        'orders': orders,
        'totalAmount': totalAmount,
        'orderStatus': 'Waiting for restaurant approval',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'pickupTime': selectedTime,
        'slipUrl': '',
        'specialNote': specialNoteController.text,
      };

      await userOrderRef.set(orderData);
      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantId)
          .collection('orders')
          .doc(userOrderRef.id)
          .set(orderData);
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(userOrderRef.id)
          .set(orderData);

      cartProvider.clearCart();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WaitingApprove(
            userId: customerId,
            orderId: userOrderRef.id,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error placing order: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final orders = cartProvider.cartItems;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(width: screenWidth, height: screenHeight, color: Colors.yellow[100]),
          const Positioned(top: 0, left: 0, right: 0, child: CurveAppBar(title: "Your Cart")),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.23),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...orders.map((order) {
                    final totalPrice = order['quantity'] * order['price'];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${order['quantity']}x ${order['name']}',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              Text('฿${totalPrice.toStringAsFixed(2)}',
                                  style: TextStyle(fontSize: 18)),
                              IconButton(
                                onPressed: () {
                                  cartProvider.removeFromCart(order);
                                },
                                icon: Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),

                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFFB71C1C),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Total : ฿${cartProvider.totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select Pickup Time :',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _showCupertinoTimePicker,
                          child: Text(
                            'Picked Time : ${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(fontSize: 16,),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: specialNoteController,
                      decoration: InputDecoration(
                        labelText: 'Special Note (optional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _placeOrder(context, cartProvider),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xFF35AF1F),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text(
                          'Order Now', 
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomBar(
              screenHeight: screenHeight,
              screenWidth: MediaQuery.of(context).size.width,
            ),
          ),
        ],
      ),
    );
  }
}
