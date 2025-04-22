import 'package:flutter/material.dart';

class AddOnWidget extends StatelessWidget {
  final String label;
  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const AddOnWidget({
    super.key,
    required this.label,
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'GeistFont',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Color(0xFFAF1F1F),
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: onDecrement,
              color: Colors.red,
            ),
            Text('$count'),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: onIncrement,
              color: Colors.green,
            ),
          ],
        ),
      ],
    );
  }
}

class SummaryPayment extends StatelessWidget {
  final String menuName;
  final double price;
  final Map<String, int> options;
  final String specialRequest;

  const SummaryPayment({
    super.key,
    required this.menuName,
    required this.price,
    required this.options,
    required this.specialRequest,
  });

  @override
  Widget build(BuildContext context) {
    double totalAddonPrice = options.values.fold(0, (sum, count) => sum + count * 10); 
    double total = price + totalAddonPrice;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary Payment'),
        backgroundColor: const Color(0xFFAF1F1F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('เมนู: $menuName', style: const TextStyle(fontSize: 18)),
            Text('ราคา: ฿$price', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            const Text('Add-ons:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...options.entries.map((entry) => Text('${entry.key}: ${entry.value}')), 
            const SizedBox(height: 20),
            Text('คำขอพิเศษ: $specialRequest'),
            const Spacer(),
            Text('รวมทั้งหมด: ฿$total', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
