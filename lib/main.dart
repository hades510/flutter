import 'package:flutter/material.dart';
import 'package:socialapp/dataloader.dart';
import 'package:socialapp/loginregister.dart';

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
      home: LoginRegister(),
    );
  }
}
