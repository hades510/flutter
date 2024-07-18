import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:socialapp/authenthication/login_auth.dart';
import 'package:socialapp/dataloader.dart';
import 'package:socialapp/home.dart';
import 'package:socialapp/login.dart';
import 'package:socialapp/loginregister.dart';
import 'package:socialapp/feeds/newsfeed.dart';
import 'package:socialapp/models/user_detail.dart';
import 'package:socialapp/splash.dart';
import 'package:socialapp/testing/testingprofile.dart';
import 'package:socialapp/testing/testogin.dart';
import 'package:socialapp/testing/testuserdetail.dart';
import 'package:socialapp/view_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Dataservice service = Dataservice();
  final authservice = AuthService(service); //don't know
  // UserDetailModel? loggedin = await authservice.getloggedinuser();
  //actual project
  Dataloader dataloader = Dataloader();
  final auth = Auth(dataloader);
  UserDetail? loggedin = await auth.getloggedinuser();

  // await dataloader.loaduser();
  // await dataloader.loaddetail();
  runApp(App(
    loggedin: loggedin,
  ));
}

class App extends StatelessWidget {
  final UserDetail? loggedin;
  // final UserDetailModel? loggedin;
  const App({super.key, required this.loggedin});

  @override
  Widget build(BuildContext context) {
    // Dataservice dataservice = Dataservice();
    Dataloader dataloader = Dataloader();
    return const MaterialApp(
        title: 'Social App',
        // theme: ThemeData(fontFamily: 'Rosmary'),
        debugShowCheckedModeBanner: false,
        home: Splash()

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
        );
  }
}
