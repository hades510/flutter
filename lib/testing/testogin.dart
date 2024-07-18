import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/testing/testing_model.dart';
import 'package:socialapp/testing/testuserdetail.dart';

import 'testingprofile.dart';

class Dataservice {
  static String userkey = 'users';
  static String userdetailkey = 'uerdetail';
  //fetch load and save user data from json
  Future loaduser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonstring =
        await rootBundle.loadString('assets/jsonfile/user.json');
    prefs.setString(userkey, jsonstring);
    String detailjson =
        await rootBundle.loadString('assets/jsonfile/user_detail.json');
    prefs.setString(userdetailkey, detailjson);
  }

  Future<List<UserModel>> getuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString(userkey);
    if (user != null) {
      List userlist = jsonDecode(user);
      return userlist.map((e) => UserModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<UserDetailModel>> getuserdetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userdetail = prefs.getString(userdetailkey);
    if (userdetail != null) {
      List detaillist = jsonDecode(userdetail);
      return detaillist.map((e) => UserDetailModel.fromJson(e)).toList();
    }
    return [];
  }
}

//

class AuthService {
  static String loggedin = 'logged';
  Dataservice service;
  AuthService(this.service); //don't know

  Future<bool> login(String email, String password) async {
    List<UserModel> users = await service.getuser(); //got user datas
    List<UserDetailModel> userdetail =
        await service.getuserdetail(); //got userdetail datas

    for (/*UserModel*/ var e in users) {
      if (e.email == email && e.password == password) {
        /*UserDetailModel*/ var userdetailmatch = userdetail.firstWhere(
          (element) => element.id == e.id,
        );
        final prefs = await SharedPreferences.getInstance();
        prefs.setString(
            loggedin,
            json.encode(userdetailmatch
                .toJson())); //don't know userdetailmatch toh=json()
        return true;
      }
    }
    return false;
  }

  Future logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(loggedin);
  }

  Future<UserDetailModel?> getloggedinuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userstring = prefs.getString(loggedin);
    if (userstring != null) {
      return UserDetailModel.fromJson(json.decode(userstring));
    }
    return null;
  }
  // Future<bool> logout() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.remove(loggedin);
  //   return true;
  // }
}

// import 'auth_service.dart';
// import 'user_data_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Dataservice _userDataService = Dataservice();
  late AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService(_userDataService);
    _userDataService.loaduser();
  }

  void _login() async {
    bool success = await _authService.login(
      _emailController.text,
      _passwordController.text,
    );
    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ProfileScreen(authService: _authService)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
