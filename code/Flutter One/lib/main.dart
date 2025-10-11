import 'package:dreamjob/home/home.dart';
import 'package:dreamjob/page/loginpage.dart';
import 'package:dreamjob/page/registration.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage()
    );
  }

  // This widget is the root of your application.
  
}
