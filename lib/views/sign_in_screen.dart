// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:to_do_app/common_widget/common_text_style.dart';
import 'package:to_do_app/services/google_service_screen.dart';
import 'package:to_do_app/services/shared_preferences.dart';

import 'home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage('assets/images/vector.png'),
          ),
          SizedBox(height: screenSize.height * 0.08),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: MaterialButton(
              color: Colors.blue.shade50,
              height: screenSize.height * 0.08,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              onPressed: () async {
                if (User != null) {
                  User? user = await signInWithGoogle();
                  SharedPreferenceManager.setUserName(userName: user!.email!);
                  print("${user.email}");

                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => HomeScreen(
                      user: user,
                    ),
                  ));
                } else {
                  print("dsf");
                }
              },
              child: Row(
                children: [
                  SizedBox(width: screenSize.width * 0.02),
                  Container(
                    height: screenSize.height * 0.04,
                    width: screenSize.width * 0.1,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/google.png'),
                      ),
                    ),
                  ),
                  SizedBox(width: screenSize.width * 0.12),
                  Text(
                    'Sign In With Google',
                    style: commonStyle(
                      Colors.black,
                      17.0,
                      FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
