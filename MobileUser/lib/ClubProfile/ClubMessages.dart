import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
const String _baseURL = 'liuclubhouse.000webhostapp.com';

class Message{
  String Name;
  String Picture;
  String DateCreated;
  String Content;
  String userId;
  Message({required this.Name,required this.Picture,required this.DateCreated,required this.userId,required this.Content});
}
List<Message> messages = [];
Future<void> getMessages(Function(bool success) update,String clubId) async {
  try {

    final url = Uri.https(_baseURL, 'api/Mobile/getMessages.php');
    if(clubId!=null){
      final response = await http.post(url,
          headers: <String, String>{
            'content-type': 'application/json; charset=UTF-8'
          },
          body: convert.jsonEncode(<String, String>{
            'ClubId': clubId,
            'Key': 'your_key'
          })
      ).timeout(const Duration(seconds: 20)); // max timeout 5 seconds
      messages.clear(); // clear old products
      if (response.statusCode == 200) { // if successful call
        final jsonResponse = convert.jsonDecode(response.body); // create dart json object from json array
        for (var row in jsonResponse) { // iterate over all rows in the json array
          Message p = Message( // create a product object from JSON row object
              Name: row['Name'],
              Picture: row['Picture'],
              DateCreated: row['Date'],
              userId: row['ID'],
              Content: row['Content']
          );
          messages.add(p); // add the product object to the _products list
        }

      }
      update(true); // callback update method to inform that we completed retrieving data
    }
  }
  catch(e) {
    print(e);
    update(false); // inform through callback that we failed to get data
  }
}
class ClubMessageCard extends StatefulWidget {
  const ClubMessageCard({Key? key, required this.m}) : super(key: key);
  final Message m;
  @override
  State<ClubMessageCard> createState() => _ClubMessagesState();
}

class _ClubMessagesState extends State<ClubMessageCard> {


  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipOval(child:Image.network("https://liuclubhouse.000webhostapp.com/${widget.m.Picture}",height:50,width:50,fit: BoxFit.cover,)),
              SizedBox(width: 20,),
              Text(widget.m.Name),
              Spacer(),
              Text(widget.m.DateCreated)
            ],
          ),
          SizedBox(height: 20,),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.m.Content,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
class ShowMessages extends StatelessWidget {
  const ShowMessages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child:ListView.builder(
        reverse: true,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: messages.length,
        itemBuilder: (context, index) => Column(
          children: [
            SizedBox(height: 10),
            Container(
              child: ClubMessageCard(m: messages[index]),
            ),
          ],
        ),
      )
    );
  }
}

Future<void> sendMessage(String userId,String clubId,String content,Function(bool) update) async {
  try {
    print(content);
    final url = Uri.https(_baseURL, 'api/Mobile/sendMessage.php');
    if (clubId != null) {
      final response = await http.post(url,
          headers: <String, String>{
            'content-type': 'application/json; charset=UTF-8'
          },
          body: convert.jsonEncode(<String, String>{
            'ClubId': clubId,
            'UserId': userId,
            'Content': content,
            'Key': 'your_key'
          })
      ).timeout(const Duration(seconds: 20)); // max timeout 5 seconds
    }
  }
  catch(e) {
    print(e);
    update(false); // inform through callback that we failed to get data
  }
}