// import 'package:flutter/material.dart';
// import 'package:socialapp/login.dart';
// import 'package:socialapp/models/user.dart';
// import 'package:socialapp/models/user_detail.dart';
// import 'package:socialapp/models/user_post.dart';
// import 'package:socialapp/newsfeed.dart';
// import 'package:socialapp/signup.dart';

// class Home extends StatefulWidget {
//   final UserPost post;
//   final UserDetail userDetail;
//   final User user;
//   const Home(
//       {super.key,
//       required this.post,
//       required this.userDetail,
//       required this.user});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   int selectedindex = 0;
//   final pages = [
//     const Newsfeed(
//       post: post,
//     ),
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
//                     Newsfeed(
//                       post: post,
//                     );
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
