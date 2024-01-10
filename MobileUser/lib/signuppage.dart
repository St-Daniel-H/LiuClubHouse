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
  final TextEditingController _controllerConfirm = TextEditingController();
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
    _controllerConfirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20.0),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child:Column(
              mainAxisSize: MainAxisSize.min,
              children:[
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
                const SizedBox(height: 20),
                TextFormField(
                  validator: (value) =>
                  (value == null || value.isEmpty) ? 'Please Confirm Password' : null,
                  controller: _controllerConfirm,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
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
                        _controllerConfirm.text,
                      );
                    }
                  },
                  child: _loading
                      ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                      : const Text('Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ) ,
          ) ;
  }
}

void saveUser(Function(String) update, String name, String email, String password,String confirm) async {
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
          'Confirm':confirm,
          'key': 'your_key'
        }))
        .timeout(const Duration(seconds: 20));
    if (response.statusCode == 200) {
      update(response.body);
    }
  } catch (e) {
    update(e.toString());
  }
}