import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:kinkorn/customer/notification_cus.dart';
import 'package:provider/provider.dart'; 
import 'package:kinkorn/Screen/home.dart';
import 'package:kinkorn/provider/cartprovider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.deviceCheck,
  );

  await FirebaseMessaging.instance.requestPermission();

  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings("@mipmap/ic_launcher");
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  
  runApp(
    const MyApp(), 
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
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
        theme: ThemeData(
          textTheme: GoogleFonts.kanitTextTheme(
            Theme.of(context).textTheme
          )
        ),
      ),
    );
  }
}
