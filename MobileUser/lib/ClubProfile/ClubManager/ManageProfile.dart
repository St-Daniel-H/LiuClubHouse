import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'dart:io';
const baseURL = 'liuclubhouse.000webhostapp.com';

class ClubProfileManager extends StatefulWidget {
  const ClubProfileManager({Key? key, required this.clubId}) : super(key: key);
  final String clubId;
  @override
  State<ClubProfileManager> createState() => _ClubProfileManagerState();
}

class _ClubProfileManagerState extends State<ClubProfileManager> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  @override
  void dispose() {
    _controllerName.dispose();
    _controllerDescription.dispose();
    super.dispose();
  }
  String Name="Loading";
  String Logo="/Uploads/ClubLogo/default.jpg";
  String Description ="Loading";
  String CreatedAt="Loading";
  bool loading = true;
  String userId ="";
  File ?selectedFile;
  bool load = false;
  String imageUrl ="https://liuclubhouse.000webhostapp.com/Uploads/ClubLogo/default.jpg";

  late SharedPreferences prefs;
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      String filePath = result.files.single.path!;
       selectedFile = File(filePath);
    } else {
      // User canceled the picker
    }
  }
  Future<void> loadUserId() async {
    prefs = await SharedPreferences.getInstance();
    userId =(await prefs.getString('userId'))!;
  }
  Future<void> getClubInfo() async {
    setState(() {
      imageUrl = "https://liuclubhouse.000webhostapp.com/Uploads/ClubLogo/${widget.clubId}?random=${DateTime.now().millisecondsSinceEpoch}";
      load=true;
    });
    try {
      final url = Uri.https(baseURL, '/api/Mobile/getClubInfo.php');
      final response = await http
          .post(url,
          headers: <String, String>{
            'content-type': 'application/json; charset=UTF-8'
          },
          body: convert.jsonEncode(<String, String>{
            'ClubId': widget.clubId.toString(),
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
            _controllerName.text = Name;
            _controllerDescription.text = Description;
          });
          setState(() {
            load=false;
          });
        }
      }
      setState(() {
        load=false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      setState(() {
        load = false;
      });

    }
  }
  Future<void> updateClubInfo() async {
    try {
      setState(() {
        load=true;
      });

      final url = Uri.https(baseURL, '/api/Mobile/ManageAPI/updateClubProfile.php');

      // Create a multi-part request
      var request = http.MultipartRequest('POST', url);

      // Add fields to the request
      request.fields['UserId'] = userId;
      request.fields['ClubId'] = widget.clubId.toString();
      request.fields['Name'] = _controllerName.text;
      request.fields['Description'] = _controllerDescription.text;
      request.fields['Key'] = 'your_key';

      // Add the file to the request
      if (selectedFile != null) {
        var filePart = await http.MultipartFile.fromPath('file', selectedFile!.path);
        request.files.add(filePart);
      }

      // Send the request
      var response = await request.send().timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        setState(() {

          getClubInfo();
        });

      }
      setState(() {
        load=false;

      });
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
setState(() {
  load=false;
});    }
    getClubInfo();

  }
  void initState() {
    super.initState();
     imageUrl = "https://liuclubhouse.000webhostapp.com/Uploads/ClubLogo/${widget.clubId}";
    _controllerName.text = Name;
    _controllerDescription.text = Description;
    loadUserId();
    getClubInfo();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            height: 300,
            constraints: BoxConstraints(
              maxWidth: 700, // Set the maximum width
            ),
          child:Image.network(imageUrl,
            width: double.infinity, // Make the image take the full available width
            height: 300, // Set the fixed height
            fit: BoxFit.cover, )

        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              !load ? "$Name" : "Loading",
              style: TextStyle(fontWeight: FontWeight.bold,fontSize:20.0),
            ),
            Text(
              "Created at: $CreatedAt",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
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
                            (value == null || value.isEmpty) ? 'Please fill Name' : null,
                            controller: _controllerName,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: 'Name',
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
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _pickFile,
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                            ),
                            child: Text('Change Image'),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: (){
                              updateClubInfo();
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
    );
  }
}
