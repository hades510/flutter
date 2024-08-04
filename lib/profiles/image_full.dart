//file
import 'dart:io';

import 'package:flutter/material.dart';

class ImageFull extends StatelessWidget {
  File? imagefile;
  String? networkurl;
  final String text;
  ImageFull({super.key, this.imagefile, required this.text, this.networkurl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(text),
        ),
        body: (imagefile == null)
            ? Center(
                child: InteractiveViewer(child: Image.network(networkurl!)))
            : Center(child: InteractiveViewer(child: Image.file(imagefile!)))
        //  Column(
        //   children: [
        //     Center(
        //       child: InteractiveViewer(
        //           child: Image.file(
        //         imagefile,
        //       )),
        //     ),
        //     Center(
        //       child: InteractiveViewer(
        //           child: Image.network(
        //         networkurl,
        //       )),
        //     )
        //   ],
        // ),
        // body: Center(child: InteractiveViewer(child: Image.file(imagefile),),),
        );
  }
}
