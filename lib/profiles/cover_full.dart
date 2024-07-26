import 'dart:io';

import 'package:flutter/material.dart';

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
      body: Center(child: InteractiveViewer(child: Image.file(imagepath))),
    );
  }
}
