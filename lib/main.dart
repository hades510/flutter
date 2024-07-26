import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/home.dart';
import 'package:socialapp/splash.dart';

import 'authenthication/login_auth.dart';

void main() async {
  //
  WidgetsFlutterBinding.ensureInitialized();

  // Initializing shared preferences and checking login status
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
      home: loggedInUser == null ? const Home() : const Splash(),
    );
  }
}
