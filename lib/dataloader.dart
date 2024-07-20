import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/models/course_categories.dart';
import 'package:socialapp/models/courses.dart';
import 'package:socialapp/models/courses_by_category.dart';
import 'package:socialapp/models/instructor.dart';
import 'package:socialapp/models/user.dart';
import 'package:socialapp/models/user_detail.dart';
import 'package:socialapp/models/user_friendlist.dart';
import 'package:socialapp/models/user_post.dart';
// Future<Map<String,dynamic>> loaduser() async {
//   String userjson = await rootBundle
//       .loadString('assets/jsonfile/user.json'); //fetch data in string
//   return jsonDecode(userjson); // returns a json structure
// }

// Loads a JSON file containing user data from the assets bundle.
// Parses the JSON string into a list of dynamic objects.
// Maps each dynamic object to a User instance using the User.fromJson constructor.
// Returns a Future that completes with a list of User objects.

//
//
// }
class Dataloader {
  static String userkey = 'users';
  static String userdetailkey = 'userdetail';
  static String userpostkey = 'userpost';
  static String userdfriendlistkey = 'userfriend';
  static String courseskey = 'courses';
  static String coursebykey = 'coursebycategories';
  static String coursescategorykey = 'coursescategory';
  static String instructorkey = 'instrucor';
  Future loadalluserdatas() async {
    SharedPreferences prefs = await SharedPreferences
        .getInstance(); //when chnaged it get's new password
    String userjson = await rootBundle
        .loadString('assets/jsonfile/user.json'); //fetch data in string
    print('$userjson');
    prefs.setString(userkey, userjson);

    String userdetailjson =
        await rootBundle.loadString('assets/jsonfile/user_detail.json');
    prefs.setString(userdetailkey, userdetailjson);

    String userpostjson =
        await rootBundle.loadString('assets/jsonfile/user_post.json');
    prefs.setString(userpostkey, userpostjson);

    String userfriendjson =
        await rootBundle.loadString('assets/jsonfile/user_friendlist.json');
    prefs.setString(userdfriendlistkey, userfriendjson);

    String coursesjson =
        await rootBundle.loadString('assets/jsonfile/courses.json');
    prefs.setString(courseskey, coursesjson);

    String coursesbyjson = await rootBundle
        .loadString('assets/jsonfile/courses_by_categories.json');
    prefs.setString(coursebykey, coursesbyjson);

    String coursecategoryjson =
        await rootBundle.loadString('assets/jsonfile/course_categories.json');
    prefs.setString(coursescategorykey, coursecategoryjson);

    String instructorjson =
        await rootBundle.loadString('assets/jsonfile/instructor.json');
    prefs.setString(instructorkey, instructorjson);
  }

