import 'package:flutter/material.dart';
import 'package:kinkorn/Screen/home.dart';
import 'package:kinkorn/Screen/login.dart';
import 'package:kinkorn/Screen/register_res.dart';
import 'package:kinkorn/customer/add_on.dart';
import 'package:kinkorn/customer/choose_canteen.dart';
import 'package:kinkorn/customer/choose_menu.dart';
import 'package:kinkorn/customer/choose_restaurant.dart';
import 'package:kinkorn/restaurant/add_payment.dart';
import 'package:kinkorn/restaurant/edit_payment.dart';
import 'package:kinkorn/restaurant/sales_report.dart';

void main() {
  runApp(MaterialApp(
    //home:  HomeScreen(),
    home:  AddPayment(),
    //home:  EditPayment(),
    //home: SalesReport(),
  ));
}
