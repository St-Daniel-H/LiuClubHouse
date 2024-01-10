import 'package:flutter/material.dart';
import 'ManageEvents.dart';
import 'ManageMembers.dart';
import 'ManageProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageHome extends StatefulWidget {
  const ManageHome({Key? key, required this.clubId, required this.userId}) : super(key: key);
  final String clubId;
  final String userId;
  @override
  State<ManageHome> createState() => _ManageHomeState();
}

class _ManageHomeState extends State<ManageHome> {
  int _selectedIndex = 0;
  List<Widget> manageOption = <Widget>[];

  @override
  void initState() {
    super.initState();

    // Initialize manageOption in initState where widget is accessible
    manageOption = [
      ClubProfileManager(clubId: widget.clubId),
      EventManager(clubId: widget.clubId),
      MemberManager(clubId: widget.clubId, userId: widget.userId,),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liu Club House'),
      ),
      body: Center(
        child: manageOption[_selectedIndex],
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Manage Your Club'),
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Events'),
              onTap: () {
                _onItemTapped(1);

                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Members'),
              onTap: () {
                _onItemTapped(2);

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

