import 'package:flutter/material.dart';
import 'ClubMessages.dart';
import 'ClubProfile.dart';
import 'ClubEvents.dart';
import 'ClubMembers.dart';
import './ClubManager/ManageHome.dart';
import 'package:flutter/material.dart';
import 'Validate/CheckUser.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ClubProfileHome extends StatefulWidget {
  const ClubProfileHome({Key? key, required this.clubId, required this.managerId}) : super(key: key);
  final int clubId;
  final int managerId;
  @override
  State<ClubProfileHome> createState() => _ClubProfileHomeState();
}

class _ClubProfileHomeState extends State<ClubProfileHome> {
  bool canPerformAction = false;
  late SharedPreferences prefs;
  var userId;
  Future<void> initializeCanDelete() async {
    canPerformAction = await isOwner(widget.managerId.toString());
    // Call setState to rebuild the widget with the updated state
    setState(() {});
  }
  Future<void> loadUserId() async {
    prefs = await SharedPreferences.getInstance();
    userId = await prefs.getString('userId');

  }


  @override
  void initState() {
    super.initState();
    loadUserId();
    initializeCanDelete();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text('LIU Club House'),
            actions: [
              canPerformAction ?//only admin can see this
                IconButton(
                  icon: Icon(Icons.settings),
                  //open club settings
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ManageHome(clubId: widget.clubId.toString(),userId:userId.toString(),)),
                    );
                  },
                ) :  SizedBox(),

            ],
            bottom: TabBar(
              tabs: [
                Tab(text: 'Home'),
                Tab(text: 'Events'),
                Tab(text: 'Members'),
              ],
            ),
          ),backgroundColor: Colors.amber,
          body: TabBarView(
            children: [
              ClubProfile(managerId: widget.managerId, clubID:widget.clubId),
              ClubEvents(clubId: widget.clubId.toString(),managerId: widget.managerId.toString(),),
              ClubMembers(clubId: widget.clubId.toString()),
            ],
          ),
        ),
      ),
    );
  }
}

