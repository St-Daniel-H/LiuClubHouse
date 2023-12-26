import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'ClubMessages.dart';
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
  String userId ="";
  late SharedPreferences prefs;

  Future<void> loadUserId() async {
    prefs = await SharedPreferences.getInstance();
    userId =(await prefs.getString('userId'))!;
  }
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
  bool _load = false;
  //for Messages
  void update(bool success) {
    setState(() {
      _load = true; // show product list
      if (!success) { // API request failed
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('failed to load data')));
      }
    });
  }
  //end
  @override
  void initState() {
    super.initState();
    getClubInfo();
    loadUserId();
    getMessages(update, widget.clubID.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Name),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        constraints: BoxConstraints(
                          maxWidth: 700,
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
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 12.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  Name,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  "Created at: $CreatedAt",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
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
                          ],
                        ),
                      ),
                      _load
                          ? Container(
                        constraints: BoxConstraints(
                          maxWidth: 700,
                        ),
                        child: ShowMessages(),
                      )
                          : const Center(
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          _buildMessageInputField(userId,widget.clubID.toString()),
        ],
      ),
    );
  }

  Widget _buildMessageInputField(userId,clubId) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _controllerContent = TextEditingController();
    @override
    void dispose() {
      _controllerContent.dispose();
      super.dispose();
    }
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.grey[200],
      child: Row(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: TextFormField(
                validator: (value) =>
                (value == null || value.isEmpty) ? 'Please fill Text' : null,
                controller: _controllerContent,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Type in a message..',
                  border: OutlineInputBorder(),
                ),
              ),
          )

          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              setState(() {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    loading = true;
                  });
                  sendMessage(userId,clubId,_controllerContent.text.toString(),update);
                  getMessages(update, clubId);
                }

              });
    //Future<void> sendMessage(String userId,String clubId,String Content,Function(bool) update) async {
            },
          ),
        ],
      ),
    );
  }
}