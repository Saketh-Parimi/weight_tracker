import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weight_tracker/pages/landing_page.dart';
import 'package:weight_tracker/pages/register_page.dart';

import 'home_page.dart';

class VerifyPage extends StatefulWidget {
  static const routeName = '/verify';

  const VerifyPage({Key? key}) : super(key: key);

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final auth = FirebaseAuth.instance;
  User? user;
  Timer? timer;

  @override
  void initState() {
    user = auth.currentUser;
    user!.sendEmailVerification();

    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      checkEmailVerify();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Page'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              user!.delete();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterPage()));
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Text('An email has been sent to ${user!.email} pls verify'),
      ),
    );
  }

  Future<void> checkEmailVerify() async {
    user = auth.currentUser;
    if (user != null) {
      await user!.reload();
      if (user!.emailVerified) {
        timer!.cancel();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LandingPage()));
      }
    } else {

    }

  }
}
