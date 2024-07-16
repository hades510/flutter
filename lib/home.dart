// import 'package:flutter/material.dart';
// import 'package:socialapp/login.dart';
// import 'package:socialapp/models/user.dart';
// import 'package:socialapp/models/user_detail.dart';
// import 'package:socialapp/models/user_post.dart';
// import 'package:socialapp/newsfeed.dart';
// import 'package:socialapp/signup.dart';

// class Home extends StatefulWidget {
//   // final UserPost post;
//   // final UserDetail userDetail;
//   // final User user;
//   const Home(
//       {super.key,
//       // required this.post,
//       // required this.userDetail,
//       // required this.user
//       });

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   int selectedindex = 0;
//   final pages = [
//     const Newsfeed(),
//     const LoginPage(),
//     const Signup(),
//   ];
//   @override
//   Widget build(BuildContext context) {
//     User user = User();
//     UserPost post = UserPost();
//     UserDetail detail = UserDetail();
//     return Scaffold(
//       body: pages[selectedindex],
//       bottomNavigationBar: SizedBox(
//         height: 50,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             IconButton(
//                 onPressed: () {
//                   setState(() {
//                     selectedindex = 0;
//                     Newsfeed();
//                   });
//                 },
//                 icon: selectedindex == 0
//                     ? const Icon(Icons.home_outlined)
//                     : const Icon(Icons.home)),
//             IconButton(
//                 onPressed: () {
//                   setState(() {
//                     selectedindex = 1;
//                     const LoginPage();
//                   });
//                 },
//                 icon: selectedindex == 1
//                     ? const Icon(Icons.login_outlined)
//                     : const Icon(Icons.login))
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:socialapp/courses/available%20courses.dart';
import 'package:socialapp/login.dart';
import 'package:socialapp/feeds/newsfeed.dart';
import 'package:socialapp/courses/view_courses.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 30,
            title: const Text('Social App'),
            bottom: const TabBar(
              tabs: [
                Icon(Icons.home_outlined),
                Icon(Icons.book_outlined),
                Icon(Icons.login_outlined)
              ],
            ),
          ),
          body: const TabBarView(
            children: [Newsfeed(), AvailableCourses(), LoginPage()],
          ),
        ));
  }
}
