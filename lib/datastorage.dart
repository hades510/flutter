// import 'dart:convert';

// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:socialapp/models/course_categories.dart';
// import 'package:socialapp/models/courses.dart';
// import 'package:socialapp/models/courses_by_category.dart';
// import 'package:socialapp/models/instructor.dart';
// import 'package:socialapp/models/user.dart';
// import 'package:socialapp/models/user_detail.dart';
// import 'package:socialapp/models/user_friendlist.dart';
// import 'package:socialapp/models/user_post.dart';

// class DataStorage {
//   //store
//   Future setuser(List<User> user) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String userjson = jsonEncode(user.map((e) => e.toJson()).toList());
//     await prefs.setString('user', userjson);
//   }

// //retrive

//   Future setuserdetail(List<UserDetail> detail) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String detailjson = json.encode(detail.map((e) => e.toJson()).toList());
//     await prefs.setString('userdetail', detailjson);
//   }

//   Future setuserpost(List<UserPost> post) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String postjson = json.encode(post.map((e) => e.toJson()).toList());
//     await prefs.setString('userpost', postjson);
//   }

//   Future getuserfriend(List<UserFriendlist> userfriend) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String userfriendjson =
//         jsonEncode(userfriend.map((e) => e.toJson()).toList());
//     await prefs.setString('userfriend', userfriendjson);
//   }

//   Future storeInstructor(List<Instructor> instructor) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String instructorjson =
//         jsonEncode(instructor.map((e) => e.toJson()).toList());
//     await prefs.setString('instructor', instructorjson);
//   }

 

// //courses
//   Future storeCourse(List<Courses> courses) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String coursesjson = jsonEncode(courses.map((e) => e.toJson()).toList());
//     await prefs.setString('courses', coursesjson);
//   }

// //courses by category
//   Future storecoursesby(List<CourseBy> coursescategory) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String coursescategoryjson =
//         jsonEncode(coursescategory.map((e) => e.toJson()).toList());
//     await prefs.setString('coursescategory', coursescategoryjson);
//   }

//   //course_categories
//   Future storecoursecategory(List<CoursesCategory> category) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? categoryjson = jsonEncode(category.map((e) => e.toJson()).toList());
//     await prefs.setString('category', categoryjson);
//   }
// }
