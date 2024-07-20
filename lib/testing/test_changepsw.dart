import 'package:flutter/material.dart';
import 'package:socialapp/testing/test_auth.dart';
import 'package:socialapp/testing/test_dataloader.dart';
// import 'package:socialapp/auth.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  late Auth auth;

  @override
  void initState() {
    super.initState();
    auth = Auth(Dataloader());
  }

  void _changePassword() async {
    bool isSuccess = await auth.changePassword(oldPasswordController.text, newPasswordController.text);

    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password Changed")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to change password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Change Password")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: oldPasswordController, decoration: InputDecoration(labelText: 'Old Password'), obscureText: true),
            TextField(controller: newPasswordController, decoration: InputDecoration(labelText: 'New Password'), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _changePassword, child: Text("Change Password")),
          ],
        ),
      ),
    );
  }
}
