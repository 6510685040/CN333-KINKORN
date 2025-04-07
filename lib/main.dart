import 'package:flutter/material.dart';
import 'package:kinkorn/Screen/home.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:kinkorn/customer/choose_canteen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: HomeScreen (),
  ));
}


/*WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: LoginScreen(),่ฟร
  ));*/
  