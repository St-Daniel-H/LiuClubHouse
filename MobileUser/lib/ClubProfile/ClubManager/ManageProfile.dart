import 'package:flutter/material.dart';

class ClubProfileManager extends StatefulWidget {
  const ClubProfileManager({Key? key}) : super(key: key);

  @override
  State<ClubProfileManager> createState() => _ClubProfileManagerState();
}

class _ClubProfileManagerState extends State<ClubProfileManager> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Profile"),
    );
  }
}
