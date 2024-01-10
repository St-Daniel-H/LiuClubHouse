import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'home/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

const baseURL = 'liuclubhouse.000webhostapp.com';

class LoginCard extends StatefulWidget {
  const LoginCard({super.key});

  @override
  State<LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPass = TextEditingController();
  bool _loading = false;
  bool loggedIn = false;
  void updateLoggedIn() {
    loggedIn = true;
  }

  void update(String text) {
    setState(() {
      _loading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    if (loggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(30.0),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 20),
                TextFormField(
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Please fill Email'
                      : null,
                  controller: _controllerEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Please fill Password'
                      : null,
                  controller: _controllerPass,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _loading = true;
                      });
                      LoginUser(
                          update, _controllerEmail.text, _controllerPass.text,
                          () {
                        updateLoggedIn();
                      });
                    }
                  },
                  child: _loading
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text('Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void LoginUser(Function(String) update, String email, String password,
    Function() updateLoggedIn) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  try {
    final url = Uri.https(baseURL, '/api/Mobile/login.php');
    final response = await http
        .post(url,
            headers: <String, String>{
              'content-type': 'application/json; charset=UTF-8'
            },
            body: convert.jsonEncode(<String, String>{
              'Email': email,
              'Password': password,
              'Key': 'your_key'
            }))
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = convert.jsonDecode(response.body);
      String userId = responseData['userID'].toString();
      prefs.setString('userId', userId);

      updateLoggedIn();
      update(response.body);
    }
  } catch (e) {
    update(e.toString());
  }
}
