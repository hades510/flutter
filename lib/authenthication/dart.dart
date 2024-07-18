import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/models/user.dart';

class DataLoader {
  static String userkey = 'users';

  Future<void> loadAllUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userJson = await rootBundle.loadString('assets/jsonfile/user.json'); // Fetch data in string
    prefs.setString(userkey, userJson);
  }

  Future<List<User>> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString(userkey);
    if (user != null) {
      List userList = json.decode(user);
      return userList.map((e) => User.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<void> updateUserPassword(int userId, String newPassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString(userkey);

    if (userJson != null) {
      List<dynamic> userList = json.decode(userJson);
      for (var user in userList) {
        if (user['id'] == userId) {
          user['password'] = newPassword;
          break;
        }
      }

      String updatedUserJson = json.encode(userList);
      prefs.setString(userkey, updatedUserJson);
    }
  }
}

// Example Usage:
void main() async {
  DataLoader dataLoader = DataLoader();
  await dataLoader.loadAllUserData(); // Load initial data
  List<User> users = await dataLoader.getUser(); // Get all users

  print('Before password change:');
  print(users.firstWhere((user) => user.id == 1).password); // Print current password

  await dataLoader.updateUserPassword(1, 'newPassword123'); // Change password

  users = await dataLoader.getUser(); // Get updated users

  print('After password change:');
  print(users.firstWhere((user) => user.id == 1).password); // Print new password
}
