import 'package:flutter/material.dart';
import 'package:kinkorn/customer/order_detail.dart';
import 'package:kinkorn/template/curve_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class OrderSummary extends StatefulWidget {
  final String orderId;
  final String restaurantId;

  const OrderSummary({
    super.key, 
    required this.orderId,
    required this.restaurantId,
  });

  @override
  _OrderSummaryState createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  File? _selectedImage;
  bool _isLoading = true;
  bool _isUploading = false;
  Map<String, dynamic>? _orderData;
  List<Map<String, dynamic>> _orderItems = [];
  List<Map<String, dynamic>> _paymentMethods = [];
  String _restaurantName = "";

  // Helper function to format Firestore timestamp
  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return "N/A";
    
    if (timestamp is Timestamp) {
      final DateTime dateTime = timestamp.toDate();
      return DateFormat('dd MMMM yyyy HH:mm').format(dateTime);
    } else if (timestamp is String) {
      return timestamp;
    } else {
      return "N/A";
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchOrderData();
    _fetchPaymentMethods();
  }

  Future<void> _fetchOrderData() async {
    try {
      final orderDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('orders')
          .doc(widget.orderId)
          .get();

      if (orderDoc.exists) {
        setState(() {
          _orderData = orderDoc.data();
          if (_orderData!['orders'] != null) {
            _orderItems = List<Map<String, dynamic>>.from(_orderData!['orders']);
          }
        });
      }

      // Get restaurant name
      final restaurantDoc = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(widget.restaurantId)
          .get();
      
      if (restaurantDoc.exists) {
        setState(() {
          _restaurantName = restaurantDoc.data()?['name'] ?? "Restaurant";
        });
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching order: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchPaymentMethods() async {
    try {
      final paymentMethodsSnap = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(widget.restaurantId)
          .collection('paymentMethods')
          .get();

      setState(() {
        _paymentMethods = paymentMethodsSnap.docs
            .map((doc) => {
                  ...doc.data(),
                  'id': doc.id,
                })
            .toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching payment methods: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadSlipAndConfirmPayment() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a payment slip first')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Upload image to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('payment_slips')
          .child('${widget.orderId}_${DateTime.now().millisecondsSinceEpoch}.jpg');
      
      await storageRef.putFile(_selectedImage!);
      final downloadUrl = await storageRef.getDownloadURL();

      // Update order status in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('orders')
          .doc(widget.orderId)
          .update({
        'orderStatus': 'Waiting for payment confirmation',
        'slipUrl': downloadUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Navigate to OrderDetailPage
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrderDetailPage(
            orderId: widget.orderId,
            userId: FirebaseAuth.instance.currentUser!.uid,
          ),
        ),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading slip: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
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
            color: Colors.yellow[100],
          ),
          
          CurveAppBar(title: _restaurantName),

          Positioned(
            top: 190,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "Order summary",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 0.087 * screenWidth,
                  color: Color(0xFFB71C1C),
                ),
              ),
            ),
          ),

          Positioned(
            top: 240,
            left: 0,
            right: 0,
            bottom: 0,
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Order items
                        ..._orderItems.map((item) {
                            final double menuTotalPrice = 
                                (item['quantity'] ?? 0) * (item['price'] ?? 0);
                            final List<dynamic> addons = item['addons'] ?? [];

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // เมนูหลัก
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          '${item['quantity']}x ${item['name']}',
                                          style: const TextStyle(
                                              fontSize: 18, fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        '฿${menuTotalPrice.toStringAsFixed(2)}',
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // ➕ Addons ของเมนูนั้นๆ (ถ้ามี)
                                if (addons.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 32),
                                    child: Column(
                                      children: addons.map<Widget>((addon) {
                                        final addonName = addon['name'] ?? '';
                                        final addonQty = addon['quantity'] ?? 0;
                                        final addonPrice = addon['price'] ?? 0;
                                        final addonTotal = addonQty * addonPrice;
                                        
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 2),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const Text('• ', style: TextStyle(fontSize: 14, color: Colors.black54)),
                                                  Text(
                                                    '$addonName x$addonQty',
                                                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                                                  ),
                                                ],
                                              ),
                                          
                                              Text(
                                                '฿${addonTotal.toStringAsFixed(2)}',
                                                style: const TextStyle(fontSize: 14, color: Colors.black54),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                              ],
                            );
                          }).toList(),

                        
                        // Add special note if exists
                        if (_orderData != null && _orderData!['specialNote'] != null && _orderData!['specialNote'].toString().isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Special Note:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(_orderData!['specialNote'].toString()),
                                ],
                              ),
                            ),
                          ),
                        
                        // Pickup time if exists
                        if (_orderData != null && _orderData!['pickupTime'] != null)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.amber[100],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.amber),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pickup Time:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(_formatTimestamp(_orderData!['pickupTime'])),
                                ],
                              ),
                            ),
                          ),
                        
                        SizedBox(height: 10),
                        
                        // Total amount
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            decoration: BoxDecoration(
                              color: Color(0xFFB71C1C),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              'Total : ฿${(_orderData?['totalAmount'] ?? 0).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 20),
                        
                        // Payment Methods Section
                        Center(
                          child: Text(
                            "Payment Methods",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 0.087 * screenWidth,
                              color: Color(0xFFB71C1C),
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 16),
                        
                        // Payment methods list
                        if (_paymentMethods.isEmpty)
                          Center(
                            child: Text(
                              "No payment methods available",
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        else
                          Column(
                            children: _paymentMethods.map((method) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 24.0),
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        method['bankName'] ?? 'Bank',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Text(
                                            'Account Name: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Expanded(child: Text(method['accountName'] ?? '')),
                                        ],
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            'Account Number: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Expanded(child: Text(method['accountNumber'] ?? '')),
                                        ],
                                      ),
                                      SizedBox(height: 16),
                                      if (method['qrImageUrl'] != null)
                                        Center(
                                          child: Image.network(
                                            method['qrImageUrl'],
                                            width: 0.5 * screenWidth,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Center(
                                                child: Icon(
                                                  Icons.broken_image,
                                                  size: 0.3 * screenWidth,
                                                  color: Colors.grey,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        
                        SizedBox(height: 24),
                        
                        // Selected image preview
                        if (_selectedImage != null)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Your Payment Slip",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.file(
                                      _selectedImage!,
                                      width: 0.7 * screenWidth,
                                      height: 300,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        
                        SizedBox(height: 20),
                        
                        // Upload and Confirm buttons
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: _isUploading ? null : _pickImage,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 164, 171, 177),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 15),
                                  foregroundColor: Colors.white,
                                ),
                                child: Text(
                                  _selectedImage == null ? "Upload slip" : "Change slip",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(width: 20),
                              
                              ElevatedButton(
                                onPressed: _isUploading ? null : _uploadSlipAndConfirmPayment,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF35AF1F),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 15),
                                  foregroundColor: Colors.white,
                                ),
                                child: _isUploading
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        "Confirm payment",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}