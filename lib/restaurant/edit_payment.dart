import 'package:flutter/material.dart';

class BankAccount {
  final String accountName;
  final String bankName;
  final String accountNumber;

  BankAccount({
    required this.accountName,
    required this.bankName,
    required this.accountNumber,
  });
}

class EditPaymentPage extends StatelessWidget {
  final List<BankAccount> accounts = [
    BankAccount(
      accountName: 'ครัวสุขใจ',
      bankName: 'KBANK',
      accountNumber: '123-4-56789-0',
    ),
    BankAccount(
      accountName: 'ครัวสุขใจ',
      bankName: 'SCB',
      accountNumber: '123-4-55555-0',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB71C1C), // Light yellow background
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
            color: Color(0xFFFFFBE6), // Deep red
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EDIT PAYMENT',
                  style: TextStyle(
                    color: Color(0xFFB71C1C),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'List of Your Bank Accounts',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),

          // Bank Accounts List
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  ...accounts
                      .map((account) => Container(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                              'Bank : ',
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
                                              'Number : ',
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
                                      onPressed: () {},
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
                          ))
                      .toList(),
                  Spacer(),
                  // Add Payment Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'ADD PAYMENT',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Navigation Bar
          Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Color(0xFFFFFBE6),
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(Icons.home, 'home'),
                _buildNavItem(Icons.notifications, 'status'),
                _buildNavItem(Icons.assessment, 'sale report'),
                _buildNavItem(Icons.more_horiz, 'more'),
                _buildNavItem(Icons.person, 'customer'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.grey.shade600),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
