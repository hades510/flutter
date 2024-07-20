import 'package:flutter/material.dart';
// import 'package:socialapp/login.dart';
import 'package:socialapp/testing/test_auth.dart';
import 'package:socialapp/testing/test_changepsw.dart';
import 'package:socialapp/testing/test_dataloader.dart';
import 'package:socialapp/testing/test_login.dart';
import 'package:socialapp/testing/test_userdetail_model.dart';
// import 'package:socialapp/auth.dart';
// import 'package:socialapp/models/user_detail.dart';

// import '../authenthication/login_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Auth auth;
  UserDetail? userDetail;

  @override
  void initState() {
    super.initState();
    auth = Auth(Dataloader()); //ensureing dataloader is loaded
    _loadUserDetail();
  }

  void _loadUserDetail() async {
    UserDetail? detail = await auth.getLoggedInUser(); //fetches user details
    print('user Detail: $detail');
    setState(() {
      userDetail = detail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile"),
      ),
      body: userDetail == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name: ${userDetail?.basicInfo?.name ?? 'N/A'}"),
                  // Text("Email: ${userDetail?.basicInfo?.email ?? 'N/A'}"),
                  // Add other fields from UserDetail
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangePasswordPage()),
                      );
                    },
                    child: Text("Change Password"),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        await auth.logout();

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>const LoginPage(),
                            ));
                      },
                      child: const Text('Loginout'))
                ],
              ),
            ),
    );
  }
}
