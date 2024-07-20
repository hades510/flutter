import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/testing/test_dataloader.dart';
import 'package:socialapp/testing/test_model_user.dart';
import 'package:socialapp/testing/test_userdetail_model.dart';

class Auth {
  static String loggedin = 'Logged';
  Dataloader dataloader;

  Auth(this.dataloader);

  Future<bool> login(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userjson = prefs.getString(Dataloader.userkey);
    if (userjson != null) {
      List userlist = jsonDecode(userjson);
      List<User> users = userlist.map((e) => User.fromJson(e)).toList();
      for (User e in users) {
        if (e.email == email && e.password == password) {
          List<UserDetail> userdetails = await dataloader.getuserdetail();
          UserDetail userDetailMatch =
              userdetails.firstWhere((element) => element.id == e.id);
          if (userDetailMatch != null) {
            prefs.setString(loggedin, jsonEncode(userDetailMatch.toJson()));
            return true;
          }
        }
      }
    }
    return false;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(loggedin);
  }

  Future<UserDetail?> getLoggedInUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userString = prefs.getString(loggedin);
    if (userString != null) {
      return UserDetail.fromJson(jsonDecode(userString));
    }
    return null;
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString(Dataloader.userkey);
    if (userJson != null) {
      List userList = jsonDecode(userJson);
      List<User> users = userList.map((e) => User.fromJson(e)).toList();
      for (User user in users) {
        if (user.password == oldPassword ) {
          user.password = newPassword;
          String updatedUserJson = jsonEncode(user.toJson());
          List updatedUsersList = users.map((e) => e.toJson()).toList();
          prefs.setString(Dataloader.userkey, jsonEncode(updatedUsersList));
          return true;
        }
      }
    }
    return false;
  }
}

  // Future<bool> changePassword(String oldPassword, String newPassword) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? userString = prefs.getString(loggedin);
  //   if (userString != null) {
  //     UserDetail userDetail = UserDetail.fromJson(jsonDecode(userString));
  //     List<User> users = await dataloader.getuser();
  //     User? user = users.firstWhere((u) => u.id == userDetail.id && u.password == oldPassword, orElse: () => null);
  //     if (user != null) {
  //       user.password = newPassword;
  //       List<User> updatedUsers = users.map((u) => u.id == user.id ? user : u).toList();
  //       prefs.setString(Dataloader.userkey, jsonEncode(updatedUsers.map((u) => u.toJson()).toList()));
  //       userDetail.basicInfo?.password = newPassword; // Assuming password is stored in BasicInfo
  //       prefs.setString(loggedin, jsonEncode(userDetail.toJson()));
  //       return true;
  //     }
  //   }
  //   return false;
  // }
