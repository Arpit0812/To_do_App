// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unnecessary_string_interpolations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'package:to_do_app/common_widget/common_text_style.dart';
import 'package:to_do_app/services/google_service_screen.dart';
import 'package:to_do_app/views/add_list_screen.dart';
import 'package:to_do_app/views/sign_in_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, User? user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final box = GetStorage();
  TextEditingController categories = TextEditingController();
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _key,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName:
                  Text("${FirebaseAuth.instance.currentUser!.displayName}"),
              accountEmail: Text("${FirebaseAuth.instance.currentUser!.email}"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    '${FirebaseAuth.instance.currentUser!.photoURL}'),
                backgroundColor:
                    Theme.of(context).platform == TargetPlatform.iOS
                        ? Colors.blue
                        : Colors.white,
              ),
            ),
            ListTile(
              leading: GestureDetector(
                child: Icon(
                  Icons.date_range_outlined,
                  color: Colors.black,
                ),
                onTap: () {},
              ),
              title: Text('Calander'),
              onTap: () {},
            ),
            ListTile(
              leading: GestureDetector(
                child: Icon(
                  Icons.home,
                  color: Colors.black,
                ),
                onTap: () {},
              ),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: GestureDetector(
                child: Icon(
                  Icons.share,
                  color: Colors.black,
                ),
                onTap: () {},
              ),
              title: Text('share'),
              onTap: () {},
            ),
            ListTile(
              leading: GestureDetector(
                child: Icon(
                  Icons.logout,
                  color: Colors.black,
                ),
                onTap: () {},
              ),
              title: Text(
                'logout',
              ),
              onTap: () async {
                await signOut();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignInScreen(),
                    ));
              },
            ),
          ],
        ),
      ),
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
                children: [
                  SizedBox(width: screenSize.width * 0.06),
                  GestureDetector(
                    child: Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                    onTap: () {
                      _key.currentState!.openDrawer();
                    },
                  ),
                  SizedBox(width: screenSize.width * 0.2),
                  Text(
                    'To Do List',
                    style: commonStyle(Colors.white, 20.0, FontWeight.w400),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: -20,
              left: 18,
              child: Container(
                height: screenSize.height * 0.08,
                width: screenSize.width * 0.9,
                child: TextField(
                  controller: categories,
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                  keyboardType: TextInputType.text,
                  mouseCursor: MaterialStateMouseCursor.clickable,
                  decoration: InputDecoration(
                    hintText: 'Search Notes',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Color(0xff707070),
                    ),
                    prefixIcon: GestureDetector(
                      onTap: () {
                        print('Search Buttons');
                      },
                      child: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {},
        child: GestureDetector(
          child: Icon(Icons.add),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddListScreen(),
                ));
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('add')
            .where('uid', isEqualTo: box.read('uid'))
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error = ${snapshot.error}');

          if (snapshot.hasData) {
            List<DocumentSnapshot> info = snapshot.data!.docs;
            print("length======>${info.length}");
            print("Text======>${searchText}");
            if (searchText.isNotEmpty) {
              info = info.where((element) {
                return element
                    .get('title')
                    .toString()
                    .toLowerCase()
                    .contains(searchText.toLowerCase());
              }).toList();
            }
            return ListView.builder(
              itemCount: info.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(10),
                  color: Colors.grey,
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    trailing: InkWell(
                      onTap: () {
                        FirebaseFirestore.instance
                            .collection('add')
                            .doc('${snapshot.data!.docs[index].id}')
                            .delete();
                      },
                      child: Icon(
                        Icons.delete,
                        color: Colors.black,
                      ),
                    ),
                    title: Text('title:${info[index]['title']}'),
                    subtitle: Text('subtitle:${info[index]['Description']}'),
                  ),
                );
              },
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
