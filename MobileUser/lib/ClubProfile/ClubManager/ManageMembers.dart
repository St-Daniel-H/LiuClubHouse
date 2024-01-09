import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'AddMemberForm.dart';

const String _baseURL = 'liuclubhouse.000webhostapp.com';

class Members {
  String Name;
  String Picture;
  String JoinedAt;
  String userId;
//[{"Name":"123","Picture":"\/Uploads\/UserProfiles\/default.jpg","ID":"4","DateJoined":"2023-12-25"}]
  Members({
    required this.Name,
    required this.Picture,
    required this.JoinedAt,
    required this.userId,
  });
}

List<Members> members = [];
Future<void> updateMembers(Function(bool success) update, String clubId) async {
  try {
    final url = Uri.https(_baseURL, 'api/Mobile/getMembers.php');
    if (clubId != null) {
      final response = await http
          .post(url,
              headers: <String, String>{
                'content-type': 'application/json; charset=UTF-8'
              },
              body: convert.jsonEncode(
                  <String, String>{'ClubId': clubId, 'Key': 'your_key'}))
          .timeout(const Duration(seconds: 20)); // max timeout 5 seconds
      members.clear(); // clear old products
      if (response.statusCode == 200) {
        // if successful call
        final jsonResponse = convert.jsonDecode(
            response.body); // create dart json object from json array
        for (var row in jsonResponse) {
          // iterate over all rows in the json array
          Members m = Members(
            // create a product object from JSON row object
            // Event(this.Title, this.Description, this.DateCreated, this.StartDate,
            //     this.userId, this.eventId);
            // {ID: "3", UserID: "5", ClubID: "3", Title: "Cool event", Description: "cool event in a cool club",…}

            Name: row['Name'],
            JoinedAt: row['DateJoined'],
            Picture: row['Picture'],
            userId: row['ID'],
          );
          members.add(m); // add the product object to the _products list
        }
      }
      update(
          true); // callback update method to inform that we completed retrieving data
    }
  } catch (e) {
    print(e.toString());
    update(false); // inform through callback that we failed to get data
  }
}

class ShowMembers extends StatefulWidget {
  const ShowMembers(
      {Key? key, required this.clubId, required this.update, this.userId})
      : super(key: key);
  final String clubId;
  final update;
  final userId;
  @override
  State<ShowMembers> createState() => _ShowMembersState();
}

// class _ShowMembersState extends State<ShowMembers> {
//   List<Members>filteredItems = members;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         //search field
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: TextField(
//             onChanged: (value) {
//               // Update the filtered list based on the search query
//               setState(() {
//                 filteredItems = searchForMember(value);
//               });
//             },
//             decoration: InputDecoration(
//               labelText: 'Search',
//               hintText: 'Enter User Name',
//               prefixIcon: Icon(Icons.search),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           ),
//         ),
//         //
//         DataTable(
//           columns: const [
//             DataColumn(label: Text('Picture')),
//             DataColumn(label: Text('Name')),
//             DataColumn(label: Text('Joined At')),
//             DataColumn(label: Text('Kick')),
//           ],
//           rows: filteredItems.map((member) {
//             return DataRow(
//               cells: [
//                 DataCell(ClipOval(
//                   child: ClipOval(
//                     child:Image.network("https://liuclubhouse.000webhostapp.com/${member.Picture}",
//                       height: 32,
//                       width: 32,
//                       fit: BoxFit.cover,
//                     ),
//
//                   ),
//                 )),
//                 DataCell(Text(member.Name)),
//                 DataCell(Text("Joined at: ${member.JoinedAt}")),
//                 DataCell( IconButton(
//                   icon: Icon(
//                     FontAwesomeIcons.userMinus, // Replace with your kick icon
//                     size: 40.0,
//                   ),
//                   onPressed: () {
//                     // Add your kick button onPressed functionality here
//                     print('Kick button pressed!');
//                   },
//                 ),),
//               ],
//             );
//           }).toList(),
//         )
//       ],
//     );
//   }
// }

class _ShowMembersState extends State<ShowMembers> {
  List<Members> filteredItems = members;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search field
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (value) {
              // Update the filtered list based on the search query
              setState(() {
                filteredItems = searchForMember(value);
              });
            },
            decoration: InputDecoration(
              labelText: 'Search',
              hintText: 'Enter User Name',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        // DataTable
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width, // Set minimum width
            ),
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Picture')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Kick')),
              ],
              rows: filteredItems.map((member) {
                return DataRow(
                  cells: [
                    DataCell(
                      ClipOval(
                        child: Image.network(
                          "https://liuclubhouse.000webhostapp.com/${member.Picture}",
                          height: 32,
                          width: 32,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    DataCell(Text(member.Name)),
                    DataCell(
                      IconButton(
                        icon: Icon(
                          FontAwesomeIcons
                              .userMinus, // Replace with your kick icon
                          size: 40.0,
                        ),
                        onPressed: () {
                          // Call kickMember function here with member.userId and clubId
                          kickMemberStatus(member.userId,
                              widget.clubId.toString(), widget.userId);
                        },
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        )
      ],
    );
  }

  // Function to handle kicking a member
  void kickMemberStatus(String memberId, String clubId, String userId) async {
    try {
      await kickMember(memberId, clubId, userId);
      // If the kick action is successful, update the UI accordingly
      setState(() {
        // Remove the kicked member from the filtered list
        filteredItems.removeWhere((member) => member.userId == memberId);
      });
    } catch (e) {
      // Handle any errors that occur during the kick action, if needed
      print('Failed to kick member: $e');
    }
  }

  // Function to kick a member
  Future<void> kickMember(String memberId, String clubId, String userId) async {
    try {
      final kickUrl =
          Uri.https(_baseURL, 'api/Mobile/ManageAPI/removeUser.php');
      final kickResponse = await http
          .post(
            kickUrl,
            headers: <String, String>{
              'content-type': 'application/json; charset=UTF-8'
            },
            body: convert.jsonEncode(<String, String>{
              'UserId': userId,
              'ClubId': clubId,
              'UserToDeleteId': memberId,
              'Key': 'your_key'
            }),
          )
          .timeout(const Duration(seconds: 20));

      if (kickResponse.statusCode != 200) {
        throw Exception('Failed to kick member');
      }
    } catch (e) {
      throw Exception('Failed to kick member: $e');
    }
  }
}

class MemberManager extends StatefulWidget {
  const MemberManager({Key? key, required this.clubId, required this.userId})
      : super(key: key);
  final String clubId;
  final String userId;
  @override
  State<MemberManager> createState() => _MemberManagerState();
}

class _MemberManagerState extends State<MemberManager> {
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
    updateMembers(update, widget.clubId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load
          ? Column(
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: 700,
                    maxHeight: 100,
                  ),
                  child: MemberForm(
                    clubId: widget.clubId.toString(),
                  ),
                ),
                Align(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 700,
                    ),
                    child: Expanded(
                        child: ShowMembers(
                            update: update,
                            clubId: widget.clubId.toString(),
                            userId: widget.userId.toString())),
                  ),
                )
              ],
            )
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

List<Members> searchForMember(String search) {
  return members
      .where((x) => x.Name.toLowerCase().contains(search.toLowerCase()))
      .toList();
}
