import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/authenthication/login_auth.dart';
import 'package:socialapp/dataloader.dart';
import 'package:socialapp/models/user.dart';
import 'package:socialapp/models/user_detail.dart';
import 'package:socialapp/models/user_post.dart';

class FullImageScreen extends StatefulWidget {
  final List<Postedphoto> images;
  UserDetail? detail;
  User? user;
  UserPost? post;

  FullImageScreen({
    super.key,
    required this.images,
    this.detail,
    this.user,
    this.post,
  });

  @override
  State<FullImageScreen> createState() => _FullImageScreenState();
}

class _FullImageScreenState extends State<FullImageScreen> {
  late Auth auth;
  List<UserPost> userpost = [];

  @override
  void initState() {
    super.initState();
    auth = Auth(Dataloader());
    _loadUserDetail();
    _loadUserPost();
  }

  Future<void> _loadUserDetail() async {
    UserDetail? userDetail = await auth.getloggedinuser();
    setState(() {
      widget.detail = userDetail;
    });
  }

  Future<void> _loadUserPost() async {
    final prefs = await SharedPreferences.getInstance();
    String? postJson = prefs.getString(Dataloader.userpostkey);
    Dataloader dataloader = Dataloader();

    if (postJson != null) {
      List postList = jsonDecode(postJson);
      List<UserPost> posts = postList.map((e) => UserPost.fromJson(e)).toList();

      setState(() {
        userpost = posts;
      });
    }
  }

