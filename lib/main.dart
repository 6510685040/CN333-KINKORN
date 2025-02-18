import 'package:flutter/material.dart';
import 'package:kinkorn/Screen/home.dart';
import 'package:kinkorn/Screen/login.dart';
import 'package:kinkorn/restaurant/edit_profile.dart';
import 'package:kinkorn/restaurant/language_setting.dart';
import 'package:kinkorn/restaurant/contactus_restaurant.dart';
import 'package:kinkorn/restaurant/neworder.dart';
import 'package:kinkorn/restaurant/order_detailRestaurant.dart';
import 'package:kinkorn/restaurant/preparing_order.dart';

void main() {
  runApp(MaterialApp(
    //home: LoginScreen(),
    //home: ContactUsRestaurant(), 
    //home: NewOrder(),
    //home: OrderdetailRestaurant(),
    home: PreparingOrderRestaurant(),
  ));
}

