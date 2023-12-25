import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';
const baseURL = 'liuclubhouse.000webhostapp.com';

class ClubProfile extends StatefulWidget {
  const ClubProfile({Key? key, required this.clubID}) : super(key: key);
  final int clubID;
  @override
  State<ClubProfile> createState() => _ClubProfileState();
}

class _ClubProfileState extends State<ClubProfile> {
  String Name="Loading";
  String Logo="/Uploads/ClubLogo/default.jpg";
  String Description ="Loading";
  String CreatedAt="Loading";
  bool loading = true;

  Future<void> getClubInfo() async {
    try {
      final url = Uri.https(baseURL, '/api/Mobile/getClubInfo.php');
      final response = await http
          .post(url,
          headers: <String, String>{
            'content-type': 'application/json; charset=UTF-8'
          },
          body: convert.jsonEncode(<String, String>{
            'ClubId': widget.clubID.toString(),
            'Key': 'your_key'
          }))
          .timeout(const Duration(seconds: 20));
      if (response.statusCode == 200) {
        List<dynamic> responseData = convert.jsonDecode(response.body);

        if (responseData.isNotEmpty) {
          Map<String, dynamic> data = responseData[0]; // Access the first element
          setState(() {
            Name = data['Name'].toString();
            Logo = data['Logo'].toString();
            Description = data['Description'].toString();
            CreatedAt = data['DateCreated'].toString();
            loading = false;

          });

        }
      }
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      loading = false;
    }
  }
  @override
  void initState() {
    super.initState();
    getClubInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child:Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: 700, // Set the maximum width
          ),
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.black12),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  "https://liuclubhouse.000webhostapp.com/$Logo",
                  width: double.infinity,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text(
                  Name,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ), Spacer(),
                  Text(
                    "Created at: $CreatedAt",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),],
              ),

              SizedBox(height: 8.0),
              Text(
                Description,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0,),
            ],
          ),
        ) ,
      )
    );
  }
}
