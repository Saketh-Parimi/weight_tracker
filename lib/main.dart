import 'package:flutter/material.dart';
import 'package:weight_tracker/pages/home_page.dart';
import 'package:weight_tracker/pages/landing_page.dart';
import 'package:weight_tracker/pages/login_page.dart';
import 'package:weight_tracker/pages/register_page.dart';
import 'package:weight_tracker/pages/verify_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: LandingPage(),
      routes: {
        HomePage.routeName: (context) => HomePage(),
        RegisterPage.routeName: (context) => RegisterPage(),
        LoginPage.routeName: (context) => LoginPage(),
        VerifyPage.routeName: (context) => VerifyPage(),
      },
    );
  }
}