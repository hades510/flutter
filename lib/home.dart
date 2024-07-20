// // import 'package:flutter/material.dart';
// // import 'package:socialapp/courses/available%20courses.dart';
// // import 'package:socialapp/login.dart';
// // import 'package:socialapp/models/user.dart';
// // import 'package:socialapp/models/user_detail.dart';
// // import 'package:socialapp/models/user_post.dart';
// // // import 'package:socialapp/newsfeed.dart';
// // import 'package:socialapp/signup.dart';

// // import 'feeds/newsfeed.dart';

// // class Home extends StatefulWidget {
// //   // final UserPost post;
// //   // final UserDetail userDetail;
// //   // final User user;
// //   const Home({
// //     super.key,
// //     // required this.post,
// //     // required this.userDetail,
// //     // required this.user
// //   });

// //   @override
// //   State<Home> createState() => _HomeState();
// // }

// // class _HomeState extends State<Home> {
// //   int selectedindex = 0;
// //   final pages = [
// //     const Newsfeed(),
// //     const AvailableCourses(),
// //     const LoginPage(),
// //     // const Signup(),
// //   ];
// //   @override
// //   Widget build(BuildContext context) {
// //     // User user = User();
// //     // UserPost post = UserPost();
// //     // UserDetail detail = UserDetail();
// //     return Scaffold(
// //       appBar: AppBar(
// //         title:const Text(
// //           'Social App',
// //           style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
// //         ),
// //         actions: [
// //           IconButton(
// //             icon: Icon(Icons.person),
// //             onPressed: () {
// //               // Navigate to user profile page
// //               // Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfilePage()));
// //             },
// //           ),
// //         ],
// //       ),
// //       body: pages[selectedindex],
// //       bottomNavigationBar: SizedBox(
// //         height: 50,
// //         child: Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceAround,
// //           children: [
// //             IconButton(
// //                 onPressed: () {
// //                   setState(() {
// //                     selectedindex = 0;
// //                     const Newsfeed();
// //                   });
// //                 },
// //                 icon: selectedindex == 0
// //                     ? const Icon(Icons.home)
// //                     : const Icon(Icons.home_outlined)),
// //             IconButton(
// //                 onPressed: () {
// //                   setState(() {
// //                     selectedindex = 1;
// //                     const AvailableCourses();
// //                   });
// //                 },
// //                 icon: selectedindex == 1
// //                     ? const Icon(Icons.book)
// //                     : const Icon(Icons.book_outlined)),
// //             IconButton(
// //                 onPressed: () {
// //                   setState(() {
// //                     selectedindex = 2;
// //                     const LoginPage();
// //                   });
// //                 },
// //                 icon: selectedindex == 2
// //                     ? const Icon(Icons.login)
// //                     : const Icon(Icons.login_outlined))
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/courses/available%20courses.dart';
import 'package:socialapp/dataloader.dart';
import 'package:socialapp/login.dart';
import 'package:socialapp/feeds/newsfeed.dart';
import 'package:socialapp/courses/view_courses.dart';
import 'package:socialapp/profiles/view_profile.dart';

import 'authenthication/login_auth.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Dataloader dataloader = Dataloader();
  late Auth service;
  @override
  void initState() {
    super.initState();
    loadData();

    service = Auth(dataloader);
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isJsonLoaded = prefs.getBool("jsonData") ?? false; //here it load the fetched json data if there is not data in shared preferences
    //send false  


    if (!isJsonLoaded) {
      dataloader.loadalluserdatas();
      prefs.setBool("jsonData", true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 25,
            title: const Text('Social App'),
            bottom: TabBar(
              tabs: [
                const Icon(
                  Icons.home_outlined,
                  size: 30,
                ),
                Image.asset(
                  'assets/images/courses.png',
                  cacheHeight: 30,
                  cacheWidth: 30,
                  color: Colors.black,
                ),
                // Icon(Icons.book_outlined,
                // const Icon(
                //   Icons.login_outlined,
                //   size: 30,
                // ),
                const Icon(
                  Icons.account_circle,
                  size: 30,
                )
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              Newsfeed(),
              AvailableCourses(),
              // LoginPage(),
              ViewProfile(),
            ],
          ),
        ));
  }
}
