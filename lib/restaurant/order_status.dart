import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kinkorn/restaurant/order_detailRestaurant.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kinkorn/template/curve_app_bar.dart';
import 'package:kinkorn/template/restaurant_bottom_nav.dart';

class OrderStatusRestaurant extends StatefulWidget {
  const OrderStatusRestaurant({super.key});

  @override
  State<OrderStatusRestaurant> createState() => _OrderStatusRestaurantState();
}

class _OrderStatusRestaurantState extends State<OrderStatusRestaurant> {
  late DateTime _fromDate;
  late DateTime _tillDate;

  @override
  void initState() {
    super.initState();
    // Initialize with the start of today
    _fromDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    // Initialize with the end of today
    _tillDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
  }
  
  // Get start of the from date (midnight)
  DateTime _getStartOfDay() {
    return DateTime(
      _fromDate.year,
      _fromDate.month,
      _fromDate.day,
    );
  }

  // Get end of the till date (23:59:59)
  DateTime _getEndOfDay() {
    return DateTime(
      _tillDate.year,
      _tillDate.month,
      _tillDate.day,
      23,
      59,
      59,
    );
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    DateTime initialDate = isFromDate ? _fromDate : _tillDate;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != initialDate) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
        } else {
          _tillDate = picked;
        }
      });
    }
  }

  Future<String> _getCustomerName(String customerId) async {
    String customerName = 'Unknown';
    try {
      final customerDoc = await FirebaseFirestore.instance.collection('users').doc(customerId).get();
      if (customerDoc.exists) {
        final userData = customerDoc.data()!;
        customerName = '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''} ${userData['mobile'] ?? ''}';
      }
    } catch (e) {
      print("Error fetching customer name: $e");
    }
    return customerName;
  }
  

  @override
  Widget build(BuildContext context) {
    final restaurantId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9CA),
      body: Stack(
        children: [
          const Positioned(top: 0, left: 0, right: 0, child: CurveAppBar(title: '')),

          /*Positioned(
            top: 70,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.chevron_left, size: 30, color: Color(0xFFFCF9CA)),
              onPressed: () => Navigator.pop(context),
            ),
          ),*/

          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'order_status'.tr(),
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFFCF9CA)),
              ),
            ),
          ),

          Positioned(
            top: 220,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("from".tr(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red)),
                const SizedBox(width: 8),
                _buildDatePickerBox(context, _fromDate, true),
                const SizedBox(width: 16),
                Text("till".tr(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red)),
                const SizedBox(width: 8),
                _buildDatePickerBox(context, _tillDate, false),
              ],
            ),
          ),

          Positioned.fill(
            top: 260,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('restaurants')
                  .doc(restaurantId)
                  .collection('orders')
                  .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(_getStartOfDay()))
                  .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(_getEndOfDay()))
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("no_orders_found".tr()));
                }

                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  children: snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final createdAt = (data['createdAt'] as Timestamp).toDate();
                    final pickUpTime = DateFormat("HH:mm").format((data['pickupTime'] as Timestamp).toDate());
                    final totalAmount = data['totalAmount'] ?? 0;
                    final status = data['orderStatus'] ?? 'unknown';
                    final customerId = data['customerId'] ?? '';
                    final items = List<Map<String, dynamic>>.from(data['orders'] ?? []);
                    print('📦 Full Items: $items');
                final menuItems = (items ?? []).expand((item) {
                  List<String> result = [];

                  if (item is Map<String, dynamic>) {
                    final menuName = item['name']?.toString() ?? 'Unnamed Menu';
                    final menuQty = item['quantity']?.toString() ?? '1';
                    result.add('$menuName x$menuQty'); // <-- บังคับให้เมนูหลักลง result ทันที

                    // addons
                    if (item['addons'] != null) {
                      if (item['addons'] is List) {
                        for (var addon in item['addons']) {
                          if (addon is Map<String, dynamic>) {
                            final addonName = addon['name']?.toString() ?? 'Unnamed Addon';
                            final addonQty = addon['quantity']?.toString() ?? '1';
                            result.add('  • $addonName x$addonQty');
                          }
                        }
                      }
                    }
                  }

                    return result;
                  }).toList();


                    final timeAgo = _getTimeAgo(createdAt);
                    final statusInfo = _getStatusInfo(status);

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderdetailRestaurant(
                              orderId: doc.id,
                              customerId: customerId,
                            ),
                          ),
                        );
                      },
                      
                      child: FutureBuilder<String>(
                        future: _getCustomerName(customerId),
                        builder: (context, nameSnapshot) {
                          final name = nameSnapshot.data ?? 'Loading...';
                          return _buildOrderCard(
                            orderId: doc.id,
                            timeAgo: timeAgo,
                            name: name,
                            menuItems: menuItems,
                            pickUpTime: pickUpTime,
                            totalPrice: '฿${totalAmount.toStringAsFixed(2)}',
                            statusText: statusInfo['text'],
                            statusColor: statusInfo['color'],
                            statusIcon: statusInfo['icon'],
                          );
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(initialIndex: 1,),
    );
  }

  Widget _buildDatePickerBox(BuildContext context, DateTime date, bool isFromDate) {
    return GestureDetector(
      onTap: () => _selectDate(context, isFromDate),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(DateFormat("MMM dd, yyyy").format(date), style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            const Icon(Icons.calendar_today, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard({
    required String orderId,
    required String timeAgo,
    required String name,
    required List<String> menuItems,
    required String pickUpTime,
    required String totalPrice,
    required String statusText,
    required Color statusColor,
    required IconData statusIcon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFAF1F1F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${"order_id_label".tr()} $orderId', style: const TextStyle(color: Color(0xFFFCF9CA), fontSize: 14, fontWeight: FontWeight.bold)),
                Text(timeAgo, style: const TextStyle(color: Color(0xFFFCF9CA), fontSize: 12)),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(radius: 12, backgroundColor: Color.fromARGB(255, 250, 176, 47), child: Icon(Icons.person, color: Colors.white, size: 14)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFFB71C1C)), overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('${"order_id_label".tr()} $orderId', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFFB71C1C))),
                      ...menuItems.map((item) => Text(" $item", style: const TextStyle(fontSize: 12, color: Color(0xFFB71C1C)),)),
                      const SizedBox(height: 8),
                      Text('${"pickup_time".tr()} $pickUpTime', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFB71C1C))),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(statusIcon, color: Color(0xFFFCF9CA), size: 40),
                  Text("total".tr() + " $totalPrice", style: const TextStyle(color: Color(0xFFFCF9CA), fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    width: 100,
                    decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(8)),
                    child: Text(statusText, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                  ),
                ],
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inMinutes < 1) return "just_now".tr();
    if (difference.inMinutes < 60) return "minutes_ago_label".tr(args: [difference.inMinutes.toString()]);
    if (difference.inHours < 24) return "hours_ago".tr(args: [difference.inHours.toString()]);
    return DateFormat("dd MMM").format(dateTime);
  }

  Map<String, dynamic> _getStatusInfo(String status) {
  switch (status) {
    case "Waiting for restaurant approval":
      return {
        "text": "status_waiting_for_order_confirm".tr(),
        "color": const Color(0xFF203976),
        "icon": Symbols.receipt_long,
      };
    case "Waiting for payment":
      return {
        "text": "status_waiting_for_payment".tr(),
        "color": Colors.yellow,
        "icon": Symbols.receipt_long,
      };
    case "Waiting for payment confirmation":
      return {
        "text": "status_waiting_for_confirmation".tr(),
        "color": Colors.yellow,
        "icon": Symbols.receipt_long,
      };
    case "Preparing food":
      return {
        "text": "status_preparing_food".tr(),
        "color": const Color.fromARGB(255, 132, 132, 132),
        "icon": Symbols.skillet,
      };
    case "Waiting for pickup": 
      return {
        "text": "status_waiting_for_pickup".tr(),
        "color": Colors.blue, 
        "icon": Icons.shopping_bag_outlined, 
      };
    case "Completed":
      return {
        "text": "status_completed".tr(),
        "color": Colors.green,
        "icon": Symbols.restaurant,
      };
    case "Canceled":
      return {
        "text": "status_canceled".tr(),
        "color": Colors.black,
        "icon": Icons.cancel,
      };
    default:
      return {
        "text": "unknown".tr(),
        "color": Colors.grey,
        "icon": Icons.help_outline,
      };
  }
}

}