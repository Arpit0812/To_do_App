// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/common_widget/common_text_style.dart';
import 'package:to_do_app/services/shared_preferences.dart';
import 'package:to_do_app/views/home_screen.dart';
import 'package:to_do_app/views/sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var userEmail;
  @override
  void initState() {
    getUsername().whenComplete(
      () => Timer(Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                userEmail == null ? SignInScreen() : HomeScreen(),
          ),
        );
      }),
    );

    super.initState();
  }

  Future getUsername() async {
    final obtainedEmail = await SharedPreferenceManager.getUserName();

    setState(() {
      userEmail = obtainedEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: screenSize.height,
            width: screenSize.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: screenSize.height * 0.2,
                  width: screenSize.width * 0.5,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/splash.png'),
                    ),
                  ),
                ),
                Text(
                  'To Do List',
                  style: commonStyle(
                    Colors.white,
                    20.0,
                    FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}


