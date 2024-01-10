import 'package:flutter/material.dart';
import 'package:liu_club_house/Home/ClubCard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late SharedPreferences prefs;
  String? userId;

  @override
  void initState() {
    super.initState();
    loadUserId();
  }

  bool _load = false; // used to show products list or progress bar

  void update(bool success) {
    setState(() {
      _load = true; // show product list
      if (!success) {
        // API request failed
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('failed to load data')));
      }
    });
  }

  Future<void> loadUserId() async {
    prefs = await SharedPreferences.getInstance();
    userId = await prefs.getString('userId');
    if (userId != null) {
      updateClubs(update, userId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LIU Club House"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    children: [
                      _load
                          ? Container(
                        constraints: BoxConstraints(
                          maxWidth: 700,
                        ),
                        child:Column(
                          children: [ShowClubs()],
                        ) ,
                      )
                          : const Center(
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

    );
  }
}
