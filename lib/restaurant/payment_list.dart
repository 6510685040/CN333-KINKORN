import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kinkorn/restaurant/add_payment.dart';
import 'package:kinkorn/restaurant/edit_payment.dart';
import 'package:kinkorn/template/restaurant_bottom_nav.dart';

class BankAccount {
  final String id;
  final String accountName;
  final String bankName;
  final String accountNumber;

  BankAccount({
    required this.id,
    required this.accountName,
    required this.bankName,
    required this.accountNumber,
  });

  factory BankAccount.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BankAccount(
      id: doc.id,
      accountName: data['accountName'] ?? '',
      bankName: data['bankName'] ?? '',
      accountNumber: data['accountNumber'] ?? '',
    );
}
}

class EditPaymentPage extends StatefulWidget {
  @override
  _EditPaymentPageState createState() => _EditPaymentPageState();
}

class _EditPaymentPageState extends State<EditPaymentPage> {
  List<BankAccount> accounts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPaymentMethods();  // เรียกใช้ฟังก์ชันที่โหลดข้อมูล
  }

  Future<void> _loadPaymentMethods() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final docSnapshot = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(user.uid)
          .collection('paymentMethods')  // เปลี่ยนจาก bankAccounts เป็น paymentMethods
          .get();

      setState(() {
        accounts = docSnapshot.docs
            .map((doc) => BankAccount.fromDoc(doc))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error loading payment methods: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB71C1C),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            color: Color(0xFFFFFBE6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, size: 30, color: Color(0xFFB71C1C)),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                Text(
                  'EDIT PAYMENT',
                  style: TextStyle(
                    color: Color(0xFFB71C1C),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                /*Text(
                  'List of Your Payment Methods',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),*/
              ],
            ),
          ),

          // Payment Methods List
          Expanded(
            child: isLoading
              ? Center(child: CircularProgressIndicator())
              : accounts.isEmpty
              ? Center(child: Text('No payment methods found.'))
              : Padding(
                padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ...accounts.map(
                        (account) => Container(
                          margin: EdgeInsets.only(bottom: 16),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
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
                              Row(
                                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Account Name : ',
                                            style: TextStyle(
                                              color: Colors.red[900],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(account.accountName),
                                        ],
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            'Bank name : ',
                                            style: TextStyle(
                                              color: Colors.red[900],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(account.bankName),
                                        ],
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            'Account Number : ',
                                            style: TextStyle(
                                              color: Colors.red[900],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(account.accountNumber),
                                        ],
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditPayment(
                                            restaurantId: FirebaseAuth.instance.currentUser!.uid,
                                            paymentMethodId: account.id,
                                          ), 
                                        ),
                                      );
                                      if (result == true) {
                                        _loadPaymentMethods();
                                      }
                                    },
                                    child: Text(
                                      'edit',
                                      style: TextStyle(
                                        color: Colors.red[900],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
              ),
          ),
          Padding(
            padding: const EdgeInsets.all(50),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddPayment()),
                  );
                  if (result == true) {
                    _loadPaymentMethods();
                  }
                },
                child: const Text(
                  'ADD PAYMENT METHOD',
                  style: TextStyle(
                    color: Colors.black, 
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          )


          //const CustomBottomNav(),
        ],
      ),
    );
  }
}
