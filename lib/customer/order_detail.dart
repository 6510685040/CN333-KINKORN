import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kinkorn/customer/order_status.dart';
import 'package:kinkorn/template/curve_app_bar.dart';
import 'package:kinkorn/template/bottom_bar.dart';
import 'package:easy_localization/easy_localization.dart';

class OrderDetailPage extends StatefulWidget {
  final String userId;
  final String orderId;

  const OrderDetailPage({
    super.key,
    required this.userId,
    required this.orderId,
  });

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  late Future<Map<String, dynamic>> _orderData;

  @override
  void initState() {
    super.initState();
    _orderData = fetchOrderData();
  }

  Future<Map<String, dynamic>> fetchOrderData() async {
  final orderDoc = await FirebaseFirestore.instance
      .collection('users')
      .doc(widget.userId)
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
        return Color.fromARGB(255, 32, 56, 118);
      case 'waiting for payment confirmation':
        return Color(0xFFFDDC5C);
      case 'canceled':
        return Colors.black;
      case 'preparing food':
        return Color.fromARGB(255, 132, 132, 132);
      case 'completed':
        return Color.fromARGB(255, 0, 128, 0);
      default:
        return Color.fromARGB(255, 94, 35, 93);
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
  Future<void> _confirmPickup() async {
  try {
    final userOrderSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('orders')
        .doc(widget.orderId)
        .get();
    
    final orderData = userOrderSnapshot.data();
    final ordersList = List<Map<String, dynamic>>.from(orderData?['orders'] ?? []);
    final restaurantId = ordersList.isNotEmpty ? ordersList[0]['restaurantId'] ?? '' : '';

    if (restaurantId.isEmpty) {
      throw Exception('Restaurant ID not found!');
    }

    final batch = FirebaseFirestore.instance.batch();

    final userOrderRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('orders')
        .doc(widget.orderId);

    final restaurantOrderRef = FirebaseFirestore.instance
        .collection('restaurants')
        .doc(restaurantId)
        .collection('orders')
        .doc(widget.orderId);

    final globalOrderRef = FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.orderId);

    batch.update(userOrderRef, {'orderStatus': 'Completed'});
    batch.update(restaurantOrderRef, {'orderStatus': 'Completed'});
    batch.update(globalOrderRef, {'orderStatus': 'Completed'});

    await batch.commit();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ขอบคุณที่ยืนยันการรับอาหาร')),
    );

    setState(() {
      _orderData = fetchOrderData(); // reload
    });
  } catch (e) {
    print('Error confirming pickup: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
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
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: CurveAppBar(title: 'order_detail'.tr()), 
              ),
            Positioned(
              top: screenHeight * 0.088,
              left: screenWidth * 0.05,
              child: IconButton(
                icon: const Icon(Icons.chevron_left, size: 40, color: Colors.white),
                onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OrderStatusCustomer()),
                    );
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
                            // Status and Time
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'order_id'.tr(args: [data['orderId']]), 
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 14,
                                  child: Icon(Icons.person, color: Colors.red),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  data['customerName'],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['restaurantName'] ?? '',
                                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'canteen_location'.tr(args: [data['canteenName'] ?? '']),
                                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                                '${'order_time'.tr()} ${data['orderTime']}\n${'pickup_time'.tr()} ${data['pickupTime']}',
                                style: const TextStyle(color: Colors.white, fontSize: 16),
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
                                  Text(
                                    'menu'.tr(), 
                                    style: TextStyle(color: Color.fromARGB(255, 175, 31, 31), fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  ...List<Map<String, dynamic>>.from(data['menuItems']).expand((item) {
                                    final List<Map<String, dynamic>> addons = List<Map<String, dynamic>>.from(item['addons'] ?? []);
                                    return [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("${item['name']}", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFB71C1C))),
                                            Text("x${item['quantity']}", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFB71C1C))),
                                            Text("${item['total']}฿", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFB71C1C))),
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
                                  '${'total'.tr()} ${data['totalAmount']} ${'baht'.tr()}', // เปลี่ยน Total
                                  style: const TextStyle(color: Color.fromARGB(255, 175, 31, 31), fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFB7B7B7),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                elevation: 5,
                                shadowColor: Colors.black.withOpacity(0.3),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Image.network(
                                        data['slipUrl'] ?? '',
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
                              },
                              child:  Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Center(
                                  child: Text(
                                      'check_payment_details'.tr(), // แปล Check payment details
                                      style: TextStyle(color: Colors.white, fontSize: 16),
                                    ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                           if (data['statusText'] == 'Waiting for pickup') ...[
                              ElevatedButton(
                                onPressed: _confirmPickup,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8), 
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Center(
                                    child: Text(
                                      'confirm_received'.tr(),
                                      style: TextStyle(color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            /*Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BottomBar(
                screenHeight: screenHeight,
                screenWidth: screenWidth,
              ),
            ),*/
          ],
        );
      },
    ),
  );
}
}
