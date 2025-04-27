import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kinkorn/template/restaurant_bottom_nav.dart';
import 'package:intl/intl.dart';

class SalesReport extends StatefulWidget {
  @override
  _SalesReportState createState() => _SalesReportState();
}

class _SalesReportState extends State<SalesReport> {
  DateTime? startDate;
  DateTime? endDate;
  Map<String, List<Map<String, dynamic>>> salesData = {};
  List<Map<String, dynamic>> selectedSales = [];
  String restaurantName = '';
  String restaurantId = '';

  @override
  void initState() {
    super.initState();
    startDate = DateTime.now(); 
     endDate = DateTime.now(); 
    _loadRestaurantAndSales();
  }

  Future<void> _loadRestaurantAndSales() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final docRef = FirebaseFirestore.instance.collection('restaurants').doc(uid);
    final docSnap = await docRef.get();

    if (docSnap.exists) {
      restaurantId = docSnap.id;
      restaurantName = docSnap.data()?['restaurantName'] ?? 'Unnamed';
      setState(() {});
      await fetchSalesFromFirestore(restaurantId);
    } else {

      final qs = await FirebaseFirestore.instance
          .collection('restaurants')
          .where('ownerId', isEqualTo: uid)
          .limit(1)
          .get();
      if (qs.docs.isNotEmpty) {
        final doc = qs.docs.first;
        restaurantId = doc.id;
        restaurantName = doc.data()['restaurantName'] ?? 'Unnamed';
        setState(() {});
        await fetchSalesFromFirestore(restaurantId);
      } else {
        print('⚠️ No restaurant found for user $uid');
      }
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        startDate = picked;
        if (endDate != null && endDate!.isBefore(startDate!)) {
          endDate = null;
        }
      } else {
        if (startDate != null && picked.isBefore(startDate!)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("วันที่สิ้นสุดต้องไม่ก่อนวันที่เริ่มต้น")),
          );
        } else {
          endDate = picked;
        }
      }
      _updateSelectedSales();
    });
  }

 Future<void> fetchSalesFromFirestore(String id) async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('restaurants')
        .doc(id)
        .collection('orders')
        .where('orderStatus', isEqualTo: 'Completed')
        .get();

    final Map<String, List<Map<String, dynamic>>> newSalesMap = {};

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final ts = data['createdAt'] as Timestamp?;
      if (ts == null) continue;

      final dateKey = DateFormat('yyyy-MM-dd').format(ts.toDate());
      final items = data['items'] as List<dynamic>? ?? [];

      for (var item in items) {
        final name = item['name'] as String? ?? 'Unnamed';
        final qty = (item['quantity'] as num?)?.toInt() ?? 0;
        final price = (item['price'] as num?)?.toDouble() ?? 0.0;
        final revenue = qty * price;
        final addons = (item['addons'] is List)
            ? List<Map<String, dynamic>>.from(item['addons'])
            : [];

        newSalesMap.putIfAbsent(dateKey, () => []);
        newSalesMap[dateKey]!.add({
          'createdAt': dateKey,
          'menu': name,
          'quantity': qty.toString(),
          'revenue': revenue.toStringAsFixed(2),
          'addons': addons.map((addon) => {
            'name': addon['name'] ?? '',
            'quantity': addon['quantity'] ?? 0,
            'price': addon['price'] ?? 0.0,
          }).toList(),
        });
      }
    }

    setState(() {
      salesData = newSalesMap;
    });

    _updateSelectedSales();
  } catch (e) {
    print("❌ Error fetching sales: $e");
  }
}


