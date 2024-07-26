

import 'package:flutter/material.dart';
import 'package:socialapp/testing/test_model_user.dart';
import 'package:socialapp/testing/test_userdetail_model.dart';
import 'package:socialapp/testing/test_userpost.dart';

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
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  widget.detail.profileImage!.imagePath!,
                ),
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

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:socialapp/models/user_detail.dart';
// import 'package:socialapp/models/user_post.dart';

// import '../models/user.dart';

// class FullImageScreen extends StatefulWidget {
//   final List<Postedphoto> images;
//   final UserDetail detail;
//   final User user;

//   const FullImageScreen(
//       {super.key,
//       required this.images,
//       required this.detail,
//       required this.user});

//   @override
//   State<FullImageScreen> createState() => _FullImageScreenState();
// }

// class _FullImageScreenState extends State<FullImageScreen> {
//   // bool isDisliked = false;
//   // bool isliked = false;

//   //use this inside the model class

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('All Photos'),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               ListTile(
//                 leading: CircleAvatar(
//                   backgroundImage: NetworkImage(
//                     widget.detail.profileImage!.imagePath!,
//                   ),
//                 ),
//                 title: Text(widget.detail.basicInfo!.FullImageScreen!),
//                 subtitle: Text(widget.user.email!),
//               ),
//               SizedBox(
//                 height: 700,
//                 child: ListView.builder(
//                   itemCount: widget.images.length,
//                   itemBuilder: (context, index) {
//                     return 
//                     Column(
//                       children: [
//                         Image.network(widget.images[index].url!),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             IconButton(
//                                 onPressed: () {
//                                   setState(() {
//                                     isliked = !isliked;
//                                     if (isliked && isDisliked == false) {
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(const SnackBar(
//                                               duration: Duration(seconds: 1),
//                                               content: Text('Liked the post')));
//                                     }
//                                     if (isDisliked == true) {
//                                       setState(() {
//                                         isliked = false;
//                                       });
//                                     }
//                                   });
//                                 },
//                                 icon: isliked
//                                     ? const Icon(Icons.thumb_up_alt)
//                                     : const Icon(Icons.thumb_up_alt_outlined)),
//                             IconButton(
//                                 onPressed: () {
//                                   setState(() {
//                                     isDisliked = !isDisliked;
//                                     if (isDisliked && isliked == false) {
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(const SnackBar(
//                                               duration: Duration(seconds: 1),
//                                               content:
//                                                   Text('Disliked the post')));
//                                     }
//                                     if (isliked == true) {
//                                       setState(() {
//                                         isDisliked = false;
//                                       });
//                                     }
//                                   });
//                                 },
//                                 icon: isDisliked
//                                     ? const Icon(Icons.thumb_down_alt)
//                                     : const Icon(Icons.thumb_down_alt_outlined))
//                           ],
//                         )
//                       ],
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         )
//         // GridView.builder(
//         //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         //     crossAxisCount: 3,
//         //     mainAxisSpacing: 2,
//         //     crossAxisSpacing: 2,
//         //   ),
//         //   itemCount: images.length,
//         //   itemBuilder: (context, index) {
//         //     return Image.network(
//         //       images[index].url!,
//         //       fit: BoxFit.cover,
//         //     );
//         //   },
//         // ),
//         );
//   }
// }

//import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/widgets.dart';
// import 'package:socialapp/models/courses.dart';
// import 'package:socialapp/models/courses_by_category.dart';
// import 'package:socialapp/models/instructor.dart';
// import 'package:socialapp/models/user.dart';
// import 'package:socialapp/models/user_detail.dart';
// import 'package:socialapp/models/user_friendlist.dart';
// import 'package:socialapp/models/user_post.dart';

// class Newscreen extends StatefulWidget {
//   List<UserPost> post;
//   List<User> user;
//   List<UserDetail> userdetail;
//   List<UserFriendlist> friend;
//   List<Instructor> instructor;
//   List<Courses> courses;
//   List<CourseBy> category;
//   // List<User> user;
//   // final UserPost userPost;
//   Newscreen(
//       {super.key,
//       required this.post,
//       required this.user,
//       required this.userdetail,
//       required this.friend,
//       required this.category,
//       required this.courses,
//       required this.instructor});

//   @override
//   State<Newscreen> createState() => _NewscreenState();
// }

// class _NewscreenState extends State<Newscreen> {
//   bool isliked = false;
//   bool isDisliked = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: ListView.builder(
//           shrinkWrap: true,
//           itemCount: widget.post.length,
//           itemBuilder: (context, index) {
//             return _builderpostscreen(widget.post[index]);
//           },
//         ),
//       ),
//     );
//   }

//   User getuserid(int userid) {
//     return widget.user
//         .firstWhere((element) => element.id == userid); //don't know why
//   }

//   UserDetail getid(int id) {
//     return widget.userdetail.firstWhere((element) => element.id == id);
//   }

//   Widget _builderpostscreen(UserPost model) {
//     User users = getuserid(model.userId!);
//     UserDetail userDetail = getid(model.userId!);

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         ListTile(
//           leading: CircleAvatar(
//             backgroundImage: NetworkImage(userDetail.profileImage!.imagePath!),
//           ),
//           title: Text(users.FullImageScreen!),
//           subtitle: Text(users.email!),
//         ),
//         // const SizedBox(
//         //   height: 8,
//         // ),
//         Text(model.title!),
//         Text(model.description!),
//         _builderimage(model.image!),

//         // SizedBox(
//         //   width: 390,
//         //   height: 390,
//         //   child: GridView.builder(
//         //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         //         crossAxisCount: 02),
//         //     itemCount: model.image!.length,
//         //     itemBuilder: (context, index) => _builderimage(model.image![index]),
//         //   ),
//         // ),
//         // Text('${model.image!.length}'),
//         // for (var image in model.image!) _builderimage(image),
//         SizedBox(
//           height: 50,
//           child: ListTile(
//             title: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _likedbtn(),
//                 _dislikebtn(),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   IconButton _dislikebtn() {
//     return IconButton(
//         onPressed: () {
//           setState(() {
//             isDisliked = !isDisliked;
//             if (isDisliked && isliked == false) {
//               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                   duration: Duration(seconds: 1),
//                   content: Text('Disliked the post')));
//             }
//             if (isliked == true) {
//               setState(() {
//                 isDisliked = false;
//               });
//             }
//           });
//         },
//         icon: isDisliked
//             ? const Icon(Icons.thumb_down_alt)
//             : const Icon(Icons.thumb_down_alt_outlined));
//   }

//   IconButton _likedbtn() {
//     return IconButton(
//         onPressed: () {
//           setState(() {
//             isliked = !isliked;
//             if (isliked && isDisliked == false) {
//               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                   duration: Duration(seconds: 1),
//                   content: Text('Liked the post')));
//             }
//             if (isDisliked == true) {
//               setState(() {
//                 isliked = false;
//               });
//             }
//           });
//         },
//         icon: isliked
//             ? const Icon(Icons.thumb_up_alt)
//             : const Icon(Icons.thumb_up_alt_outlined));
//   }

//   Widget _builderimage(List<Postedphoto> image) {
//     int remainimages = image.length - 3;
//     return GridView.builder(
//       shrinkWrap: true, //allows widget to adjust it's size with content
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           //  childAspectRatio: 1,
//           mainAxisSpacing: 2,
//           crossAxisSpacing: 2),
//       itemCount: image.length > 3 ? 4 : image.length, //don't know
//       itemBuilder: (context, index) {
//         if (index == 3 && remainimages > 0) {
//           return Stack(
//             fit: StackFit.expand,
//             children: [
//               Image.network(image[index].url!),
//               Container(
//                 color: Colors.black,
//                 child: Center(
//                   child: Text(
//                     '+$remainimages',
//                     style: const TextStyle(color: Colors.grey, fontSize: 25),
//                   ),
//                 ),
//               )
//             ],
//           );
//         } else {
//           return Image.network(
//             image[index].url!,
//             fit: BoxFit.cover,
//           );
//         }
//       },
//     );
//     // return Image.network(
//     //   // width: 390,
//     //   image.url!,
//     //   // fit: BoxFit.fitWidth,
//     //   // cacheHeight: 200,
//     //   // cacheWidth: 200,
//     // );
//   }
// }

    // return Container(
    //     // width: 390,
    //     padding: const EdgeInsets.symmetric(vertical: 10),
    //     margin: const EdgeInsets.all(25),
    //     child: Image.network(
    //       image.url!,
    //       // fit: BoxFit.fitWidth,
    //     ));
    // Container(
    //   width: double.infinity,
    //   height: 200,
    //   padding: EdgeInsets.symmetric(vertical: 5),
    //   child: Image.network(
    //     image.url!,
    //     fit: BoxFit.fitWidth,
    //   ),
    // );
  


//// Card(
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       ListTile(
    //           leading: const CircleAvatar(
    //             child: Icon(Icons.account_circle_rounded),
    //           ),
    //           title: Text('${users.FullImageScreen}')),
    //       // Text('${model.postId}'),
    //       Text('${model.title}'),
    //       Text('${model.description}'),
    //       GridView(
    //         shrinkWrap: true,
    //         physics: const NeverScrollableScrollPhysics(),
    //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //             crossAxisCount: 2),
    //         scrollDirection: Axis.horizontal,
    //         children: [
    //           ...model.image!.map((e) => _builderimage(e)),
    //         ],
    //       ),
    //       //here spread operator is used to insert all the elements to another collection

    //       Container(
    //         height: 50,
    //         child: ListTile(
    //           title: Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceAround,
    //             children: [
    //               likedBtn(),
    //               dislikeBtn(),
    //             ],
    //           ),
    //         ),
    //       ),
    //       const SizedBox(
    //         height: 10,
    //       )
    //     ],
    //   ),
    // );