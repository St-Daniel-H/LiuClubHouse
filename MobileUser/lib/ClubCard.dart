import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClubCard extends StatefulWidget {
  const ClubCard({Key? key, required this.Name, required this.ID, required this.Description, required this.Logo}) : super(key: key);
  final String Name;
  final int ID;
  final String Description;
  final String Logo;
  @override
  State<ClubCard> createState() => _ClubCardState();
}

class _ClubCardState extends State<ClubCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              "https://liuclubhouse.000webhostapp.com/${widget.Logo}",
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 12.0),
          Text(
            widget.Name,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            widget.Description,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

  }
}
Widget LoadClubCards(){
  
}