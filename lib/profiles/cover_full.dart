import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:socialapp/models/user_detail.dart';

class FullCoverPic extends StatelessWidget {
  final File imagepath;
  const FullCoverPic({super.key, required this.imagepath});

  @override
  Widget build(BuildContext context) {
    //decoding
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Cover picture"),
      ),
      body: Center(child: Image.file(imagepath)),
    );
  }
}
