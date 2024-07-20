import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/testing/test_model_user.dart';
import 'package:socialapp/testing/test_userdetail_model.dart';

class Dataloader {
  static String userkey = 'users';
  static String userdetailkey = 'userdetail';
  Future loadalluserdatas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userjson = await rootBundle
        .loadString('assets/jsonfile/user.json'); //fetch data in string
    prefs.setString(userkey, userjson);

    String userdetailjson =
        await rootBundle.loadString('assets/jsonfile/user_detail.json');
    prefs.setString(userdetailkey, userdetailjson);
  }

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
}
