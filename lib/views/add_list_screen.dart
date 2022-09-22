// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:to_do_app/common_widget/common_text_style.dart';

class AddListScreen extends StatefulWidget {
  const AddListScreen({Key? key}) : super(key: key);

  @override
  _AddListScreenState createState() => _AddListScreenState();
}

class _AddListScreenState extends State<AddListScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenSize.height * 0.2),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: screenSize.height * 0.2,
              width: screenSize.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                gradient: LinearGradient(
                  end: Alignment.topRight,
                  begin: Alignment.topLeft,
                  colors: [
                    Colors.blue,
                    Colors.lightBlue,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Add To Do List',
                    style: commonStyle(Colors.white, 20.0, FontWeight.w400),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: screenSize.height * 0.04),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: screenSize.width * 0.04),
              child: TextFormField(
                controller: _titleController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'please Enter the Title';
                  } else {
                    return null;
                  }
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter the Title',
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenSize.height * 0.05),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: screenSize.width * 0.04),
              child: TextFormField(
                controller: _descriptionController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'please Enter the Description';
                  } else {
                    return null;
                  }
                },
                maxLines: 10,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter the Description',
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            FirebaseFirestore.instance
                .collection('add')
                .add({
                  'uid': box.read('uid').toString(),
                  'title': _titleController.text,
                  'Description': _descriptionController.text,
                  'userId': FirebaseAuth.instance.currentUser!.uid,
                })
                .then(
                  (value) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.blue,
                      content: Text('SuccessFully Added '),
                    ),
                  ),
                )
                .then((value) => Navigator.pop(context));
          }
        },
        child: Icon(Icons.done),
      ),
    );
  }
}
