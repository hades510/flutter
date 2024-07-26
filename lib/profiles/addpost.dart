import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialapp/authenthication/login_auth.dart';
import 'package:socialapp/dataloader.dart';
import 'package:socialapp/models/user.dart';
import 'package:socialapp/models/user_detail.dart';

class AddPost extends StatefulWidget {
  const AddPost({
    super.key,
  });

  @override
  State<AddPost> createState() => _AddPostState();
}

UserDetail? userDetail;
User? user;
final ImagePicker picker = ImagePicker();
List<File> media = []; // list to store the selected media
File? camera_image;

late Auth auth;
//for images/video
// int remainmedia = media!.length -3;

class _AddPostState extends State<AddPost> {
  @override
  void initState() {
    super.initState();
    auth = Auth(Dataloader());
    _loaduserDetail(); //to get the data of from the user detail always load tha da
  }

  void _loaduserDetail() async {
    UserDetail? detail = await auth.getloggedinuser();
    setState(() {
      userDetail = detail;
      //createing different method to handle images
    });
  }

  TextEditingController writepost = TextEditingController();

  Future<bool> _onWillPop() async {
    // Show a dialog or pop-up when the user tries to navigate back
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Discard Changes?'),
            content:
                const Text('Are you sure you want to discard your changes?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop(false); // User does not want to go back
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // User wants to go back
                },
                child: const Text('Discard'),
              ),
            ],
          ),
        )) ??
        false; // Default to not pop if dialog is dismissed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Create Post'),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.black),
              onPressed: () {},
              child: const Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) {
            return;
          }
          final bool shouldpop = await _onWillPop() ?? false;
          if (context.mounted && shouldpop) {
            Navigator.pop(context);
            media.clear();
            camera_image = null;
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                leading: (userDetail!.profileImage?.isNetworkUrl ??
                        false) //this place the value that can have a value false if it is null
                    ? CircleAvatar(
                        backgroundImage:
                            NetworkImage(userDetail!.profileImage!.imagePath!),
                      )
                    : CircleAvatar(
                        radius: 20,
                        backgroundImage: FileImage(
                            File(userDetail!.profileImage?.imagePath ?? '')),
                      ),
                title: Text(userDetail!.basicInfo!.name!),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  height: 400,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: const Color.fromARGB(255, 246, 242, 242),
                          width: 5)
                      // color: Colors.amber
                      ),
                  child: TextField(
                    controller: writepost,
                    maxLines: 15,
                    minLines: 1,
                    decoration: const InputDecoration(
                      labelText: "What's on your mind?",
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      // enabledBorder: OutlineInputBorder(),
                      // focusedBorder: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              const Divider(),
              _viewImage(
                  media), //have pushed the camera and selected photos here
              // camera_image != null
              //     ? Image.file(camera_image!)
              //     : const Divider(),
              Container(
                decoration: BoxDecoration(
                    // border: Border.all(),
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  onTap: () async {
                    final pickedmedia = await picker.pickMultiImage();
                    setState(() {
                      if (pickedmedia != null) {
                        for (var files in pickedmedia) {
                          media.add(File(files
                              .path)); //here files.path gives the path of the files in STring
                        }
                      }
                    });
                  },
                  leading: const Icon(Icons.add_photo_alternate_sharp),
                  title: const Text('Photos'),
                ),
              ),
              const Divider(
                height: 0,
              ),
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  onTap: () async {
                    final pickedimge =
                        await picker.pickImage(source: ImageSource.camera);
                    setState(() {
                      if (pickedimge != null) {
                        camera_image = File(pickedimge.path);
                        media.add(camera_image!);
                      }
                    });
                  },
                  leading: const Icon(Icons.camera),
                  title: const Text('Camera'),
                ),
              ),
              const Divider(
                height: 0,
              ),
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.videocam_outlined),
                  title: const Text('Videos'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

//handle videos here using endsWith('.mp4')
//need to use the video_player package
  Widget _viewImage(List<File> media) {
    int remainMedia = media.length - 3;
    //
    if (media.length == 1) {
      return Image.file(media[0]);
      //
    } else if (media.length == 3) {
      return Column(children: [
        GridView.builder(
          itemCount: media.length - 1,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 5,
            crossAxisSpacing: 2,
          ),
          itemBuilder: (context, index) {
            return Container(
                decoration: const BoxDecoration(
                    border: Border(right: BorderSide(width: 0))),
                child: Image.file(media[index]));
          },
        ),
        const Divider(),
        Image.file(
          media[2],
        )
      ]
          // media
          //     .map((file) => Image.file(file))
          //     .toList(), // Converts the list of files into a list of Image widgets
          );
    } else {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: media.length > 3 ? 4 : media.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
        ),
        itemBuilder: (context, index) {
          if (index == 3 && remainMedia > 0) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Image.file(media[index], fit: BoxFit.cover),
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Text(
                      '+$remainMedia',
                      style: const TextStyle(color: Colors.grey, fontSize: 25),
                    ),
                  ),
                )
              ],
            );
          } else {
            return Image.file(media[index]);
          }
        },
      );
    }
  }
}
