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
      home:DefaultTabController(
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10), // Reduced SizedBox height
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Welcome To LIU Club House,\nPlease Enter Your Email & Password\nOr Head Over to Our Sign Up Page!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: LoginCard(),
                  ),
                ],
              ),
              // Signup Page
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Welcome To LIU Club House,\nKindly Provide Your Information\nIn order to start your journey\nIn our Awesome Clubs!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: SignUpCard(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}