import 'dart:io';

import 'package:flutter/material.dart';

import '../models/user.dart';
import '../models/user_detail.dart';
import '../models/user_post.dart';

class FullImageScreen extends StatefulWidget {
  final List<Postedphoto> images;
  final UserDetail detail;
  final User user;
  const FullImageScreen(
      {super.key,
      required this.images,
      required this.detail,
      required this.user});

  @override
  State<FullImageScreen> createState() => _FullImageScreenState();
}

class _FullImageScreenState extends State<FullImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Photos'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: (widget.detail.profileImage?.isNetworkUrl ?? false)
                  ? CircleAvatar(
                      backgroundImage:
                          NetworkImage(widget.detail.profileImage!.imagePath!),
                    )
                  : CircleAvatar(
                      backgroundImage: FileImage(
                          File(widget.detail.profileImage!.imagePath!)),
                    ),
              title: Text(widget.detail.basicInfo!.name!),
              subtitle: Text(widget.user.email!),
            ),
            SizedBox(
              height: 700,
              child: ListView.builder(
                itemCount: widget.images.length,
                itemBuilder: (context, index) {
                  return _buildImageTile(widget.images[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageTile(Postedphoto image) {
    return Column(
      children: [
        Image.network(image.url!),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  image.isLiked = !image.isLiked;
                  if (image.isLiked && !image.isDisliked) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      duration: Duration(seconds: 1),
                      content: Text('Liked the post'),
                    ));
                  }
                  if (image.isDisliked) {
                    image.isDisliked = false;
                  }
                });
              },
              icon: image.isLiked
                  ? const Icon(Icons.thumb_up_alt)
                  : const Icon(Icons.thumb_up_alt_outlined),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  image.isDisliked = !image.isDisliked;
                  if (image.isDisliked && !image.isLiked) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      duration: Duration(seconds: 1),
                      content: Text('Disliked the post'),
                    ));
                  }
                  if (image.isLiked) {
                    image.isLiked = false;
                  }
                });
              },
              icon: image.isDisliked
                  ? const Icon(Icons.thumb_down_alt)
                  : const Icon(Icons.thumb_down_alt_outlined),
            ),
          ],
        ),
      ],
    );
  }
}