  Future<void> _updateImageLikeDislike(
      int postId, int imageId, bool isLiked, bool isDisliked) async {
    final prefs = await SharedPreferences.getInstance();
    String? postJson = prefs.getString(Dataloader.userpostkey);

    if (postJson != null) {
      List postList = jsonDecode(postJson);
      List<UserPost> posts = postList.map((e) => UserPost.fromJson(e)).toList();

      UserPost? postToUpdate =
          posts.firstWhere((post) => post.postId == postId);

      if (postToUpdate != null) {
        Postedphoto? imageToUpdate =
            postToUpdate.image?.firstWhere((image) => image.id == imageId);

        if (imageToUpdate != null) {
          setState(() {
            if (isLiked) {
              imageToUpdate.isLiked = true;
              imageToUpdate.likeCount = (imageToUpdate.likeCount ?? 0) + 1;

              if (imageToUpdate.isDisliked ?? false) {
                imageToUpdate.isDisliked = false;
                imageToUpdate.likeCount = (imageToUpdate.likeCount ?? 0) + 1;
              }
            } else {
              if (imageToUpdate.isLiked ?? false) {
                imageToUpdate.isLiked = false;
                imageToUpdate.likeCount = (imageToUpdate.likeCount ?? 0) - 1;
              }
            }

            if (isDisliked) {
              if (imageToUpdate.isLiked ?? false) {
                imageToUpdate.isLiked = false;
                imageToUpdate.likeCount = (imageToUpdate.likeCount ?? 0) - 1;
              }
              imageToUpdate.isDisliked = true;
              imageToUpdate.likeCount = (imageToUpdate.likeCount ?? 0) - 1;
            }
          });

          // Convert the updated posts back to JSON
          String updatedPostsJson =
              jsonEncode(posts.map((post) => post.toJson()).toList());
          await prefs.setString(Dataloader.userpostkey, updatedPostsJson);
        }
      }
    }
  }

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
              leading: (widget.detail?.profileImage?.isNetworkUrl ?? false)
                  ? CircleAvatar(
                      backgroundImage:
                          NetworkImage(widget.detail!.profileImage!.imagePath!),
                    )
                  : CircleAvatar(
                      backgroundImage: FileImage(
                          File(widget.detail!.profileImage!.imagePath!)),
                    ),
              title: Text(widget.detail!.basicInfo!.name!),
              subtitle: Text(widget.user?.email ?? ''),
            ),
            SizedBox(
              height: 700,
              child: ListView.builder(
                itemCount: widget.images.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      (widget.post!.postId! > 10)
                          ? Image.file(File(widget.post!.image![index].url!))
                          : Image.network(widget.post!.image![index].url!),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            tooltip: 'Like Image',
                            onPressed: () async {
                              setState(() {
                                if (userpost[index].image![index].isLiked ??
                                    false) {
                                  userpost[index].image![index].isLiked = false;
                                  userpost[index].image![index].likeCount =
                                      (userpost[index]
                                                  .image![index]
                                                  .likeCount ??
                                              0) -
                                          1;
                                } else {
                                  userpost[index].image![index].isLiked = true;
                                  userpost[index].image![index].isDisliked =
                                      false;
                                  userpost[index].image![index].likeCount =
                                      (userpost[index]
                                                  .image![index]
                                                  .likeCount ??
                                              0) +
                                          1;
                                }
                              });
                              await _updateImageLikeDislike(
                                widget.post!.postId!,
                                userpost[index].image![index].id!,
                                !(userpost[index].image![index].isLiked ??
                                    false),
                                userpost[index].image![index].isDisliked ??
                                    false,
                              );
                            },
                            icon: userpost[index].image![index].isLiked == true
                                ? const Icon(Icons.thumb_up_alt)
                                : const Icon(Icons.thumb_up_alt_outlined),
                          ),
                          IconButton(
                            tooltip: 'Dislike Image',
                            onPressed: () async {
                              setState(() {
                                if (userpost[index].image![index].isDisliked ??
                                    false) {
                                  userpost[index].image![index].isDisliked =
                                      false;
                                  userpost[index].image![index].likeCount =
                                      (userpost[index]
                                                  .image![index]
                                                  .likeCount ??
                                              0) +
                                          1;
                                } else {
                                  userpost[index].image![index].isDisliked =
                                      true;
                                  userpost[index].image![index].isLiked = false;
                                  userpost[index].image![index].likeCount =
                                      (userpost[index]
                                                  .image![index]
                                                  .likeCount ??
                                              0) -
                                          1;
                                }
                              });
                              await _updateImageLikeDislike(
                                widget.post!.postId!,
                                userpost[index].image![index].id!,
                                false,
                                !(userpost[index].image![index].isDisliked ??
                                    false),
                              );
                            },
                            icon:
                                userpost[index].image![index].isDisliked == true
                                    ? const Icon(Icons.thumb_down_alt)
                                    : const Icon(Icons.thumb_down_alt_outlined),
                          ),
                          Text(
                              'Likes ${userpost[index].image![index].likeCount ?? 0}'),
                        ],
                      ),
                    ],
                  );
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
        (widget.post!.postId! > 10)
            ? Image.file(File(image.url!))
            : Image.network(image.url!),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              tooltip: 'Like Image',
              onPressed: () async {
                setState(() {
                  if (image.isLiked ?? false) {
                    image.isLiked = false;
                    image.likeCount = (image.likeCount ?? 0) - 1;
                  } else {
                    image.isLiked = true;
                    image.isDisliked = false;
                    image.likeCount = (image.likeCount ?? 0) + 1;
                  }
                });
                await _updateImageLikeDislike(
                  widget.post!.postId!,
                  image.id!,
                  !(image.isLiked ?? false),
                  image.isDisliked ?? false,
                );
              },
              icon: image.isLiked == true
                  ? const Icon(Icons.thumb_up_alt)
                  : const Icon(Icons.thumb_up_alt_outlined),
            ),
            IconButton(
              tooltip: 'Dislike Image',
              onPressed: () async {
                setState(() {
                  if (image.isDisliked ?? false) {
                    image.isDisliked = false;
                    image.likeCount = (image.likeCount ?? 0) + 1;
                  } else {
                    image.isDisliked = true;
                    image.isLiked = false;
                    image.likeCount = (image.likeCount ?? 0) - 1;
                  }
                });
                await _updateImageLikeDislike(
                  widget.post!.postId!,
                  image.id!,
                  false,
                  !(image.isDisliked ?? false),
                );
              },
              icon: image.isDisliked == true
                  ? const Icon(Icons.thumb_down_alt)
                  : const Icon(Icons.thumb_down_alt_outlined),
            ),
            Text('Likes ${image.likeCount ?? 0}'),
          ],
        ),
      ],
    );
  }
}
