import 'package:flutter/material.dart';
import 'package:liu_club_house/loginpage.dart';
import 'package:liu_club_house/signuppage.dart';
void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Login & Signup'),
            bottom: TabBar(
              tabs: [
                Tab(text: 'Login'),
                Tab(text: 'Signup'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              LoginCard(),
              SignUpCard(),
            ],
          ),
        ),
      ),
    );
  }
}