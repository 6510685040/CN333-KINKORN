import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:kinkorn/customer/notification_cus.dart';
import 'package:kinkorn/customer/order_detail.dart';
import 'package:provider/provider.dart';
import 'package:kinkorn/Screen/home.dart';
import 'package:kinkorn/provider/cartprovider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kinkorn/customer/language_setting.dart'; 
import 'package:easy_localization/easy_localization.dart';

import 'package:firebase_auth/firebase_auth.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void saveCustomerFcmToken() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final token = await FirebaseMessaging.instance.getToken();
  if (token != null) {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'fcmToken': token,
    }, SetOptions(merge: true));
    print('FCM Token saved: $token');
  }
}

void listenOrderStatusChanges() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print('No logged-in user');
    return;
  }
  final customerId = user.uid;

  FirebaseFirestore.instance
      .collection('orders')
      .where('customerId', isEqualTo: customerId)
      .snapshots()
      .listen((querySnapshot) {
    for (var change in querySnapshot.docChanges) {
      if (change.type == DocumentChangeType.modified) {
        var data = change.doc.data();
        if (data != null) {
          String newStatus = data['orderStatus'] ?? '';
          String restaurantName = data['restaurantName'] ?? '';

          flutterLocalNotificationsPlugin.show(
            newStatus.hashCode,
            'Order Status Update',
            'Your order from $restaurantName is now $newStatus',
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'kinkorn_channel', 
                'Kinkorn Notifications',
                importance: Importance.max,
                priority: Priority.high,
              ),
            ),
          );
        }
      }
    }
  });
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized(); 

  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.deviceCheck,
  );

  // Request notification permission
  await FirebaseMessaging.instance.requestPermission();

  // Save the FCM token when the app starts
  saveCustomerFcmToken();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'kinkorn_channel', 
            'Kinkorn Notifications',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.data['orderId'] != null) {
      String orderId = message.data['orderId'];
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => OrderDetailPage(
            orderId: orderId, 
            userId: FirebaseAuth.instance.currentUser!.uid,
          ),
        ),
      );
    }
  });

  //listenOrderStatusChanges();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('th')],
      path: 'assets/lang',
      fallbackLocale: Locale('en'), 
      
      child: const MyApp(),
  ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        locale: context.locale, 
        supportedLocales: context.supportedLocales, 
        localizationsDelegates: context.localizationDelegates, 
        home: const HomeScreen(),
        theme: ThemeData(
          textTheme: GoogleFonts.kanitTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
      )


    );
  }
}
