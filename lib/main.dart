
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/change_psw.dart';
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
      home: const Splash(),
      // initialRoute: loggedInUser == null ? '/' : '/slpash',
      // routes: {
      //   '/': (context) => const LoginPage(),
      //   '/slpash': (context) => const Splash(),
        
      //   // '/home': (context) => const Home(),
      //   // '/profile': (context) => const ViewProfile(),
      //   // '/change-password': (context) => const ChangePsw(),
      // },
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