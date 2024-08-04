import 'dart:io';

import 'package:flutter/material.dart';
import 'package:socialapp/dataloader.dart';
import 'package:socialapp/feeds/Albumscreen.dart';
import 'package:socialapp/friendlist/other_profile.dart';
import 'package:socialapp/models/user.dart';
import 'package:socialapp/models/user_detail.dart';
import 'package:socialapp/models/user_friendlist.dart';
import 'package:socialapp/models/user_post.dart';

import '../authenthication/login_auth.dart';

class Newsfeed extends StatefulWidget {
  // final UserPost post;
  // final UserDetail userDetail;
  // final User user;
  // final List<UserPost> userpost;
  const Newsfeed({
    super.key,
    // required this.post, required this.userDetail, required this.user
  });

  @override
  State<Newsfeed> createState() => _HomeState();
}

class _HomeState extends State<Newsfeed> {
  List<UserPost> post = [];
  late Auth auth;
  // UserDetail? userDetail;

  @override
  void initState() {
    super.initState();
    _loaduserpost();
    // _loaduserdetail();
  }

  void _loaduserpost() async {
    Dataloader dataloader = Dataloader();
    List<UserPost> posts = await dataloader.getuserpost();
    setState(() {
      post = posts;
    });
  }

  // void _loaduserdetail() async {
  //   UserDetail? detail = await auth.getloggedinuser();
  //   setState(() {
  //     userDetail = detail;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // User user = User();
    // UserDetail userDetail = UserDetail();
    // UserPost post = UserPost();

    return Scaffold(
      body: FutureBuilder(
        future: _fetchuserpost(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else {
            return Newscreen(
              post: snapshot.data!['posts'], //(fetched the data tin this key)
              user: snapshot.data!['users'],
              userdetail: snapshot.data!['userdetails'],
              // category: snapshot.data!['categories'],
              friend: snapshot.data!['friends'],
              // courses: snapshot.data!['courses'],
              // instructor: snapshot.data!['instructors'],
            );
          }
        },
      ),
    );
  }

  Future _fetchuserpost() async {
    Dataloader dataloader = Dataloader();
//this provides the initial data/updated data not loaded here,
    List<UserPost> posts = await dataloader.getuserpost(); //loaded the data
    List<UserDetail> userdetail = await dataloader.getuserdetail();
    List<User> user = await dataloader.getuser();
    List<UserFriendlist> friend = await dataloader.getfriendlist();

    return {
      'users': user, //(passed the data to this keys)
      'userdetails': userdetail,
      'posts': posts,
      'friends': friend,
      // 'friends': friendlist,
      // 'instructors': instructor,
      // 'courses': courses,
      // 'categories': coursescategory,
    };
  }
}

class Newscreen extends StatefulWidget {
  List<UserPost> post;
  List<User> user;
  List<UserDetail> userdetail;
  List<UserFriendlist> friend;
  // List<Instructor> instructor;
  // List<Courses> courses;
  // List<CourseBy> category;
  // List<User> user;
  // final UserPost userPost;
  Newscreen({
    super.key,
    required this.post,
    required this.user,
    required this.userdetail,
    required this.friend,
    // required this.category,
    // required this.courses,
    // required this.instructor
  });

  @override
  State<Newscreen> createState() => _NewscreenState();
}

class _NewscreenState extends State<Newscreen> {
  UserDetail? userDetail;
  late Auth auth;
  @override
  void initState() {
    super.initState();
    auth = Auth(Dataloader());
    _loaduserpost();
    loaduserdetail(); //need to load on both the classes
  }

  void _loaduserpost() async {
    Dataloader dataloader = Dataloader();
    List<UserPost> posts = await dataloader.getuserpost();
    setState(() {
      widget.post = posts;
    });
  }

