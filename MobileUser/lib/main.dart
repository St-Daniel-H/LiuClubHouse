import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';

const baseURL = 'liuclubhouse.000webhostapp.com';
void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[200],
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.indigo,
            onPrimary: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
      },
    );
  }
}
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
    _controllerEmail.dispose();
    _controllerPass.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
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
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                    LoginUser(update,_controllerEmail.text,
                      _controllerPass.text);
                    },
                    child: const Text('Sign In'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'signup');
                    },
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(const Size(150, 50)),
                      padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                    ),
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    validator: (value) =>
                    (value == null || value.isEmpty) ? 'Please fill Name' : null,
                    controller: _controllerName,
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
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ElevatedButton(
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
          child: _loading
              ? const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
              : const Text('Sign Up'),
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
        .timeout(const Duration(seconds: 20));
    if (response.statusCode == 200) {
      update(response.body);
    }
  } catch (e) {
    update(e.toString());
  }
}
void LoginUser(Function(String) update,String email, String password) async {
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
          'Password':password,
          'Key': 'your_key'
        }))
        .timeout(const Duration(seconds: 20));
    if (response.statusCode == 200) {
      update(response.body);
      Map<String, dynamic> responseData = convert.jsonDecode(response.body);

      // Access the userId property
      String userId = responseData['userId'].toString(); // Convert to String if needed

      // Save userId to SharedPreferences
      await prefs.setString('userId', userId);
    }
  } catch (e) {
    update(e.toString());
  }
}