import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/testing/test_dataloader.dart';
import 'package:socialapp/testing/test_userdetail_model.dart';

import '../models/user.dart';

class Auth {
  static String isUserloggedin =
      'Logged'; //use this key to save the data updated

  Dataloader dataloader;
  Auth(this.dataloader);
//login
  Future<bool> login(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userjson = prefs.getString(Dataloader.userkey);
    if (userjson != null) {
      List userlist = jsonDecode(userjson);
      List<User> users = userlist.map((e) => User.fromJson(e)).toList();
      for (User e in users) {
        if (e.email == email && e.password == password) {
          List<UserDetail> userdetail = await dataloader.getuserdetail();
          UserDetail userdetailmatch =
              userdetail.firstWhere((element) => element.id == e.id);
          if (userdetailmatch != null) {
            prefs.setString(
                isUserloggedin, jsonEncode(userdetailmatch.toJson()));
            return true;
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

//retrives currently logged-in user detail from shared preferences
  Future<UserDetail?> getloggedinuser() async {
    //used for fetching data in future builder if loggedin
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userstring = prefs.getString(isUserloggedin);//fetches string value associated with isUserloggedin key
    if (userstring != null) {
      return UserDetail.fromJson(jsonDecode(userstring));//decodes the json string into map  and then uses fromJson to convert to object
    }

    return null;
  }
  //saves current user deatil
  Future<void> saveUserDetail(UserDetail userDetail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Save the updated user details
    prefs.setString(isUserloggedin, jsonEncode(userDetail.toJson()));
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
        print(user.password);
        print(oldpassword);
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

  // Save user details
  
  //
//
}
