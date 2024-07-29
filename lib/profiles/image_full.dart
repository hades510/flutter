//file
import 'dart:io';

import 'package:flutter/material.dart';

class ImageFull extends StatelessWidget {
  final File imagefile;
  final String text;
  const ImageFull({super.key, required this.imagefile, required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(text),
      ),
      body: Center(child: InteractiveViewer(child: Image.file(imagefile))),
    );
  }
}
