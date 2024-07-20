import 'package:flutter/material.dart';
import 'package:socialapp/models/user_detail.dart';

class FullCoverPic extends StatefulWidget {
  final UserDetail detail;
  const FullCoverPic({super.key,required this.detail});

  @override
  State<FullCoverPic> createState() => _FullCoverPic();
}

class _FullCoverPic extends State<FullCoverPic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Cover picture"),
      ),
      body: Center(
        child: Image.network(widget.detail.coverImage!.imagepath!,),),
    );
  }
}