  void loaduserdetail() async {
    UserDetail? detail = await auth.getloggedinuser();
    setState(() {
      userDetail = detail;
    });
  }
  // bool model.isDisliked = false;
  // bool model.isDisliked = false;
//for each post use this bools inside the user post model4

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: widget.post.length,
          itemBuilder: (context, index) {
            final post = widget.post[index];
            return _builderpostscreen(post);
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
        ),
      ),
    );
  }

  User getuserid(int userid) {
    return widget.user
        .firstWhere((element) => element.id == userid); //don't know why
  }

  UserDetail getid(int id) {
    return widget.userdetail.firstWhere((element) => element.id == id);
  }

  List<UserPost> getuserpostid(int userid) {
    return widget.post.where((element) => element.userId == userid).toList();
  }

  Widget _builderpostscreen(UserPost model) {
    User users = getuserid(model.userId!);
    UserDetail userdetail = getid(model.userId!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: (userdetail.profileImage?.isNetworkUrl ??
                  false) //this place the value that can have a value false if it is null
              ? CircleAvatar(
                  backgroundImage:
                      NetworkImage(userdetail.profileImage!.imagePath!),
                )
              : CircleAvatar(
                  backgroundImage:
                      FileImage(File(userdetail.profileImage?.imagePath ?? '')),
                ),
          title: Text(userdetail.basicInfo!.name!),
          subtitle: Text(users.email!),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtherProfiles(
                  userDetail: userdetail,
                  userpost: getuserpostid(userdetail.id!),
                ),
              ),
            );
          },
        ),
        // const SizedBox(
        //   height: 8,
        // ),
        Text(model.title!),
        Text(model.description!),
        Card(
          elevation: 5,
          child: _builderimage(model.image!, userdetail, model, users),
        ), //here with list<postedphot> i passed userdetail model also
        // Text('${model.image!.length}'),
        // for (var image in model.image!) _builderimage(image),
        const SizedBox(
          height: 10,
        ),
        Text('Likes ${model.postLikedBy?.length ?? 0}'),
        const Divider(),
        SizedBox(
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  tooltip: 'Like',
                  onPressed: () async {
                    setState(() {
                      if (model.isliked ?? false) {
                        model.isliked = false;
                        model.postLikedBy?.removeWhere(
                            (like) => like.userId == userDetail!.id);
                      } else {
                        model.isliked = true;
                        model.isDisliked = false; // Ensure dislike is false
                        model.postLikedBy ??= [];
                        if (!model.postLikedBy!.any(
                            (element) => element.userId == userDetail!.id)) {
                          model.postLikedBy!.add(PostLikedBy(
                              userId: userDetail!.id,
                              dateTime: DateTime.now().toIso8601String()));
                        }
                      }
                    });
                    await auth.updateReactforPost(
                        model.postId!,
                        model.isliked ?? false,
                        model.isDisliked ?? false,
                        userDetail!.id!);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: Duration(seconds: 1),
                      content: Text(model.isliked ?? false
                          ? 'Liked the post'
                          : 'Unlike the post'),
                    ));
                  },
                  icon: const Icon(Icons.thumb_up_alt_outlined))

              // IconButton(
              //   tooltip: 'Dislike',
              //   onPressed: () async {
              //     setState(() {
              //       if (model.isDisliked ?? false) {
              //         model.isDisliked = false;
              //         model.postLikedBy?.removeWhere(
              //             (like) => like.userId == userDetail!.id);
              //       } else {
              //         model.isDisliked = true;
              //         model.isliked = false;
              //         model.postLikedBy?.removeWhere(
              //             (like) => like.userId == userDetail!.id);
              //       }
              //     });
              //     await auth.updateReactforPost(
              //         model.postId!,
              //         model.isliked ?? false, //can also give false directly
              //         model.isDisliked ?? false,
              //         userDetail!.id!);

              //     ScaffoldMessenger.of(context).showSnackBar(
              //       SnackBar(
              //         duration: const Duration(seconds: 1),
              //         content: Text(
              //             model.isDisliked ?? false ? 'Disliked the Post' : ''),
              //       ),
              //     );
              //   },
              //   icon: model.isDisliked ?? false
              //       ? const Icon(Icons.thumb_down_alt)
              //       : const Icon(Icons.thumb_down_alt_outlined),
              // ),
            ],
          ),
        ),
      ],
    );
  }

//   Widget _builderimage(List<Postedphoto> image, UserDetail detail, User user) {
//     int remainimages =
//         image.length - 3; //remaining after 3 images foe the stack
//     //if only one image
//     if (image.length == 1) {
//       return Image.network(
//         image[0].url!,
//         // width: double.infinity,
//       );
//     } else if (image.length == 3) {
//       return Column(
//         children: [
//           //this is if there is 3 photo
//           GestureDetector(
//             onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => FullImageScreen(
//                       images: image, detail: detail, user: user),
//                 )),
//             child: GridView.count(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               crossAxisCount: 2,
//               mainAxisSpacing: 2,
//               crossAxisSpacing: 2,
//               children: [
//                 Image.network(
//                   image[0].url!,
//                 ),
//                 Image.network(
//                   image[1].url!,
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 1,
//           ),
//           Image.network(
//             image[2].url!,
//           )
//         ],
//       );
//     }
// //if there are more than 3 photos
//     return GestureDetector(
//       onTap: () => Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) =>
//                 FullImageScreen(images: image, detail: detail, user: user),
//           )),
//       child: GridView.builder(
//         shrinkWrap: true, //allows widget to adjust it's size with content
//         physics: const NeverScrollableScrollPhysics(),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             // childAspectRatio: 1,
//             mainAxisSpacing: 2,
//             crossAxisSpacing: 2),

