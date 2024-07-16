import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:socialapp/models/courses.dart';
import 'package:socialapp/models/courses_by_category.dart';
import 'package:socialapp/models/instructor.dart';
import 'package:socialapp/models/user.dart';
import 'package:socialapp/models/user_detail.dart';
import 'package:socialapp/models/user_friendlist.dart';
import 'package:socialapp/models/user_post.dart';

class Newscreen extends StatefulWidget {
  List<UserPost> post;
  List<User> user;
  List<UserDetail> userdetail;
  List<UserFriendlist> friend;
  List<Instructor> instructor;
  List<Courses> courses;
  List<CoursesCategory> category;
  // List<User> user;
  // final UserPost userPost;
  Newscreen(
      {super.key,
      required this.post,
      required this.user,
      required this.userdetail,
      required this.friend,
      required this.category,
      required this.courses,
      required this.instructor});

  @override
  State<Newscreen> createState() => _NewscreenState();
}

class _NewscreenState extends State<Newscreen> {
  bool isliked = false;
  bool isDisliked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.post.length,
        itemBuilder: (context, index) {
          return _builderpostscreen(widget.post[index]);
        },
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

  Widget _builderpostscreen(UserPost model) {
    User users = getuserid(model.userId!);
    UserDetail userDetail = getid(model.userId!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(userDetail.profileImage!.imagePath!),
          ),
          title: Text(users.name!),
          subtitle: Text(users.email!),
        ),
        // const SizedBox(
        //   height: 8,
        // ),
        Text(model.title!),
        Text(model.description!),

        // Text('${model.image!.length}'),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            // ...model.image!.map((e) => _builderimage(e)),
            for (var image in model.image!) _builderimage(image),
          ]),
        ),
        SizedBox(
          height: 50,
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                likedBtn(),
                dislikeBtn(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  IconButton dislikeBtn() {
    return IconButton(
        onPressed: () {
          setState(() {
            isDisliked = !isDisliked;
            if (isDisliked && isliked == false) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  duration: Duration(seconds: 1),
                  content: Text('Disliked the post')));
            }
            if (isliked == true) {
              setState(() {
                isDisliked = false;
              });
            }
          });
        },
        icon: isDisliked
            ? const Icon(Icons.thumb_down_alt)
            : const Icon(Icons.thumb_down_alt_outlined));
  }

  IconButton likedBtn() {
    return IconButton(
        onPressed: () {
          setState(() {
            isliked = !isliked;
            if (isliked && isDisliked == false) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  duration: Duration(seconds: 1),
                  content: Text('Liked the post')));
            }
            if (isDisliked == true) {
              setState(() {
                isliked = false;
              });
            }
          });
        },
        icon: isliked
            ? const Icon(Icons.thumb_up_alt)
            : const Icon(Icons.thumb_up_alt_outlined));
  }

  Widget _builderimage(Postedphoto image) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: Image.network(
        width: 390,
        image.url!,
        fit: BoxFit.fitWidth,
        // cacheHeight: 200,
        // cacheWidth: 200,
      ),
    );
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
  }
}


//// Card(
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       ListTile(
    //           leading: const CircleAvatar(
    //             child: Icon(Icons.account_circle_rounded),
    //           ),
    //           title: Text('${users.name}')),
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