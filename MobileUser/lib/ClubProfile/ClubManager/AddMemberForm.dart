import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String _baseURL = 'liuclubhouse.000webhostapp.com';
Future<void> addMember(Function(bool success) update, String email,String clubId,String userId,Function(String s)apiResponse) async {
  try {
    final url = Uri.https(_baseURL, 'api/Mobile/ManageAPI/addUserToClub.php');
    if (email != null) {
      final response = await http
          .post(url,
              headers: <String, String>{
                'content-type': 'application/json; charset=UTF-8'
              },
              body: convert.jsonEncode(
                  <String, String>{'email': email, 'Key': 'your_key','UserId':userId,
                  'ClubId':clubId}))
          .timeout(const Duration(seconds: 20));
        apiResponse(response.body);
      // callback update method to inform that we completed retrieving data
      update(true);
    }
  } catch (e) {
    print(e.toString());
    update(true); // inform through callback that we failed to get data
  }
}

class ShowMembers extends StatefulWidget {
  const ShowMembers({Key? key, required this.clubId, required this.update, required this.userId})
      : super(key: key);
  final String clubId;
  final String userId;
  final update;

  @override
  State<ShowMembers> createState() => _ShowMembersState();
}

class _ShowMembersState extends State<ShowMembers> {
  String Email = "";

  void apiResponse(String s){
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(s)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  // Update the filtered list based on the search query
                  setState(() {
                    Email = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter User Email',
                  prefixIcon: IconButton(
                    icon: Icon(Icons.plus_one),
                    onPressed: () {
                      print(widget.clubId);
                      addMember(widget.update, Email, widget.clubId, widget.userId, apiResponse);
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
    );
  }
}

class MemberForm extends StatefulWidget {
  const MemberForm({Key? key, required this.clubId}) : super(key: key);
  final String clubId;
  @override
  State<MemberForm> createState() => _MemberFormState();
}

class _MemberFormState extends State<MemberForm> {
  bool load = true;
  void update(bool success) {
    setState(() {
      load = true; // show product list
      if (!success) {
        // API request failed
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('failed to load data')));
      }
    });
  }  String userId ="";
  late SharedPreferences prefs;

  Future<void> loadUserId() async {
    prefs = await SharedPreferences.getInstance();
    userId =(await prefs.getString('userId'))!;
  }
  void initState() {
    super.initState();
    loadUserId();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load
          ?  SizedBox(
                width: double.infinity,
                height: 100,
                    child: ShowMembers(
                  update: update,
                  userId:userId,
                  clubId: widget.clubId.toString(),
                ))
          : const Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
