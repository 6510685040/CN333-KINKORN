import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Dropdown Bank Example')),
        body: BankDropdown(),
      ),
    );
  }
}

class BankDropdown extends StatefulWidget {
  @override
  _BankDropdownState createState() => _BankDropdownState();
}

class _BankDropdownState extends State<BankDropdown> {
  String? selectedBank;
  final List<String> banks = ['SCB', 'KBANK', 'KTB'];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButton<String>(
        hint: Text('เลือกธนาคาร'),
        value: selectedBank,
        onChanged: (String? newValue) {
          setState(() {
            selectedBank = newValue;
          });
        },
        items: banks.map<DropdownMenuItem<String>>((String bank) {
          return DropdownMenuItem<String>(
            value: bank,
            child: Text(bank),
          );
        }).toList(),
      ),
    );
  }
}