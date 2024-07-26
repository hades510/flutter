// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:socialapp/models/user_detail.dart';

// class FullProfilePic extends StatelessWidget {
//   final UserDetail detail;
//   const FullProfilePic({super.key, required this.detail});

//   //decoding

//   @override
//   Widget build(BuildContext context) {
//     Uint8List imagesbytes = base64Decode(detail.profileImage!.imagePath!);
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: const Text("Profile picture"),
//       ),
//       body: Center(
//         child: Image.memory(imagesbytes),
//       ),
//     );
//   }
// }

//file
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullProfilePic extends StatelessWidget {
  final File imagefile;
  const FullProfilePic({super.key, required this.imagefile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Profile picture'),
      ),
      body: Center(
        child: 
            InteractiveViewer(
              child: Image.file(imagefile))
            
      ),
    );
  }
}