DateTime normalizeDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}


 void _updateSelectedSales() {
  if (salesData.isEmpty) return;

  final normalizedStart = startDate != null ? normalizeDate(startDate!) : null;
  final normalizedEnd = endDate != null ? normalizeDate(endDate!) : null;

  setState(() {
    selectedSales = [];

    salesData.forEach((date, sales) {
      final dateObj = DateFormat('yyyy-MM-dd').parse(date);
      if (normalizedStart != null && normalizedEnd != null) {
        if (!dateObj.isBefore(normalizedStart) && !dateObj.isAfter(normalizedEnd)) {
          selectedSales.addAll(sales);
        }
      }
    });
  });
}

 // double calculateTotalSales() =>
     // selectedSales.fold(0, (sum, item) => sum + double.parse(item['price']));
double calculateTotalSales() =>
    selectedSales.fold(0.0, (sum, item) {
      final revenue = double.parse(item['revenue']);
      return sum + revenue;  
    });

  int calculateTotalQuantity() =>
      selectedSales.fold(0, (sum, item) => sum + int.parse(item['quantity']));

@override
Widget build(BuildContext context) {
  final formattedStart =
      startDate != null ? DateFormat('yyyy-MM-dd').format(startDate!) : 'Start Date';
  final formattedEnd =
      endDate != null ? DateFormat('yyyy-MM-dd').format(endDate!) : 'End Date';

  return Scaffold(
    backgroundColor: Color(0xFFAF1F1F),
    body: Stack(
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.12,
          color: Color(0xFFFCF9CA),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 40),
            child: Text(
              "sales_report_page".tr(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.087,
                color: Color(0xFFAF1F1F),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 120),
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              child: Column(
                children: [
                  Text(
                    restaurantName.isNotEmpty ? restaurantName : 'Loading...',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: Color(0xFFFCF9CA),
                    ),
                  ),
                  SizedBox(height: 5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('from'.tr(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFCF9CA))),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => _selectDate(context, true),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(120, 30),
                          backgroundColor: Color(0xFFECECEC),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(formattedStart),
                      ),
                      SizedBox(width: 10),
                      Text('till'.tr(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFCF9CA))),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => _selectDate(context, false),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(120, 30),
                          backgroundColor: Color(0xFFECECEC),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(formattedEnd),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: selectedSales.isEmpty
                        ? Center(child: Text('no_sales_data'.tr()))
                        : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 50,
                            columns: [
                              DataColumn(label: Text('menu_page_title'.tr(), style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('quantity'.tr(), style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('revenue'.tr(), style: TextStyle(fontWeight: FontWeight.bold))),
                            ],
                            rows: selectedSales
                              .where((sale) => !(sale['isAddon'] ?? false))  
                              .map((sale) {
                            final List<Map<String, dynamic>> addons = (sale['addons'] is List)
                              ? List<Map<String, dynamic>>.from(sale['addons'])
                              : [];
                            return DataRow(cells: [
                              DataCell(
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      sale['menu'],
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    ...addons.map((addon) => Padding(
                                      padding: const EdgeInsets.only(left: 8.0, top: 2.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('• '),
                                            Expanded(
                                              child: Text('${addon['name']} x${addon['quantity']}'),
                                            ),
                                          ],
                                        ),
                                      )),
                                  ],
                                ),
                              ),
                              DataCell(
                                Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      sale['quantity'],
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                  ),
                                ),
                              ),
                              DataCell(
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '฿${double.parse(sale['revenue']).toStringAsFixed(2)}',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                                    ),
                                    ...addons.map((addon) => Padding(
                                      padding: const EdgeInsets.only(left: 8.0, top: 2.0),
                                      child: Text(
                                        '฿${(addon['quantity'] * addon['price']).toStringAsFixed(2)}',
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                            ]);
                            }).toList(),
                          ),
                        ),
                    ),
                  ),
                  // กรอบ Total อยู่ข้างล่างสุด
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'total_quantity'.tr(),
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                calculateTotalQuantity().toString(),
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                              ),
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'total_sales'.tr(),
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                '฿${calculateTotalSales().toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
    bottomNavigationBar: const CustomBottomNav(initialIndex: 2,),
  );
}
}