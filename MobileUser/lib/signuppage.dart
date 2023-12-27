import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
const baseURL = 'liuclubhouse.000webhostapp.com';
class SignUpCard extends StatefulWidget {
  const SignUpCard({super.key});

  @override
  State<SignUpCard> createState() => _SignUpCardState();
}

class _SignUpCardState extends State<SignUpCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPass = TextEditingController();
  bool _loading = false;

  void update(String text) {
    setState(() {
      _loading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  void dispose() {
    _controllerName.dispose();
    _controllerEmail.dispose();
    _controllerPass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20.0),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 20),
              TextFormField(
                validator: (value) =>
                (value == null || value.isEmpty) ? 'Please fill Email' : null,
                controller: _controllerEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                validator: (value) =>
                (value == null || value.isEmpty) ? 'Please fill Password' : null,
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
                    saveUser(
                      update,
                      _controllerName.text,
                      _controllerEmail.text,
                      _controllerPass.text,
                    );
                  }
                },
                child: Text('Log in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void saveUser(Function(String) update, String name, String email, String password) async {
  try {
    final url = Uri.https(baseURL, '/api/Mobile/signup.php');
    final response = await http
        .post(url,
        headers: <String, String>{
          'content-type': 'application/json; charset=UTF-8'
        },
        body: convert.jsonEncode(<String, String>{
          'Name': name,
          'Email': email,
          'Password':password,
          'Confirm':password,
          'key': 'your_key'
        }))
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      update(response.body);
    }
  } catch (e) {
    update(e.toString());
  }
}