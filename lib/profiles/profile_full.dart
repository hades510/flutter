import 'package:flutter/material.dart';
import 'package:socialapp/models/user_detail.dart';

class FullProfilePic extends StatefulWidget {
  final UserDetail detail;
  const FullProfilePic({super.key, required this.detail});

  @override
  State<FullProfilePic> createState() => _FullProfilePicState();
}

class _FullProfilePicState extends State<FullProfilePic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Profile picture"),
      ),
      body: Center(
        child: Image.network(
          widget.detail.profileImage!.imagePath!,
        ),
      ),
    );
  }
}
