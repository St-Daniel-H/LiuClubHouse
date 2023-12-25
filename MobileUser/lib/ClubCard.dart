import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String _baseURL = 'liuclubhouse.000webhostapp.com';

class Club {
   int ID;
   int ManagerID;
   String Name;
   String Description;
   String Logo;
   String DateCreated;
  Club(  this.Name,  this.ID,  this.Description,  this.Logo,  this.ManagerID,  this.DateCreated);
}
void updateClubs(Function(bool success) update, String userId) async {
  try {

    final url = Uri.https(_baseURL, 'api/Mobile/getClubs.php');
    if(userId!=null){
      final response = await http.post(url,
          headers: <String, String>{
            'content-type': 'application/json; charset=UTF-8'
          },
          body: convert.jsonEncode(<String, String>{
            'UserId': userId,
            'Key': 'your_key'
          })
      ).timeout(const Duration(seconds: 20)); // max timeout 5 seconds
      _clubs.clear(); // clear old products
      if (response.statusCode == 200) { // if successful call
        final jsonResponse = convert.jsonDecode(response.body); // create dart json object from json array
        for (var row in jsonResponse) { // iterate over all rows in the json array
          Club p = Club( // create a product object from JSON row object
              row['Name'],
              int.parse(row['ID']),
              row['Description'],
              row['Logo'],
              int.parse(row['ManagerID']),
              row['DateCreated']
          );
          _clubs.add(p); // add the product object to the _products list
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
List<Club> _clubs = [];
class ClubCard extends StatefulWidget {
  const ClubCard({Key? key, required this.p}) : super(key: key);
  final Club p;

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
              "https://liuclubhouse.000webhostapp.com/${widget.p.Logo}",
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 12.0),
          Text(
            widget.p.Name,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            widget.p.Description,
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
class ShowClubs extends StatelessWidget {
  const ShowClubs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ListView.builder(
      itemCount: _clubs.length,
      itemBuilder: (context, index) => Column(
        children: [
          SizedBox(height: 10),
          Container(
            child: ClubCard(p: _clubs[index]),
          ),
          Text(_clubs.length.toString())
        ],
      ),
    );

  }
}