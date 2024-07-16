import 'package:flutter/material.dart';
import 'package:socialapp/dataloader.dart';
import 'package:socialapp/home.dart';
import 'package:socialapp/login.dart';
import 'package:socialapp/loginregister.dart';
import 'package:socialapp/feeds/newsfeed.dart';
import 'package:socialapp/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Dataloader dataloader = Dataloader();
  await dataloader.loaduser();
  // await dataloader.loaddetail();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      home: Splash(),
      // Newsfeed(),
      //  LoginRegister(),
    );
  }
}
