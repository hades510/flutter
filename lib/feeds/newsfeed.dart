import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:socialapp/dataloader.dart';
import 'package:socialapp/login.dart';
import 'package:socialapp/models/courses.dart';
import 'package:socialapp/models/courses_by_category.dart';
import 'package:socialapp/models/instructor.dart';
import 'package:socialapp/models/user.dart';
import 'package:socialapp/models/user_detail.dart';
import 'package:socialapp/models/user_friendlist.dart';
import 'package:socialapp/models/user_post.dart';
import 'package:socialapp/feeds/Albumscreen.dart';
import 'package:socialapp/profiles/view_profile.dart';

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
              // friend: snapshot.data!['friends'],
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

    List<UserPost> posts = await dataloader.getuserpost(); //loaded the data and
    List<UserDetail> userdetail = await dataloader.getuserdetail();
    List<User> user = await dataloader.getuser();
    // List<UserFriendlist> friendlist = await dataloader.getfriendlist();
    // List<Instructor> instructor = await dataloader.getInstructor();
    // List<Courses> courses = await dataloader.getCourse();
    // List<CourseBy> coursescategory = await dataloader.getcoursesby();

    return {
      'users': user, //(passed the data to this keys)
      'userdetails': userdetail,
      'posts': posts,
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
  // List<UserFriendlist> friend;
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
    // required this.friend,
    // required this.category,
    // required this.courses,
    // required this.instructor
  });

  @override
  State<Newscreen> createState() => _NewscreenState();
}

class _NewscreenState extends State<Newscreen> {
  // bool model.isDisliked = false;
  // bool model.isDisliked = false;
//for each post use this bools inside the user post model

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: widget.post.length,
          itemBuilder: (context, index) {
            return _builderpostscreen(widget.post[index]);
          },
          separatorBuilder: (context, index) {
            return Divider();
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
        Card(
          elevation: 5,
          child: _builderimage(
            model.image!,
            userDetail,
            users,
          ),
        ), //here with list<postedphot> i passed userdetail model also
        // Text('${model.image!.length}'),
        // for (var image in model.image!) _builderimage(image),

        Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                // enableFeedback: true,
                tooltip: 'Like',
                onPressed: () {
                  setState(() {
                    model.isliked = !model.isliked;
                    if (model.isliked) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text('Liked the post')));
                    }
                  });
                },
                icon: model.isliked
                    ? const Icon(Icons.thumb_up_alt)
                    : const Icon(Icons.thumb_up_alt_outlined),
              ),
              IconButton(
                tooltip: 'Dislike',
                onPressed: () {
                  setState(() {
                    model.isDisliked = !model.isDisliked;
                    if (model.isDisliked) {
                      model.isliked = false;
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text('Disliked the post')));
                    }
                  });
                },
                icon: model.isDisliked
                    ? const Icon(Icons.thumb_down_alt)
                    : const Icon(Icons.thumb_down_alt_outlined),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _builderimage(List<Postedphoto> image, UserDetail detail, User user) {
    int remainimages = image.length - 3;//remaining after 3 images foe the stack
    if (image.length == 1) {
      return Image.network(
        image[0].url!,
        // width: double.infinity,
      );
    } else if (image.length == 3) {
      return Column(
        children: [
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            children: [
              Image.network(
                image[0].url!,
              ),
              Image.network(
                image[1].url!,
              ),
            ],
          ),
          const SizedBox(
            height: 1,
          ),
          Image.network(
            image[2].url!,
          )
        ],
      );
    }

    return GridView.builder(
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
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullImageScreen(
                      images: image,
                      detail: detail,
                      user: user,
                    ),
                  ));
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  image[index].url!,
                  fit: BoxFit.cover,
                ),
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
            ),
          );
        } else {
          return Image.network(
            image[index].url!,
            fit: BoxFit.cover,
          );
        }
      },
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
