

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/testing/test_auth.dart';
import 'package:socialapp/testing/test_changepsw.dart';
import 'package:socialapp/testing/test_login.dart';
import 'package:socialapp/testing/test_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences and check login status
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? loggedInUser = prefs.getString(Auth.isUserloggedin);

  runApp(App(loggedInUser: loggedInUser));
}

class App extends StatelessWidget {
  final String? loggedInUser;

  const App({super.key, this.loggedInUser});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Decide which screen to show based on authentication status
      home: loggedInUser == null ? const LoginPage() : ProfilePage(),
      routes: {
        // '/home': (context) => Home(),
        // '/profile': (context) => ViewProfile(),
        '/change-password': (context) => ChangePasswordPage(),
      },
    );
  }
}
