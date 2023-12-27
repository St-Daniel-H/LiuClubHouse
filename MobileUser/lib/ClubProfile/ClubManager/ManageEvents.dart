import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'dart:io';
const baseURL = 'liuclubhouse.000webhostapp.com';

class EventManager extends StatefulWidget {
  const EventManager({Key? key, required this.clubId}) : super(key: key);
  final String clubId;
  @override
  State<EventManager> createState() => _EventManagerState();
}

class _EventManagerState extends State<EventManager> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  @override
  void dispose() {
    _controllerTitle.dispose();
    _controllerDescription.dispose();
    super.dispose();
  }
  DateTime selectedDate = DateTime.now();  String userId ="";
  Future<void> selectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: currentDate,
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
  bool load = false;

  late SharedPreferences prefs;

  Future<void> loadUserId() async {
    prefs = await SharedPreferences.getInstance();
    userId =(await prefs.getString('userId'))!;
  }
  Future<void>  submitEvent() async{
    try {
      final url = Uri.https(baseURL, 'api/Mobile/ManageAPI/sendEvent.php');
      if (widget.clubId != null) {
        final response = await http.post(url,
            headers: <String, String>{
              'content-type': 'application/json; charset=UTF-8'
            },
            body: convert.jsonEncode(<String, String>{
              'ClubId': widget.clubId,
              'UserId': userId,
              'Title': _controllerTitle.text,
              'Description': _controllerDescription.text,
              'StartDate': selectedDate.toString(),
              'Key': 'your_key'
            })
        ).timeout(const Duration(seconds: 20)); // max timeout 5 seconds
      }
    }
    catch(e) {
      print(e);
    }
}
  void initState() {
    super.initState();
    loadUserId();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:Column(
        children: [
          Text("Announce new Event"),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      TextFormField(
                        validator: (value) =>
                        (value == null || value.isEmpty) ? 'Please fill Title' : null,
                        controller: _controllerTitle,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        maxLines: 3, // Set the maximum number of lines
                        minLines: 3,
                        validator: (value) =>
                        (value == null || value.isEmpty) ? 'Please fill Description' : null,
                        controller: _controllerDescription,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                        onPressed: () {
                          selectDate(context);
                        },
                        child: Text('Select Date'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: (){
                          submitEvent();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                        child: Text('Submit Changes'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ) ,
    );
  }
}
