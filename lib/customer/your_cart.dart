import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:kinkorn/customer/waiting_approve.dart';
import 'package:kinkorn/template/curve_app_bar.dart';
import 'package:kinkorn/template/bottom_bar.dart';
import 'package:kinkorn/provider/cartprovider.dart';
import 'package:easy_localization/easy_localization.dart';

class YourCart extends StatefulWidget {
  const YourCart({super.key});

  @override
  _YourCartState createState() => _YourCartState();
}

class _YourCartState extends State<YourCart> {
  DateTime selectedTime = DateTime.now();
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
                child: const Text('done').tr(), 
              )
            ],
          ),
        );
      },
    );
  }

  double calculateTotalPrice(List<Map<String, dynamic>> orders) {
    double total = 0;
    for (var order in orders) {
      final int menuQuantity = order['quantity'] ?? 1;
      final double menuPrice = (order['price'] ?? 0).toDouble();
      final List<dynamic> addons = order['addons'] ?? [];

      double menuTotal = menuQuantity * menuPrice;
      double addonsTotal = 0;
      for (var addon in addons) {
        final int addonQuantity = addon['quantity'] ?? 0;
        final double addonPrice = (addon['price'] ?? 0).toDouble();
        addonsTotal += addonQuantity * addonPrice;
      }
      total += menuTotal + addonsTotal;
    }
    return total;
  }

  Future<void> _placeOrder(BuildContext context, CartProvider cartProvider) async {
    final customerId = FirebaseAuth.instance.currentUser?.uid;
    final orders = cartProvider.cartItems;
    final totalAmount = calculateTotalPrice(orders);

    if (customerId == null || orders.isEmpty) return;

    try {
      final restaurantId = orders[0]['restaurantId'];
      for (var item in orders) {
        if (item['restaurantId'] != restaurantId) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('only_one_restaurant').tr()), 
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
        SnackBar(content: Text('error_placing_order').tr(args: [e.toString()])), 
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
          Positioned(
            top: 0, left: 0, right: 0,
            child: CurveAppBar(title: 'your_cart'.tr()), // ✅ แบบนี้สวยสุด
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.23),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...orders.map((order) {
                    final int menuQuantity = order['quantity'] ?? 1;
                    final double menuPrice = (order['price'] ?? 0).toDouble();
                    final List<dynamic> addons = order['addons'] ?? [];
                    final double menuTotalPrice = menuQuantity * menuPrice;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${menuQuantity}x ${order['name']}',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),
                              Row(
                                children: [
                                  Text('฿${menuTotalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18)),
                                  IconButton(
                                    onPressed: () => cartProvider.removeFromCart(order),
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (addons.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 20, top: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: addons.map<Widget>((addon) {
                                  final String addonName = addon['name'] ?? '';
                                  final int addonQuantity = addon['quantity'] ?? 0;
                                  final double addonPrice = (addon['price'] ?? 0).toDouble();
                                  final double addonTotal = addonPrice * addonQuantity;

                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '• ${addonQuantity}x $addonName',
                                          style: const TextStyle(fontSize: 16, color: Colors.black54),
                                        ),
                                      ),
                                      Text(
                                        '฿${addonTotal.toStringAsFixed(2)}',
                                        style: const TextStyle(fontSize: 16, color: Colors.black54),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB71C1C),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${'total'.tr()} : ฿${calculateTotalPrice(orders).toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('select_pickup_time'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _showCupertinoTimePicker,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFFB71C1C),
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text(
                            '${'picked_time'.tr()} : ${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('special_note'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: specialNoteController,
                          style: const TextStyle(color: Color(0xFFB71C1C), fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'type_special_note'.tr(),
                            labelStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          ),
                        ),
                      ],
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
                          backgroundColor: const Color(0xFF35AF1F),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text('order_now'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
              initialIndex: 1,
            ),
          ),
        ],
      ),
    );
  }
}