//         itemCount: image.length > 3 ? 4 : image.length,
//         //if the image lenth is more than 3 the value is set to 4 , but if less then the vakue is set to image.length
//         itemBuilder: (context, index) {
//           if (index == 3 && remainimages > 0) {
//             //this condition makes the +X for image display
//             return Stack(
//               fit: StackFit.expand,
//               children: [
//                 Image.network(
//                   image[index].url!,
//                   fit: BoxFit.cover,
//                 ),
//                 Container(
//                   color: Colors.black.withOpacity(0.5),
//                   child: Center(
//                     child: Text(
//                       '+$remainimages',
//                       style: const TextStyle(color: Colors.grey, fontSize: 25),
//                     ),
//                   ),
//                 )
//               ],
//             );
//           } else {
//             return Image.network(
//               image[index].url!,
//               fit: BoxFit.cover,
//             );
//           }
//         },
//       ),
//     );
//     // return Image.network(
//     //   // width: 390,
//     //   image.url!,
//     //   // fit: BoxFit.fitWidth,
//     //   // cacheHeight: 200,
//     //   // cacheWidth: 200,
//     // );
//   }
//   Widget _builderimage(List<Postedphoto> image, UserDetail detail, User user,
//       UserPost userpost) {
//     int remainimages =
//         image.length - 3; //remaining after 3 images foe the stack
//     //if only one image
//     if (image.length == 1) {
//       return (image[0].isNetworkurl ?? false)
//           ? Image.network(image[0].url!)
//           : Image.file(
//               File(image[0].url!),
//               height: 400,
//               width: double.infinity,
//               fit: BoxFit.fill,
//             );
//       // return Image.network(
//       //   image[0].url!,
//       //   // width: double.infinity,
//       // );
//     } else if (image.length == 3) {
//       return Column(
//         children: [
//           //this is if there is 3 photo
//           GestureDetector(
//             onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => FullImageScreen(
//                       images: image, detail: detail, user: user),
//                 )),
//             child: GridView.count(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               crossAxisCount: 2,
//               mainAxisSpacing: 2,
//               crossAxisSpacing: 2,
//               children: [
//                 (image[0].isNetworkurl ?? false)
//                     ? Image.network(
//                         image[0].url!,
//                       )
//                     : Image.file(
//                         File(image[0].url!),
//                         fit: BoxFit.fill,
//                       ),
//                 (image[1].isNetworkurl ?? false)
//                     ? Image.network(image[1].url!)
//                     : Image.file(
//                         File(image[1].url!),
//                         fit: BoxFit.fill,
//                       ),
//                 // Image.network(
//                 //   image[1].url!,
//                 // ),
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           (image[2].isNetworkurl ?? false)
//               ? Image.network(image[2].url!)
//               : Image.file(
//                   (File(image[2].url!)),
//                   height: 200,
//                   width: double.infinity,
//                   fit: BoxFit.fill,
//                 ),
//           // Image.network(
//           //   image[2].url!,
//           // )
//         ],
//       );
//     }
// //if there are more than 3 photos
//     return GestureDetector(
//       onTap: () => Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) =>
//                 FullImageScreen(images: image, detail: detail, user: user),
//           )),
//       child: GridView.builder(
//         shrinkWrap: true, //allows widget to adjust it's size with content
//         physics: const NeverScrollableScrollPhysics(),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             // childAspectRatio: 1,
//             mainAxisSpacing: 2,
//             crossAxisSpacing: 2),

//         itemCount: image.length > 3 ? 4 : image.length,
//         //if the image lenth is more than 3 the value is set to 4 , but if less then the vakue is set to image.length
//         itemBuilder: (context, index) {
//           if (index == 3 && remainimages > 0) {
//             //this condition makes the +X for image display
//             return Stack(
//               fit: StackFit.expand,
//               children: [
//                 image[index].isNetworkurl == true
//                     ? Image.network(image[index].url!)
//                     : Image.file(File(image[index].url!)),
//                 // Image.network(
//                 //   image[index].url!,
//                 //   fit: BoxFit.cover,
//                 // ),
//                 Container(
//                   color: Colors.black.withOpacity(0.5),
//                   child: Center(
//                     child: Text(
//                       '+$remainimages',
//                       style: const TextStyle(color: Colors.grey, fontSize: 25),
//                     ),
//                   ),
//                 )
//               ],
//             );
//           } else {
//             return (image[index].isNetworkurl ?? false)
//                 ? Image.network(image[index].url!)
//                 : Image.file(File(image[index].url!));
//           }
//         },
//       ),
//     );
//     // return Image.network(
//     //   // width: 390,
//     //   image.url!,
//     //   // fit: BoxFit.fitWidth,
//     //   // cacheHeight: 200,
//     //   // cacheWidth: 200,
//     // );
//   }
  Widget _builderimage(List<Postedphoto> image, UserDetail detail,
      UserPost userpost, User user) {
    int remainimages =
        image.length - 3; //remaining after 3 images foe the stack
    //if only one image
    if (image.length == 1) {
      if (userpost.postId! > 10) {
        return Image.file(File(image[0].url!));
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
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullImageScreen(
                    images: image,
                    detail: detail,
                    user: user,
                    post: userpost,
                  ),
                )),
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
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullImageScreen(
              images: image,
              detail: detail,
              user: user,
              post: userpost,
            ),
          )),
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
                    ? Image.file(
                        File(image[index].url!),
                        fit: BoxFit.fill,
                      )
                    : Image.network(
                        image[index].url!,
                        fit: BoxFit.fill,
                      ),
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
                ? Image.file(
                    File(image[index].url!),
                    fit: BoxFit.fill,
                  )
                : Image.network(
                    image[index].url!,
                    fit: BoxFit.fill,
                  );
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
  }
}
