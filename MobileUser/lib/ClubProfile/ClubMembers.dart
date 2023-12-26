import 'package:flutter/material.dart';

class ClubMembers extends StatefulWidget {
  const ClubMembers({Key? key}) : super(key: key);

  @override
  State<ClubMembers> createState() => _ClubMembersState();
}

class _ClubMembersState extends State<ClubMembers> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Hi members"),
    );
  }
}
