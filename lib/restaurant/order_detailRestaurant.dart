import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kinkorn/template/curve_app_bar.dart';
import 'package:kinkorn/template/bottom_bar.dart';
import 'package:kinkorn/template/restaurant_bottom_nav.dart';

class OrderdetailRestaurant extends StatefulWidget {
  final String customerId;
  final String orderId;

  const OrderdetailRestaurant({
    super.key,
    required this.customerId,
    required this.orderId,
  });

  @override
  State<OrderdetailRestaurant> createState() => _OrderdetailRestaurantState();
}

class _OrderdetailRestaurantState extends State<OrderdetailRestaurant> {
  late Future<Map<String, dynamic>> _orderData;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _orderData = fetchOrderData();
  }

  Future<Map<String, dynamic>> fetchOrderData() async {
    final orderDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.customerId)
        .collection('orders')
        .doc(widget.orderId)
        .get();

    if (!orderDoc.exists) {
      throw Exception('Order not found');
    }

    final orderData = orderDoc.data()!;
    final orders = List<Map<String, dynamic>>.from(orderData['orders'] ?? []);
    final customerId = orderData['customerId'];
    final restaurantId = orders.isNotEmpty ? orders[0]['restaurantId'] ?? '' : '';

    String canteenId = '';
    if (restaurantId.isNotEmpty) {
      final resDoc = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantId)
          .get();
      final resData = resDoc.data();
      if (resData != null) {
        canteenId = resData['canteenId'] ?? '';
      }
    }

    String canteenName = '';
    if (canteenId.isNotEmpty) {
      final canteenDoc = await FirebaseFirestore.instance
          .collection('canteens')
          .doc(canteenId)
          .get();
      canteenName = canteenDoc.data()?['name'] ?? '';
    }

    // โหลดชื่อผู้ใช้
    String customerName = 'Unknown';
    final customerDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(customerId)
        .get();
    if (customerDoc.exists) {
      final userData = customerDoc.data()!;
      customerName =
          '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''} ${userData['mobile'] ?? ''}';
    }

    // โหลดชื่อร้าน
    String restaurantName = '';
    final restaurantDoc = await FirebaseFirestore.instance
        .collection('restaurants')
        .doc(restaurantId)
        .get();
    if (restaurantDoc.exists) {
      restaurantName = restaurantDoc.data()?['restaurantName'] ?? '';
    }

    Timestamp? createdAt = orderData['createdAt'];
    String formattedOrderTime = createdAt != null
        ? formatDateTime(createdAt.toDate())
        : '';

    Timestamp? pickupTime = orderData['pickupTime'];
    String formattedPickupTime = pickupTime != null
        ? formatDateTime(pickupTime.toDate())
        : '';

    return {
      'orderId': widget.orderId,
      'customerName': customerName,
      'restaurantName': restaurantName,
      'canteenName': canteenName,
      'orderTime': formattedOrderTime,
      'pickupTime': formattedPickupTime,
      'menuItems': orders.map((e) {
        final List<Map<String, dynamic>> parsedAddons = [];
        if (e['addons'] != null && e['addons'] is List) {
          for (var addon in e['addons']) {
            if (addon is Map<String, dynamic>) {
              parsedAddons.add({
                'name': addon['name'] ?? '',
                'quantity': addon['quantity'] ?? 0,
                'price': addon['price'] ?? 0,
              });
            }
          }
        }

        return {
          'name': e['name'],
          'quantity': e['quantity'],
          'price': e['price'],
          'total': (e['price'] ?? 0) * (e['quantity'] ?? 0),
          'addons': parsedAddons,
        };
      }).toList(),


      'totalAmount': orderData['totalAmount'].toString(),
      'statusText': orderData['orderStatus'],
      'statusColor': getStatusColor(orderData['orderStatus']),
      'timeAgo': timeAgoFromTimestamp(orderData['createdAt']),
      'slipUrl': orderData['slipUrl'],
      'customerId': customerId,
      'restaurantId': restaurantId,
    };
  }

  String formatDateTime(DateTime dateTime) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String day = twoDigits(dateTime.day);
    String month = twoDigits(dateTime.month);
    String year = dateTime.year.toString();
    String hour = twoDigits(dateTime.hour);
    String minute = twoDigits(dateTime.minute);
    return '$day/$month/$year $hour:$minute';
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'waiting for payment':
        return const Color.fromARGB(255, 32, 56, 118);
      case 'waiting for payment confirmation':
        return const Color(0xFFFDDC5C);
      case 'waiting for order confirmation':
        return const Color(0xFFFDDC5C);
      case 'canceled':
        return Colors.black;
      case 'preparing food':
        return const Color.fromARGB(255, 132, 132, 132);
      case 'completed':
        return const Color.fromARGB(255, 0, 128, 0);
      default:
        return const Color.fromARGB(255, 94, 35, 93);
    }
  }

  String timeAgoFromTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final now = DateTime.now();
    final difference = now.difference(timestamp.toDate());

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) return '${difference.inMinutes} mins ago';
    if (difference.inDays < 1) return '${difference.inHours} hrs ago';
    return '${difference.inDays} days ago';
  }

  Future<void> updateOrderStatus(String newStatus) async {
  if (_isUpdating) return;
  
  setState(() {
    _isUpdating = true;
  });

  try {
    // Get the current order data to extract restaurantId
    final orderSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(widget.customerId)
      .collection('orders')
      .doc(widget.orderId)
      .get();
    
    if (!orderSnapshot.exists) {
      throw Exception('Order not found');
    }
    
    final orderData = orderSnapshot.data()!;
    final orders = List<Map<String, dynamic>>.from(orderData['orders'] ?? []);
    final restaurantId = orders.isNotEmpty ? orders[0]['restaurantId'] ?? '' : '';
    
    if (restaurantId.isEmpty) {
      throw Exception('Restaurant ID not found in order data');
    }
    
    // Update status in user's orders collection
    await FirebaseFirestore.instance
      .collection('users')
      .doc(widget.customerId)
      .collection('orders')
      .doc(widget.orderId)
      .update({
        'orderStatus': newStatus,
      });
    
    // Update status in restaurant's orders collection
    await FirebaseFirestore.instance
      .collection('restaurants')
      .doc(restaurantId)
      .collection('orders')
      .doc(widget.orderId)
      .update({
        'orderStatus': newStatus,
      });

    await FirebaseFirestore.instance
      .collection('orders')
      .doc(widget.orderId)
      .update({
        'orderStatus': newStatus,
      });

    // Refresh order data
    setState(() {
      _orderData = fetchOrderData();
      _isUpdating = false;
    });
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order status updated to: $newStatus')),
    );
    
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error updating status: $e')),
    );
    setState(() {
      _isUpdating = false;
    });
  }
}

  // Get the next status based on current status
  String getNextStatus(String currentStatus) {
    switch (currentStatus.toLowerCase()) {
      case 'waiting for restaurant approval':
        return 'Waiting for payment';
      case 'waiting for payment':
        return 'Waiting for payment confirmation';
      case 'waiting for payment confirmation':
        return 'Preparing food';
      case 'preparing food':
        return 'Completed';
      default:
        return currentStatus;
    }
  }

  // Build different bottom content based on status
  Widget buildStatusContent(Map<String, dynamic> data) {
    final status = data['statusText'].toLowerCase();
    
    switch (status) {
      case 'waiting for restaurant approval':
        return Column(
          children: [
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4c9534),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 5,
                shadowColor: Colors.black.withOpacity(0.3),
              ),
              onPressed: _isUpdating ? null : () => updateOrderStatus('Waiting for payment'),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Text(
                    'Accept this order',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 5,
                shadowColor: Colors.black.withOpacity(0.3),
              ),
              onPressed: _isUpdating ? null : () => updateOrderStatus('Canceled'),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Text(
                    'Cancel this order',
                    style: TextStyle(color: Color(0xFFAF1F1F), fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        );
      
      case 'waiting for payment confirmation':
  return Column(
    children: [
      const SizedBox(height: 10),
      Container(
        width: double.infinity,
        height: 200, // Increased height for better image display
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: data['slipUrl'] != null && data['slipUrl'].isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                data['slipUrl'],
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / 
                            loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Text(
                      'Unable to load payment slip',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                },
              ),
            )
          : const Center(
              child: Text(
                'No payment slip available',
                style: TextStyle(color: Colors.grey),
              ),
            ),
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 5,
                shadowColor: Colors.black.withOpacity(0.3),
              ),
              onPressed: _isUpdating ? null : () => updateOrderStatus('Canceled'),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Color(0xFFAF1F1F), fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4c9534),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 5,
                shadowColor: Colors.black.withOpacity(0.3),
              ),
              onPressed: _isUpdating ? null : () => updateOrderStatus('Preparing food'),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Text(
                    'Confirm',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  );
      
      case 'preparing food':
        return Column(
          children: [
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 5,
                shadowColor: Colors.black.withOpacity(0.3),
              ),
              onPressed: () {
                if (data['slipUrl'] != null && data['slipUrl'].isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Image.network(
                          data['slipUrl'],
                          fit: BoxFit.contain,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No payment slip available')),
                  );
                }
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Text(
                    'Check payment details',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3F51B5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 5,
                shadowColor: Colors.black.withOpacity(0.3),
              ),
              onPressed: _isUpdating ? null : () => updateOrderStatus('Completed'),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Text(
                    'Order is ready to pick up',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        );
      
      case 'completed':
        return Column(
          children: [
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 5,
                shadowColor: Colors.black.withOpacity(0.3),
              ),
              onPressed: () {
                if (data['slipUrl'] != null && data['slipUrl'].isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Image.network(
                          data['slipUrl'],
                          fit: BoxFit.contain,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No payment slip available')),
                  );
                }
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Text(
                    'Check payment details',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        );
      
      default:
        return Column(
          children: [
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 5,
                shadowColor: Colors.black.withOpacity(0.3),
              ),
              onPressed: null,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Text(
                    'No actions available',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9CA),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _orderData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data!;
          return Stack(
            children: [
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: CurveAppBar(title: 'Order Detail'),
              ),
              Positioned(
                top: 40,
                left: 16,
                child: IconButton(
                  icon: const Icon(Icons.chevron_left,
                      size: 30, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              
              Positioned.fill(
                top: 250,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFB71C1C),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // แสดงสถานะ + เวลา
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: data['statusColor'],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      data['statusText'],
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(
                                    data['timeAgo'],
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Order ID: ${data['orderId']}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 14,
                                    child:
                                        Icon(Icons.person, color: Colors.red),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      data['customerName'],
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${data['restaurantName']}\nLocation: ${data['canteenName']}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Order time: ${data['orderTime']}\nPick up time: ${data['pickupTime']}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Menu',
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 175, 31, 31),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    ...List<Map<String, dynamic>>.from(data['menuItems']).expand((item) {
                                      final List<Map<String, dynamic>> addons = List<Map<String, dynamic>>.from(item['addons'] ?? []);

                                      return [
                              
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 4),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${item['name']}",
                                                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFB71C1C)),
                                              ),
                                              Text(
                                                "x${item['quantity']}",
                                                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFB71C1C)),
                                              ),
                                              Text(
                                                "${item['total']}฿",
                                                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFB71C1C)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      
                                        ...addons.map((addon) => Padding(
                                          padding: const EdgeInsets.only(left: 20, bottom: 2),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                      
                                              Row(
                                                children: [
                                                  const Text('• ', style: TextStyle(color: Color(0xFFB71C1C), fontSize: 13)),
                                                  Text(
                                                    addon['name'],
                                                    style: const TextStyle(color: Color(0xFFB71C1C), fontSize: 13),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    "x${addon['quantity']}",
                                                    style: const TextStyle(color: Color(0xFFB71C1C), fontSize: 13),
                                                  ),
                                                ],
                                              ),
                                            
                                              Text(
                                                addon['price'] != null
                                                    ? "${(addon['price'] * addon['quantity']).toStringAsFixed(1)}฿"
                                                    : '',
                                                style: const TextStyle(color: Color(0xFFB71C1C), fontSize: 13),
                                              ),
                                            ],
                                          ),
                                        ))
                                                                              ];
                                    }).toList(),
                                  ],
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFDDC5C),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    'Total  ${data['totalAmount']}  baht',
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 175, 31, 31),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              // Dynamic content based on status
                              buildStatusContent(data),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_isUpdating)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
}