import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:socialapp/testing/test_model_user.dart';
import 'package:socialapp/testing/test_userdetail_model.dart';
import 'package:socialapp/testing/test_userpost.dart';

class Dataloader {
  static String userkey = 'users';
  static String userdetailkey = 'userdetail';
  static String userpostkey = 'userpost';
  Future loadalluserdatas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userjson = await rootBundle
        .loadString('assets/jsonfile/user.json'); //fetch data in string
    prefs.setString(userkey, userjson);

    String userdetailjson =
        await rootBundle.loadString('assets/jsonfile/user_detail.json');
    prefs.setString(userdetailkey, userdetailjson);
    String userpost =
        await rootBundle.loadString('assets/jsonfile/user_post.json');
    await prefs.setString(userpost, userpost);
  }
//user and user detail
  Future<List<User>> getuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString(userkey);
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
}