  // gets
  Future<List<User>> getuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString(userkey); //also get password new
    print('$prefs');
    if (user != null) {
      List userlist = json.decode(user);
      return userlist.map((e) => User.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<List<UserDetail>> getuserdetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? detail = prefs.getString(userdetailkey);
    if (detail != null) {
      List detaillist = json.decode(detail);
      print('$prefs');
      print('$detail');
      print('$detaillist');
      return detaillist.map((e) => UserDetail.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<List<UserPost>> getuserpost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? post = prefs.getString(userpostkey);
    if (post != null) {
      List postlist = json.decode(post);
      return postlist.map((e) => UserPost.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<List<UserFriendlist>> getfriendlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userfriend = prefs.getString(userdfriendlistkey);
    if (userfriend != null) {
      List userfriendlist = jsonDecode(userfriend);
      return userfriendlist.map((e) => UserFriendlist.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<List<Courses>> getCourse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? courses = prefs.getString(courseskey);
    if (courses != null) {
      List courseslist = jsonDecode(courses);
      return courseslist.map((e) => Courses.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<List<CourseBy>> getcoursesby() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? coursescategory = prefs.getString(coursebykey);
    if (coursescategory != null) {
      List coursescategorylist = jsonDecode(coursescategory);
      return coursescategorylist.map((e) => CourseBy.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<List<CoursesCategory>> getcoursecategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? category = prefs.getString(coursescategorykey);
    if (category != null) {
      List categorylist = jsonDecode(category);
      return categorylist.map((e) => CoursesCategory.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<List<Instructor>> getInstructor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? instructor = prefs.getString(instructorkey);
    if (instructor != null) {
      List instructorlist = jsonDecode(instructor);
      return instructorlist.map((e) => Instructor.fromJson(e)).toList();
    } else {
      return [];
    }
  }
}

  // Future loaduser() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String
  // }

//login id authenthication
//   Future<UserDetail> loaddetail(int userid) async {
//     String userdetailjson =
//         await rootBundle.loadString('assets/jsonfile/user_detail.json');
//     List userdetail = jsonDecode(userdetailjson);
//     Map<String, dynamic> json =
//         userdetail.firstWhere((element) => element['Id'] == userid);
//     return UserDetail.fromJson(json);
//   }

// //fo oter purpose
//   Future<List<UserDetail>> loaduserdetail() async {
//     String userdetailjson =
//         await rootBundle.loadString('assets/jsonfile/user_detail.json');
//     List userdetail = json.decode(userdetailjson);
//     return userdetail.map((e) => UserDetail.fromJson(e)).toList();
//   }

//   Future<List<UserPost>> loadpost() async {
//     String postjson =
//         await rootBundle.loadString('assets/jsonfile/user_post.json');
//     List postlist = json.decode(postjson);
//     List<UserPost> userpost = [];
//     for (var user in postlist) {
//       userpost.add(UserPost.fromJson(
//           user)); //converts each object to Userpost object and add this to list
//     }
//     return userpost; //list of user post
//   }

//   Future<List<UserFriendlist>> loadfriend() async {
//     String friendjson =
//         await rootBundle.loadString('assets/jsonfile/user_friendlist.json');
//     List friendlist = json.decode(friendjson);
//     return friendlist.map((e) => UserFriendlist.fromJson(e)).toList();
//   }

//   //for authenticated files like logina
//   Future<Courses?> loadcore(int id) async {
//     String corejson =
//         await rootBundle.loadString('assets/jsonfile/courses.json');
//     List coreroot = json.decode(corejson);
//     for (var i in coreroot) {
//       if (i['Id'] == id) {
//         return Courses.fromJson(i);
//       }
//       // return null;
//     }
//   }

// //for other things
//   Future<List<Courses>> loadcourses() async {
//     String coursesjson =
//         await rootBundle.loadString('assets/jsonfile/courses.json');
//     List courseslist = json.decode(coursesjson);
//     return courseslist.map((e) => Courses.fromJson(e)).toList();
//   }

//   Future<List<CoursesCategory>> loadcategory() async {
//     String categoryjson = await rootBundle
//         .loadString('assets/jsonfile/courses_by_categories.json');
//     List categorylist = json.decode(categoryjson);
//     return categorylist.map((e) => CoursesCategory.fromJson(e)).toList();
//   }

//   //for authenticated files like logina
//   Future<Instructor?> loadins(int id) async {
//     String corejson =
//         await rootBundle.loadString('assets/jsonfile/instructor.json');
//     List coreroot = json.decode(corejson);
//     for (var i in coreroot) {
//       if (i['Id'] == id) {
//         return Instructor.fromJson(i);
//       }
//       // return null;
//     }
//   }

//   Future<List<Instructor>> loadinstructor() async {
//     String instructorjson =
//         await rootBundle.loadString('assets/jsonfile/instructor.json');
//     List instructorlist = json.decode(instructorjson);
//     return instructorlist.map((e) => Instructor.fromJson(e)).toList();
//   }

//   Future<List<CCategory>> loadcoursecategory() async {
//     String coursecategoryjson =
//         await rootBundle.loadString('assets/jsonfile/course_categories.json');
//     List coursecategorylist = json.decode(coursecategoryjson);
//     return coursecategorylist.map((e) => CCategory.fromJson(e)).toList();
//   }
// }
