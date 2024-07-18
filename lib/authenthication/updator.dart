import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/authenthication/dart.dart';
import 'package:socialapp/dataloader.dart';

class Updator {
  Dataloader dataloader = Dataloader();
  Updator({required this.dataloader});
  Future updatepassword(String? email, String? password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? json = prefs.getString(DataLoader.userkey);
    if (json != null) {
      List userlist = jsonDecode(json);
      for (var user in userlist) {
        if (user['Email'] == email) {
          user['Password'] == password;
          break;
        }
      }
      String updatedjson = jsonEncode(userlist);
      prefs.setString(DataLoader.userkey, updatedjson);
    }
  }
}
