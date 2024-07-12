import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/datastorage.dart';
import 'package:socialapp/models/user.dart';
import 'package:socialapp/models/user_detail.dart';

class Profile extends StatefulWidget {
  final User user;
  final UserDetail userDetail;
  const Profile({super.key, required this.user, required this.userDetail});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Title'),
      ),
      body: Column(
        children: [
          Text('Name: ${widget.user.name}'),
          Text('Image: ${widget.userDetail.coverImage!.imagePath}')
        ],
      ),
    );
  }
}
