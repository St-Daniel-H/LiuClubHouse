import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';
import 'Home/homepage.dart';
import 'signuppage.dart';
import 'loginpage.dart';
const baseURL = 'liuclubhouse.000webhostapp.com';
// void main() {
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primaryColor: Colors.indigo,
//         scaffoldBackgroundColor: Colors.grey[200],
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             primary: Colors.indigo,
//             onPrimary: Colors.white,
//             elevation: 3,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//         ),
//       ),
//       initialRoute: '/',
//       routes: {
//         '/': (context) => const LoginPage(),
//         '/signup': (context) => const SignUpPage(),
//
//       },
//     );
//   }
// }
// class SignUpPage extends StatefulWidget {
//   const SignUpPage({Key? key}) : super(key: key);
//
//   @override
//   _SignUpPageState createState() => _SignUpPageState();
// }
//
// class _SignUpPageState extends State<SignUpPage> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _controllerName = TextEditingController();
//   final TextEditingController _controllerEmail = TextEditingController();
//   final TextEditingController _controllerPass = TextEditingController();
//   bool _loading = false;
//
//   void update(String text) {
//     setState(() {
//       _loading = false;
//     });
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
//   }
//
//   @override
//   void dispose() {
//     _controllerName.dispose();
//     _controllerEmail.dispose();
//     _controllerPass.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Register'),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20.0),
//         child: Card(
//           elevation: 5,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   TextFormField(
//                     validator: (value) =>
//                     (value == null || value.isEmpty) ? 'Please fill Name' : null,
//                     controller: _controllerName,
//                     decoration: const InputDecoration(
//                       labelText: 'Name',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   TextFormField(
//                     validator: (value) =>
//                     (value == null || value.isEmpty) ? 'Please fill Email' : null,
//                     controller: _controllerEmail,
//                     keyboardType: TextInputType.emailAddress,
//                     decoration: const InputDecoration(
//                       labelText: 'Email',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   TextFormField(
//                     validator: (value) =>
//                     (value == null || value.isEmpty) ? 'Please fill Password' : null,
//                     controller: _controllerPass,
//                     obscureText: true,
//                     decoration: const InputDecoration(
//                       labelText: 'Password',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: ElevatedButton(
//           onPressed: () {
//             if (_formKey.currentState!.validate()) {
//               setState(() {
//                 _loading = true;
//               });
//               saveUser(
//                 update,
//                 _controllerName.text,
//                 _controllerEmail.text,
//                 _controllerPass.text,
//               );
//             }
//           },
//           child: _loading
//               ? const CircularProgressIndicator(
//             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//           )
//               : const Text('Sign Up'),
//         ),
//       ),
//     );
//   }
// }
// void saveUser(Function(String) update, String name, String email, String password) async {
//   try {
//     final url = Uri.https(baseURL, 'signup.php');
//     final response = await http
//         .post(url,
//         headers: <String, String>{
//           'content-type': 'application/json; charset=UTF-8'
//         },
//         body: convert.jsonEncode(<String, String>{
//           'name': name,
//           'email': email,
//           'key': 'your_key'
//         }))
//         .timeout(const Duration(seconds: 5));
//     if (response.statusCode == 200) {
//       update(response.body);
//     }
//   } catch (e) {
//     update(e.toString());
//   }
// }
//
// class LoginPage extends StatelessWidget {
//   const LoginPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login'),
//         centerTitle: true,
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(20.0),
//               child: Card(
//                 elevation: 5,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       TextFormField(
//                         decoration: const InputDecoration(
//                           labelText: 'Name',
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       TextFormField(
//                         keyboardType: TextInputType.emailAddress,
//                         decoration: const InputDecoration(
//                           labelText: 'Email',
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       TextFormField(
//                         obscureText: true,
//                         decoration: const InputDecoration(
//                           labelText: 'Password',
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//
//                   },
//                   child: const Text('Sign In'),
//                 ),
//                 const SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.pushNamed(context, '/signup');
//                   },
//                   style: ButtonStyle(
//                     minimumSize: MaterialStateProperty.all(const Size(150, 50)),
//                     padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
//                   ),
//                   child: const Text('Sign Up'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: DefaultTabController(
//         length: 2,
//         child: Scaffold(
//           appBar: AppBar(
//             title: Text('Login & Signup'),
//             bottom: TabBar(
//               tabs: [
//                 Tab(text: 'Login'),
//                 Tab(text: 'Signup'),
//               ],
//             ),
//           ),
//           body: TabBarView(
//             children: [
//               LoginCard(),
//               SignUpCard(),
//             ],
//           ),
//         ),
//       ),
//     initialRoute: '/',
//     routes: {
//       '/': (context) => const LoginCard(),
//       '/signup': (context) => const SignUpCard(),
//       '/homepage': (context) => const Home(),
//     }
//     );
//   }
// }
//
// class SignUpCard extends StatefulWidget {
//   const SignUpCard({super.key});
//
//   @override
//   State<SignUpCard> createState() => _SignUpCardState();
// }
//
// class _SignUpCardState extends State<SignUpCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Card(
//         margin: EdgeInsets.all(20.0),
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               TextField(
//                 decoration: InputDecoration(labelText: 'Full Name'),
//               ),
//               SizedBox(height: 10),
//               TextField(
//                 decoration: InputDecoration(labelText: 'Email'),
//               ),
//               SizedBox(height: 10),
//               TextField(
//                 decoration: InputDecoration(labelText: 'Password'),
//                 obscureText: true,
//               ),
//               SizedBox(height: 10),
//               TextField(
//                 decoration: InputDecoration(labelText: 'Confirm Password'),
//                 obscureText: true,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   void saveUser(Function(String) update, String name,
//                       String email, String password, String ConfirmPass) async {
//                     try {
//                       final url = Uri.https(baseURL, 'signup.php');
//                       final response = await http
//                           .post(url,
//                               headers: <String, String>{
//                                 'content-type':
//                                     'application/json; charset=UTF-8'
//                               },
//                               body: convert.jsonEncode(<String, String>{
//                                 'name': name,
//                                 'email': email,
//                                 'key': 'your_key'
//                               }))
//                           .timeout(const Duration(seconds: 5));
//                       if (response.statusCode == 200) {
//                         update(response.body);
//                       }
//                     } catch (e) {
//                       update(e.toString());
//                     }
//                   }
//                 },
//                 child: Text('Signup'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// @override
// Widget build(BuildContext context) {
//   return Center(
//     child: Card(
//       margin: EdgeInsets.all(20.0),
//       child: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             TextField(
//               decoration: InputDecoration(labelText: 'Email'),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Handle login logic here
//               },
//               child: Text('Login'),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
//
// class LoginCard extends StatefulWidget {
//   const LoginCard({super.key});
//
//   @override
//   State<LoginCard> createState() => _LoginCardState();
// }
//
// class _LoginCardState extends State<LoginCard> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _controllerEmail = TextEditingController();
//   final TextEditingController _controllerPass = TextEditingController();
//   bool _loading = false;
//   bool loggedIn = false;
//   void updateLoggedIn() {
//     loggedIn = true;
//   }
//
//   void update(String text) {
//     setState(() {
//       _loading = false;
//     });
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
//     if (loggedIn) {
//       Navigator.pushNamed(context, '/home');
//     }
//   }
//
//   @override
//   void dispose() {
//     _controllerEmail.dispose();
//     _controllerPass.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Card(
//         margin: EdgeInsets.all(20.0),
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               TextField(
//                 decoration: InputDecoration(labelText: 'Email'),
//               ),
//               SizedBox(height: 10),
//               TextField(
//                 decoration: InputDecoration(labelText: 'Password'),
//                 obscureText: true,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   LoginUser(update,_controllerEmail.text,
//                       _controllerPass.text,updateLoggedIn);
//                 },
//                 child: const Text('Sign In'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// void LoginUser(Function(String) update,String email, String password,Function() updateLoggedIn) async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//
//   try {
//     final url = Uri.https(baseURL, '/api/Mobile/login.php');
//     final response = await http
//         .post(url,
//         headers: <String, String>{
//           'content-type': 'application/json; charset=UTF-8'
//         },
//         body: convert.jsonEncode(<String, String>{
//           'Email': email,
//           'Password':password,
//           'Key': 'your_key'
//         }))
//         .timeout(const Duration(seconds: 20));
//     if (response.statusCode == 200) {
//
//       Map<String, dynamic> responseData = convert.jsonDecode(response.body);
//       String userId = responseData['userID'].toString();
//       prefs.setString('userId', userId);
//
//       updateLoggedIn();
//       update(response.body);
//     }
//   } catch (e) {
//     update(e.toString());
//   }
// }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Login & Signup'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Login'),
                Tab(text: 'Signup'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              LoginCard(),
              SignUpCard(),
            ],
          ),
        ),
      ),
    );
  }
}