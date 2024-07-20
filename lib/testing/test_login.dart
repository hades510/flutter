import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:socialapp/authenthication/login_auth.dart';
// import 'package:socialapp/models/user.dart';
// import 'package:socialapp/models/user_detail.dart';
// import 'package:socialapp/dataloader.dart';
import 'package:socialapp/testing/test_auth.dart';
import 'package:socialapp/testing/test_dataloader.dart';
import 'package:socialapp/testing/test_profile.dart';
// import 'package:socialapp/auth.dart';
// import 'package:socialapp/profile_page.dart'; // Import profile page

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late Auth auth;

  @override
  void initState() {
    super.initState();
    auth = Auth(Dataloader());
  }

  void _login() async {
    bool isSuccess = await auth.login(emailController.text, passwordController.text);

    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logged In")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: Text("Login")),
          ],
        ),
      ),
    );
  }
}
