/*
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class NotificationCus {
  static final Set<String> notifiedOrderIds = {};
  
  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'order', 'แจ้งเตือน',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker'
    );

    const NotificationDetails platformChannelDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0, 
      title,
      body,
      platformChannelDetails
    );
  }
}
*/