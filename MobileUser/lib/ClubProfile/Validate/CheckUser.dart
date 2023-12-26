import 'package:shared_preferences/shared_preferences.dart';
Future<bool> isSender(String senderId) async {
  late SharedPreferences prefs;

  prefs = await SharedPreferences.getInstance();
  var userId =(prefs.getString('userId'))!;

  return userId==senderId;
}
Future<bool> isOwner(String managerId) async {
  late SharedPreferences prefs;
  prefs = await SharedPreferences.getInstance();
  var userId =(prefs.getString('userId'))!;
  return userId == managerId;
}
Future<bool> canDeleteMessage(senderId,clubId) async {
  return await isSender(senderId) || await isOwner(clubId);
}