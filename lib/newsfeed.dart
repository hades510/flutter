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
import 'package:socialapp/newsscreen.dart';
import 'package:socialapp/view_profile.dart';

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
    User user = User();
    UserDetail userDetail = UserDetail();
    UserPost post = UserPost();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('News Feed'),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ));
              },
              child: const Icon(
                Icons.login_outlined,
                size: 50,
              ),
            ),
          ],
        ),
      ),
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
              category: snapshot.data!['categories'],
              friend: snapshot.data!['friends'],
              courses: snapshot.data!['courses'],
              instructor: snapshot.data!['instructors'],
            );
          }
        },
      ),
    );
  }

  Future _fetchuserpost() async {
    Dataloader dataloader = Dataloader();
    List<UserPost> posts = await dataloader.loadpost(); //loaded the data and
    List<User> user = await dataloader.loaduser();
    List<UserFriendlist> friendlist = await dataloader.loadfriend();
    List<Instructor> instructor = await dataloader.loadinstructor();
    List<Courses> courses = await dataloader.loadcourses();
    List<CoursesCategory> coursescategory = await dataloader.loadcategory();

    return {
      'users': user, //(passed the data to this keys)
      'posts': posts,
      'friends': friendlist,
      'instructors': instructor,
      'courses': courses,
      'categories': coursescategory,
    };
  }
}
