import 'package:flutter/material.dart';
import 'ClubMessages.dart';
import 'ClubProfile.dart';
import 'ClubEvents.dart';
import 'ClubMembers.dart';
import 'package:flutter/material.dart';


class ClubProfileHome extends StatelessWidget {
  const ClubProfileHome({super.key,required this.clubId});
  final int clubId;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text('LiuClubhouse'),
            bottom: TabBar(
              tabs: [
                Tab(text: 'Home'),
                Tab(text: 'Events'),
                Tab(text: 'Members'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ClubProfile(clubID:clubId),
              const ClubEvents(),
              const ClubMembers(),
            ],
          ),
        ),
      ),
    );
  }
}
