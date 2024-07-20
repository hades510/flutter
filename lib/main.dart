// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/change_psw.dart';
import 'package:socialapp/home.dart';
// import 'package:socialapp/authenthication/login_auth.dart';
// import 'package:socialapp/dataloader.dart';
// import 'package:socialapp/home.dart';
import 'package:socialapp/login.dart';
// // import 'package:socialapp/loginregister.dart';
// import 'package:socialapp/feeds/newsfeed.dart';
// import 'package:socialapp/models/user_detail.dart';
import 'package:socialapp/splash.dart';
import 'package:socialapp/profiles/view_profile.dart';

import 'authenthication/login_auth.dart';
// import 'package:socialapp/testing/test_auth.dart';
// import 'package:socialapp/testing/test_login.dart';

import 'testing/test_changepsw.dart';
import 'testing/test_profile.dart';

// import 'package:socialapp/view_profile.dart';

void main() async {
  //actual project
  // WidgetsFlutterBinding.ensureInitialized();
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // String? loggedInUser = prefs.getString(Auth.loggedin);
  //
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? loggedInUser = prefs.getString(Auth.isUserloggedin);
  // Dataloader dataloader = Dataloader();
  // final auth = Auth(dataloader);
  // UserDetail? loggedin = await auth.getloggedinuser();

  // await dataloader.loaduser();
  // await dataloader.loaddetail();
  runApp(App(loggedInUser: loggedInUser));
}

class App extends StatelessWidget {
  // final UserDetail? loggedin;
  // final UserDetailModel? loggedin;
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
      // home: const Splash(),
      initialRoute: loggedInUser == null ? '/' : '/slpash',
      routes: {
        '/': (context) => const LoginPage(),
        '/slpash': (context) => const Splash(),
        
        // '/home': (context) => const Home(),
        // '/profile': (context) => const ViewProfile(),
        // '/change-password': (context) => const ChangePsw(),
      },
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     // Dataservice dataservice = Dataservice();
//     // Dataloader dataloader = Dataloader();
//     return const MaterialApp(
//         title: 'Social App',
//         // theme: ThemeData(fontFamily: 'Rosmary'),
//         debugShowCheckedModeBanner: false,
//         home: 
//         // Splash()
        
//         );
//   }
// }
//this checked if logged in is true it will display view page but if it is not ,
        //then it will display profile page

        //  loggedin != null
        //     ? ProfileScreen(authService: AuthService(dataservice))
        //     :
        //     //
        //     // Splash()
        //     LoginScreen()
        // Newsfeed(),
        //  LoginRegister(),