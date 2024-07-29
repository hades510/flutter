import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/dataloader.dart';
import 'package:socialapp/models/user_detail.dart';
import 'package:socialapp/models/user_post.dart';
import 'package:socialapp/profiles/addpost.dart';

import '../models/user.dart';

class Auth {
  static String isUserloggedin =
      'Logged'; //use this key to save the data updated

  Dataloader dataloader;
  Auth(this.dataloader);
//login
  // Future<bool> login(String email, String password) async {
  //   //retrived data to shared prefernces
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? userjson = prefs.getString(Dataloader.userkey);
  //   if (userjson != null) {
  //     //decoding json data to list of user obj
  //     List userlist = jsonDecode(userjson);
  //     List<User> users = userlist.map((e) => User.fromJson(e)).toList();
  //     for (User e in users) {
  //       if (e.email == email && e.password == password) {
  //         List<UserDetail> userdetail = await dataloader.getuserdetail();
  //         UserDetail userdetailmatch =
  //             userdetail.firstWhere((element) => element.id == e.id);
  //         if (userdetailmatch != null) {
  //           prefs.setString(
  //               isUserloggedin, jsonEncode(userdetailmatch.toJson()));
  //           return true;
  //         }
  //       }
  //     }
  //   }
  //   return false;
  // }
  Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    String? userjson = prefs.getString(Dataloader.userkey);
    if (userjson != null) {
      List userlist = json.decode(userjson);
      List<User> users = userlist.map((e) => User.fromJson(e)).toList();

      for (User e in users) {
        if (e.email == email && e.password == password) {
          String? userdetailjson = prefs.getString(Dataloader.userdetailkey);

          if (userdetailjson != null) {
            List detaillist = json.decode(userdetailjson);
            List<UserDetail> details =
                detaillist.map((e) => UserDetail.fromJson(e)).toList();

            UserDetail userdetailmatch =
                details.firstWhere((element) => element.id == e.id);

            if (userdetailmatch != null) {
              prefs.setString(
                  isUserloggedin, jsonEncode(userdetailmatch.toJson()));
              return true;
            }
          }
        }
      }
    }
    return false;
  }

//logout
  Future logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(isUserloggedin);
  }

//checking if user is logged in
  Future<UserDetail?> getloggedinuser() async {
    //used for fetching data in future builder if loggedin
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userstring = prefs.getString(isUserloggedin);
    if (userstring != null) {
      return UserDetail.fromJson(jsonDecode(userstring));
    }

    return null;
  }

  /// The function `saveUserDetail` saves the user details to SharedPreferences after encoding them to
  /// JSON.
  ///
  /// Args:
  ///   userDetail (UserDetail): UserDetail object containing user details such as name, email, age,
  /// etc.
  Future<void> saveUserDetail(UserDetail userDetail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Save the updated user details
    prefs.setString(isUserloggedin, jsonEncode(userDetail.toJson()));
  }

  /// The function `saveUserDetail` saves a user's details in JSON format to SharedPreferences using a
  /// unique key based on the user's ID.
  ///
  /// Args:
  ///   userDetail (UserDetail): The `userDetail` parameter is an object of type `UserDetail` that
  /// contains information about a user, such as their name, email, and other details.
  //
  /*If you're using SharedPreferences to store user data, 
  you should fetch the updated user details from SharedPreferences in the news feed page.
 You can create a method in your Auth class to get the latest user details: */
  Future<UserDetail?> getUserDetail(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final userDetailJson = prefs.getString('user_detail_$userId');
    if (userDetailJson != null) {
      final userDetailMap = jsonDecode(userDetailJson);
      return UserDetail.fromJson(userDetailMap);
    }
    return null;
  }

//change the password
  Future<bool> changepassword(
    String oldpassword,
    String newpassword,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userjson = prefs.getString(Dataloader.userkey);
    if (userjson != null) {
      List userlist = jsonDecode(userjson);
      List<User> users = userlist.map((e) => User.fromJson(e)).toList();

      for (User user in users) {
        if (user.password == oldpassword) {
          user.password = newpassword;

          String updateduserJson = jsonEncode(user.toJson());
          List updatedlist = users.map((e) => e.toJson()).toList();

          prefs.setString(Dataloader.userkey, jsonEncode(updatedlist));
          return true;
        }
      }
    }
    return false;
  }

  Future<void> deletePost(int postId) async {
    List<UserPost> posts = await dataloader.getuserpost();
    posts.removeWhere((post) => post.postId == postId);

    // Save updated posts back to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Dataloader.userpostkey,
        json.encode(posts.map((post) => post.toJson()).toList()));
  }

  //for adding user
  Future<void> adduser(User user) async {
    //getting existing data
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString(Dataloader.userkey);
    List<User> userslist = [];

    if (userJson != null) {
      List jsonList = json.decode(userJson);
      userslist = jsonList.map((e) => User.fromJson(e)).toList();
    }
    userslist.add(user);

    List<Map<String, dynamic>> jsonList =
        userslist.map((e) => e.toJson()).toList();
    String updatedList = json.encode(jsonList);

    //thus saving the updated endcoded values to the key of user
    await prefs.setString(Dataloader.userkey, updatedList);
  }

  Future<void> adduserdetail(UserDetail detail) async {
    final prefs = await SharedPreferences.getInstance();
    String? detailjson = prefs.getString(Dataloader.userdetailkey);
    List<UserDetail> detaillist = [];

    if (detailjson != null) {
      List jsonList = jsonDecode(detailjson);
      detaillist = jsonList.map((e) => UserDetail.fromJson(e)).toList();
    }
    detaillist.add(detail);

    List<Map<String, dynamic>> jsonList =
        detaillist.map((e) => e.toJson()).toList();
    String updatedList = json.encode(jsonList);

    await prefs.setString(Dataloader.userdetailkey, updatedList);
  }
}

/*
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/models/user.dart'; // Import your User model class

class Auth {
  final Dataloader dataloader;

  Auth(this.dataloader);

  Future<void> addUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('users');
    List<User> userList = [];

    if (userJson != null) {
      List<dynamic> jsonList = json.decode(userJson);
      userList = jsonList.map((e) => User.fromJson(e)).toList();
    }

    userList.add(user);

    List<Map<String, dynamic>> jsonList = userList.map((e) => e.toJson()).toList();
    String updatedUserJson = json.encode(jsonList);

    await prefs.setString('users', updatedUserJson);
  }
}

*/
