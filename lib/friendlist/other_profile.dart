import 'dart:io';

import 'package:flutter/material.dart';
import 'package:socialapp/models/user_detail.dart';
import 'package:socialapp/models/user_post.dart';
import 'package:socialapp/profiles/image_full.dart';

class OtherProfiles extends StatefulWidget {
  final UserDetail userDetail;
  final List<UserPost> userpost;
  const OtherProfiles(
      {super.key, required this.userDetail, required this.userpost});

  @override
  State<OtherProfiles> createState() => _OtherProfilesState();
}

class _OtherProfilesState extends State<OtherProfiles> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.userDetail.basicInfo!.name}'s profile"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 230,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: GestureDetector(
                        onTap: () {
                          (widget.userDetail.coverImage?.isNetworkUrl ?? false)
                              ?
                              // print('open pcitrue');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ImageFull(
                                      networkurl: widget
                                          .userDetail.coverImage!.imagepath!,
                                      text: 'Cover picture',
                                    ), //here i passed the userdetail used to display the current logged profile detail
                                  ),
                                )
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ImageFull(
                                      text: 'Cover Picture',
                                      imagefile: File(widget
                                          .userDetail.coverImage!.imagepath!),
                                    ),
                                  ));
                        },
                        child: (widget.userDetail.coverImage?.isNetworkUrl ??
                                false)
                            ? Image.network(
                                widget.userDetail.coverImage!.imagepath!)
                            : Image.file(File(
                                widget.userDetail.coverImage!.imagepath!))),
                  ),
                  Positioned(
                    left: 5,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () {
                        (widget.userDetail.profileImage?.isNetworkUrl ?? false)
                            ?
                            // print('open pcitrue');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageFull(
                                    networkurl: widget
                                        .userDetail.profileImage!.imagePath,
                                    text: 'Profile picture',
                                  ), //here i passed the userdetail used to display the current logged profile detail
                                ),
                              )
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageFull(
                                    text: 'Profile Picture',
                                    imagefile: File(widget
                                        .userDetail.profileImage!.imagePath!),
                                  ),
                                ));
                      },
                      child: (widget.userDetail.profileImage?.isNetworkUrl ??
                              false)
                          ? CircleAvatar(
                              radius: 80,
                              backgroundImage: NetworkImage(
                                  widget.userDetail.profileImage!.imagePath!),
                            )
                          : CircleAvatar(
                              radius: 80,
                              backgroundImage: FileImage(
                                File(
                                    widget.userDetail.profileImage?.imagePath ??
                                        ''),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.userDetail.basicInfo?.name ?? '',
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(),
                  Text(
                    widget.userDetail.basicInfo?.summary ?? '',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Divider(),
                  ListView.separated(
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.userpost.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: (widget.userDetail!.profileImage
                                        ?.isNetworkUrl ??
                                    false) //this place the value that can have a value false if it is null
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(widget
                                        .userDetail!.profileImage!.imagePath!),
                                  )
                                : CircleAvatar(
                                    backgroundImage: FileImage(File(widget
                                            .userDetail!
                                            .profileImage
                                            ?.imagePath ??
                                        '')),
                                  ),
                            title: Text(widget.userDetail!.basicInfo!.name!),
                            // subtitle: Text(userlist[indexfinder].email!),
                          ),
                          Text(widget.userpost[index].title!),
                          // Text(userpost[index].description!),
                          Card(
                            elevation: 5,
                            child: _builderimage(
                              widget.userpost[index].image!,
                              widget.userDetail,
                              widget.userpost[index],
                              // userlist[index],
                            ),
                          ), //here with list<postedphot> i passed userdetail userpost[index] also
                          // Text('${userpost[index].image!.length}'),
                          // for (var image in userpost[index].image!) _builderimage(image),
                          Text(widget.userpost[index].createdAt.toString()),
                          Container(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // IconButton(
                                //   // enableFeedback: true,
                                //   tooltip: 'Like',
                                //   onPressed: () {
                                //     setState(() {
                                //       widget.userpost[index].isliked =
                                //           !widget.userpost[index].isliked;
                                //       if (widget.userpost[index].isliked) {
                                //         ScaffoldMessenger.of(context)
                                //             .showSnackBar(const SnackBar(
                                //                 duration: Duration(seconds: 1),
                                //                 content:
                                //                     Text('Liked the post')));
                                //       }
                                //     });
                                //   },
                                //   icon: widget.userpost[index].isliked
                                //       ? const Icon(Icons.thumb_up_alt)
                                //       : const Icon(Icons.thumb_up_alt_outlined),
                                // ),
                                // IconButton(
                                //   tooltip: 'Dislike',
                                //   onPressed: () {
                                //     setState(() {
                                //       widget.userpost[index].isDisliked =
                                //           !widget.userpost[index].isDisliked;
                                //       if (widget.userpost[index].isDisliked) {
                                //         widget.userpost[index].isliked = false;
                                //         ScaffoldMessenger.of(context)
                                //             .showSnackBar(const SnackBar(
                                //                 duration: Duration(seconds: 1),
                                //                 content:
                                //                     Text('Disliked the post')));
                                //       }
                                //     });
                                //   },
                                //   icon: widget.userpost[index].isDisliked
                                //       ? const Icon(Icons.thumb_down_alt)
                                //       : const Icon(
                                //           Icons.thumb_down_alt_outlined),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  )

                  //friendlist
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _builderimage(
      List<Postedphoto> image, UserDetail detail, UserPost userpost
      // User user
      ) {
    int remainimages =
        image.length - 3; //remaining after 3 images foe the stack
    //if only one image
    if (image.length == 1) {
      if (userpost.postId! > 10) {
        return GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageFull(
                    imagefile: File(image[0].url!),
                    text: 'Pictures',
                  ),
                )),
            child: Image.file(File(image[0].url!)));
      } else {
        return Image.network(image[0].url!);
      }
      // return (image[0].isNetworkurl = false)
      //     ? Image.network(image[0].url!)
      //     : Image.file(
      //         File(image[0].url!),
      //         height: 400,
      //         width: double.infinity,
      //         fit: BoxFit.fill,
      //       );
      // return Image.network(
      //   image[0].url!,
      //   // width: double.infinity,
      // );
    } else if (image.length == 3) {
      return Column(
        children: [
          //this is if there is 3 photo
          GestureDetector(
            // onTap: () => Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => FullImageScreen(
            //           images: image, detail: detail, user: user!),
            //     )),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              children: [
                (userpost.postId! > 10)
                    ? Image.file(
                        File(image[0].url!),
                        fit: BoxFit.fill,
                      )
                    : Image.network(image[0].url!),
                //
                (userpost.postId! > 10)
                    ? Image.file(
                        File(image[1].url!),
                        fit: BoxFit.fill,
                      )
                    : Image.network(image[1].url!),
                // (image[0].isNetworkurl)
                //     ? Image.network(
                //         image[0].url!,
                //       )
                //
                // (image[1].isNetworkurl ?? false)
                //     ? Image.network(image[1].url!)
                //     : Image.file(
                //         File(image[1].url!),
                //         fit: BoxFit.fill,
                //       ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          (userpost.postId! > 10) //bool comes null
              ? Image.file(
                  (File(image[2].url!)),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.fill,
                )
              : Image.network(image[2].url!)
          // Image.network(
          //   image[2].url!,
          // )
        ],
      );
    }
//if there are more than 3 photos
    return GestureDetector(
      // onTap: () => Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) =>
      //           FullImageScreen(images: image, detail: detail, user: user),
      //     )),
      child: GridView.builder(
        shrinkWrap: true, //allows widget to adjust it's size with content
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            // childAspectRatio: 1,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2),

        itemCount: image.length > 3 ? 4 : image.length,
        //if the image lenth is more than 3 the value is set to 4 , but if less then the vakue is set to image.length
        itemBuilder: (context, index) {
          if (index == 3 && remainimages > 0) {
            //this condition makes the +X for image display
            return Stack(
              fit: StackFit.expand,
              children: [
                (userpost.postId! > 10)
                    ? Image.file(File(image[index].url!))
                    : Image.network(image[index].url!),
                // Image.network(
                //   image[index].url!,
                //   fit: BoxFit.cover,
                // ),
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Text(
                      '+$remainimages',
                      style: const TextStyle(color: Colors.grey, fontSize: 25),
                    ),
                  ),
                )
              ],
            );
          } else {
            return (userpost.postId! > 10)
                ? Image.file(File(image[index].url!))
                : Image.network(image[index].url!);
          }
        },
      ),
    );
    // return Image.network(
    //   // width: 390,
    //   image.url!,
    //   // fit: BoxFit.fitWidth,
    //   // cacheHeight: 200,
    //   // cacheWidth: 200,
    // );
  }
}
