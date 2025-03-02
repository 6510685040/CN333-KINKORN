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
import 'package:kinkorn/restaurant/status_waiting.dart';
import 'package:kinkorn/restaurant/status_preparing.dart';
import 'package:kinkorn/restaurant/status_complete.dart';
import 'package:kinkorn/customer/contact_us.dart';
import 'package:kinkorn/restaurant/more_res.dart';
import 'package:kinkorn/customer/more_cus.dart';

void main() {
  runApp(MaterialApp(
    //home:  HomeScreen(),
    //home:  AddPayment(),
    //home:  EditPayment(),
    //home: SalesReport(),
    home: StatusWaiting(),
    //home: StatusPreparing(),
    //home: StatusComplete(),
    //home: ContactUs(),
    //home: MoreRes(),
    //home: MoreCus(),
  ));
}
