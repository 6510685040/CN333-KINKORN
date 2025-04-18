import 'package:flutter/material.dart';
import 'package:kinkorn/Screen/home.dart';
import 'package:kinkorn/Screen/login.dart';
import 'package:kinkorn/Screen/register_res.dart';
import 'package:kinkorn/customer/add_on.dart';
import 'package:kinkorn/customer/choose_canteen.dart';
import 'package:kinkorn/customer/choose_menu.dart';
import 'package:kinkorn/customer/choose_restaurant.dart';
import 'package:kinkorn/customer/order_sum.dart';
import 'package:kinkorn/customer/your_cart.dart';
import 'package:kinkorn/customer/order_sum.dart';
import 'package:kinkorn/customer/more_cus.dart';
import 'package:kinkorn/customer/order_status.dart';
import 'package:kinkorn/customer/order_detail.dart';

void main() {
  runApp(MaterialApp(
    home: OrderSummary(),
  ));
}
