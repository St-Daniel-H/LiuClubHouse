import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Validate/CheckUser.dart';
import 'Validate/CheckUser.dart';

import 'package:shared_preferences/shared_preferences.dart';
const String _baseURL = 'liuclubhouse.000webhostapp.com';

class Event{
  String Title;
  String Description;
  String DateCreated;
  String StartDate;
  String userId;
  String eventId;
String ClubID;
  Event({required this.Title,required this.Description,required this.DateCreated,required this.StartDate,
    required this.userId,required this.eventId,required this.ClubID});

}
List<Event> events = [];
Future<void> updateEvents(Function(bool success) update,String clubId) async {
  try {

    final url = Uri.https(_baseURL, 'api/Mobile/getEvents.php');
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
      events.clear(); // clear old products
      if (response.statusCode == 200) { // if successful call
        final jsonResponse = convert.jsonDecode(response.body); // create dart json object from json array
        for (var row in jsonResponse) { // iterate over all rows in the json array
          Event e = Event( // create a product object from JSON row object
              // Event(this.Title, this.Description, this.DateCreated, this.StartDate,
              //     this.userId, this.eventId);
          // {ID: "3", UserID: "5", ClubID: "3", Title: "Cool event", Description: "cool event in a cool club",…}

          Title: row['Title'],
              Description: row['Description'],
              DateCreated: row['DateCreated'],
              StartDate:  row['StartDate'],
              userId: row['UserID'],
              eventId: row['ID'],
              ClubID: row['ClubID']
          );
          events.add(e); // add the product object to the _products list
        }

      }
      update(true); // callback update method to inform that we completed retrieving data
    }
  }
  catch(e) {
    print(e.toString());
    update(false); // inform through callback that we failed to get data
  }
}
Future<void> DeleteEvent(Function(bool) update, String userId,String eventId,String clubId) async {
  try {
    final url = Uri.https(_baseURL, 'api/Mobile/ManageAPI/deleteEvent.php');
    if (eventId != null) {
      final response = await http.post(url,
          headers: <String, String>{
            'content-type': 'application/json; charset=UTF-8'
          },
          body: convert.jsonEncode(<String, String>{
            'EventId': eventId,
            'ClubId': clubId,
            'UserId': userId,
            'Key': 'your_key'
          })
      ).timeout(const Duration(seconds: 20)); // max timeout 5 seconds
    }
    updateEvents(update,clubId);

  }
  catch(e) {
    print(e);
  }
}
class ClubEventCard extends StatefulWidget {
  const ClubEventCard({Key? key, required this.e,required this.clubId, required this.ManagerId, required this.update, this.changeLoad}) : super(key: key);
  final Event e;
  final String clubId;
  final String ManagerId;
  final changeLoad;
  final update;
  @override
  State<ClubEventCard> createState() => _ClubEventCardsState();
}

class _ClubEventCardsState extends State<ClubEventCard> {
  bool canDelete = false;

  @override
  void initState() {
    super.initState();
    initializeCanDelete();
  }

  Future<void> initializeCanDelete() async {
    bool x = await isOwner(widget.ManagerId);
    setState(() {
      canDelete = x;
    });
    print(canDelete);
  }

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
        color: Colors.blue,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.e.Title),
              Spacer(),
              Column(
                children: [
                  Text("Posted at: " + widget.e.DateCreated),
                  Text("Starts at: " + widget.e.StartDate),
                ],
              ),
              canDelete
                  ? IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  widget.changeLoad(false);
                  DeleteEvent(
                    widget.update,
                    widget.e.userId,
                    widget.e.eventId,
                    widget.e.ClubID,
                  );
                  setState(() {});
                },
              )
                  : SizedBox(),
            ],
          ),
          SizedBox(height: 20,),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.e.Description,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );

  }
}
class ShowEvents extends StatelessWidget {
  const ShowEvents({Key? key,required this.clubId, required this.update, required this.managerId,required this.changeLoad}) : super(key: key);
  final String clubId;
  final String managerId;
  final changeLoad;
  final update;
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child:ListView.builder(
          reverse: true,
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemCount: events.length,
          itemBuilder: (context, index) => Column(
            children: [
              SizedBox(height: 10),
              Container(
                child: ClubEventCard(e: events[index],clubId: clubId,ManagerId: managerId,update: update,changeLoad: changeLoad),
              ),
            ],
          ),
        )
    );
  }
}

class ClubEvents extends StatefulWidget {
  const ClubEvents({Key? key, required this.clubId, required this.managerId}) : super(key: key);
  final String clubId;
  final String managerId;
  @override
  State<ClubEvents> createState() => _ClubEventsState();
}

class _ClubEventsState extends State<ClubEvents> {
  bool load = false;
  void update(bool success) {
    setState(() {
      load = true; // show product list
      if (!success) {
        // API request failed
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('failed to load data')));
      }
    });
  }
  @override
  void initState() {
    super.initState();
    updateEvents(update,widget.clubId);
  }
 void changeLoad(bool x){
    load = x;
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:load
          ?Align(
        alignment: Alignment.topCenter,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 700,
          ),
          child: ShowEvents(update: update, clubId: widget.clubId.toString(),managerId: widget.managerId,changeLoad:changeLoad
          ) ,
        ),
      ): const Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}


