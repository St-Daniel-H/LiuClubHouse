import 'package:flutter/material.dart';

class MemberManager extends StatefulWidget {
  const MemberManager({Key? key}) : super(key: key);

  @override
  State<MemberManager> createState() => _MemberManagerState();
}

class _MemberManagerState extends State<MemberManager> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Members"),
    );
  }
}
