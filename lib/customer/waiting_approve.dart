import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kinkorn/template/curve_app_bar.dart';
import 'package:kinkorn/template/bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kinkorn/customer/order_sum.dart'; // Make sure to import OrderSummary

class WaitingApprove extends StatefulWidget {
  final String orderId;
  final String userId;
  
  const WaitingApprove({
    super.key,
    required this.orderId,
    required this.userId,
  });

  @override
  State<WaitingApprove> createState() => _WaitingApproveState();
}

class _WaitingApproveState extends State<WaitingApprove> {
  StreamSubscription<DocumentSnapshot>? _orderSubscription;
  String restaurantName = "Loading...";
  String getRestaurantId = "";

  @override
  void initState() {
    super.initState();
    _loadRestaurantName();
    _listenToOrderStatus();
  }

  @override
  void dispose() {
    _orderSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadRestaurantName() async {
    try {
      // Get the order document
      DocumentSnapshot orderDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('orders')
          .doc(widget.orderId)
          .get();
          
      if (orderDoc.exists) {
        final orderData = orderDoc.data() as Map<String, dynamic>;
        final menuList = List<Map<String, dynamic>>.from(orderData['orders'] ?? []);
        final restaurantId = menuList.isNotEmpty ? menuList[0]['restaurantId'] ?? '' : '';
        
        if (restaurantId.isNotEmpty) {
          // Get the restaurant document
          DocumentSnapshot restaurantDoc = await FirebaseFirestore.instance
              .collection('restaurants')
              .doc(restaurantId)
              .get();
              
          if (restaurantDoc.exists) {
            setState(() {
              getRestaurantId = restaurantId;
              restaurantName = restaurantDoc.get('restaurantName') ?? 'Restaurant';
            });
          }
        }
      }
    } catch (e) {
      print("Error loading restaurant name: $e");
    }
  }

  void _listenToOrderStatus() {
    _orderSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('orders')
        .doc(widget.orderId)
        .snapshots()
        .listen((docSnapshot) {
          if (docSnapshot.exists) {
            final orderData = docSnapshot.data() as Map<String, dynamic>;
            final orderStatus = orderData['orderStatus'] ?? '';
            
            // Check if status has changed to "Waiting for payment"
            if (orderStatus == "Waiting for payment") {
              // Cancel subscription before navigating
              _orderSubscription?.cancel();
              
              // Navigate to OrderSummary
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderSummary(
                    orderId: widget.orderId,
                    restaurantId: getRestaurantId,
                  ),
                ),
              );
            }
          }
        }, onError: (error) {
          print("Error listening to order status: $error");
        });
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
            color: Colors.yellow[100],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // จัดให้อยู่กึ่งกลางแนวตั้ง
              children: [
                CircularProgressIndicator(), // เพิ่มไอคอนโหลด
                SizedBox(height: 20), // เพิ่มระยะห่าง
                Text("Waiting for",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 0.087 * screenWidth,
                    color: Color(0xFFB71C1C),
                  )
                ),
                Text("restaurant to",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 0.087 * screenWidth,
                    color: Color(0xFFB71C1C),
                  )
                ),
                Text("approve your order",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 0.087 * screenWidth,
                    color: Color(0xFFB71C1C),
                  )
                ),
              ],
            ),
          ),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CurveAppBar(
              title: "",
            ),
          ),
          Positioned(
            top: 70,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.chevron_left, size: 40, color: Colors.white),
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          //ชื่อร้านอาหาร
          Positioned(
            top: 0.09 * screenHeight,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                restaurantName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 0.087 * screenWidth,
                  color: Color(0xFFFCF9CA),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}