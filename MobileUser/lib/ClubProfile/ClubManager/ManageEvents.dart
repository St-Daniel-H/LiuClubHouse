import 'package:flutter/material.dart';

class EventManager extends StatefulWidget {
  const EventManager({Key? key}) : super(key: key);

  @override
  State<EventManager> createState() => _EventManagerState();
}

class _EventManagerState extends State<EventManager> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Events"),
    );
  }
}
