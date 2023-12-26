import 'package:flutter/material.dart';

class ClubEvents extends StatefulWidget {
  const ClubEvents({Key? key}) : super(key: key);

  @override
  State<ClubEvents> createState() => _ClubMembersState();
}

class _ClubMembersState extends State<ClubEvents> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Hi events"),
    );
  }
}
