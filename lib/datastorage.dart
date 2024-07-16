import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/models/course_categories.dart';
import 'package:socialapp/models/courses.dart';
import 'package:socialapp/models/courses_by_category.dart';
import 'package:socialapp/models/instructor.dart';
import 'package:socialapp/models/user.dart';
import 'package:socialapp/models/user_detail.dart';
import 'package:socialapp/models/user_friendlist.dart';
import 'package:socialapp/models/user_post.dart';

class DataStorage {
  //store
  Future setuser(List<User> user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userjson = jsonEncode(user.map((e) => e.toJson()).toList());
    await prefs.setString('user', userjson);
  }

//retrive
  Future<List<User>> getuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('user');
    if (user != null) {
      List userlist = json.decode(user);
      return userlist.map((e) => User.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future setuserdetail(List<UserDetail> detail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String detailjson = json.encode(detail.map((e) => e.toJson()).toList());
    await prefs.setString('userdetail', detailjson);
  }

  Future<List<UserDetail>> getuserdetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? detail = prefs.getString('userdetail');
    if (detail != null) {
      List detaillist = json.decode(detail);
      return detaillist.map((e) => UserDetail.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future setuserpost(List<UserPost> post) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String postjson = json.encode(post.map((e) => e.toJson()).toList());
    await prefs.setString('userpost', postjson);
  }

  Future<List<UserPost>> getuserpost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? post = prefs.getString('userpost');
    if (post != null) {
      List postlist = json.decode(post);
      return postlist.map((e) => UserPost.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future getuserfriend(List<UserFriendlist> userfriend) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userfriendjson =
        jsonEncode(userfriend.map((e) => e.toJson()).toList());
    await prefs.setString('userfriend', userfriendjson);
  }

  Future<List<UserFriendlist>> setUserfriend() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userfriend = prefs.getString('userfriend');
    if (userfriend != null) {
      List userfriendlist = jsonDecode(userfriend);
      return userfriendlist.map((e) => UserFriendlist.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future storeInstructor(List<Instructor> instructor) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String instructorjson =
        jsonEncode(instructor.map((e) => e.toJson()).toList());
    await prefs.setString('instructor', instructorjson);
  }

  Future<List<Instructor>> getInstructor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? instructor = prefs.getString('instructor');
    if (instructor != null) {
      List instructorlist = jsonDecode(instructor);
      return instructorlist.map((e) => Instructor.fromJson(e)).toList();
    } else {
      return [];
    }
  }

//courses
  Future storeCourse(List<Courses> courses) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String coursesjson = jsonEncode(courses.map((e) => e.toJson()).toList());
    await prefs.setString('courses', coursesjson);
  }

  Future<List<Courses>> getCourse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? courses = prefs.getString('courses');
    if (courses != null) {
      List courseslist = jsonDecode(courses);
      return courseslist.map((e) => Courses.fromJson(e)).toList();
    } else {
      return [];
    }
  }

//courses by category
  Future storecoursesby(List<CoursesCategory> coursescategory) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String coursescategoryjson =
        jsonEncode(coursescategory.map((e) => e.toJson()).toList());
    await prefs.setString('coursescategory', coursescategoryjson);
  }

  Future<List<CoursesCategory>> getcoursesby() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? coursescategory = prefs.getString('coursescategory');
    if (coursescategory != null) {
      List coursescategorylist = jsonDecode(coursescategory);
      return coursescategorylist
          .map((e) => CoursesCategory.fromJson(e))
          .toList();
    } else {
      return [];
    }
  }

  //course_categories
  Future storecoursecategory(List<CCategory> category) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? categoryjson = jsonEncode(category.map((e) => e.toJson()).toList());
    await prefs.setString('category', categoryjson);
  }

  Future<List<CCategory>> getcoursecategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? category = prefs.getString('category');
    if (category!= null) {
      List categorylist = jsonDecode(category);
      return categorylist.map((e) => CCategory.fromJson(e)).toList();
    } else {
      return [];
    }
  }
}
