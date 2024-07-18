// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:socialapp/dataloader.dart';
// import 'package:socialapp/datastorage.dart';
// import 'package:socialapp/models/user.dart';
// import 'package:socialapp/models/user_detail.dart';

// class Auth {
//  /// The code snippet you provided is a Dart class named `Auth` that handles user authentication. Here's
//  /// an explanation of the relevant parts:
//   Dataloader dataloader = Dataloader(); // for loading the parsed data
//   // DataStorage dataStorage = DataStorage();
//   Future login(String email, String password) async {
//     List<User> users = await dataloader.loaduser();//loaded the parsed user data
//     // List<User> users = await dataStorage.getuser(); //saved from shared preferences
//     // List<UserDetail> userdetails = await dataloader.loaddetail();
//     User? authenUser; //user class object
//     UserDetail? detail; //userdetail class object

//     for (User user in users) {
//       //for in loop
//       if (user.email == email && user.password == password) {
//         authenUser =
//             user; //here the user has the scope for this for loop only so,all the data of user is send to authenUser shose scope is greater.

//         detail = await dataloader.loaddetail(user
//             .id!); //loades the user's id which was stored with the clicked email and password
//         break;
//       }
//     }

//     /// This part of the code is checking if both `authenUser` and `detail` are not null. If they are
//     /// both not null, it means that a user has been successfully authenticated and their details have
//     /// been loaded.
//     if (authenUser != null && detail != null) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setInt(
//           'Id', authenUser.id!); //User id is stored in 'Id key for later use

//       return {
//         'user': authenUser,
//         'userdetail': detail
//       }; //after setting the details of authenUser and detail is stored inside the following keys
//     }
//     return null;
//   }
// }
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/dataloader.dart';
import 'package:socialapp/models/user_detail.dart';

import '../models/user.dart';

class Auth {
  static String loggdin = 'Logged';
  Dataloader dataloader = Dataloader();
  Auth(this.dataloader);

  Future<bool> login(String email, String password) async {
    List<User> users = await dataloader.getuser();
    List<UserDetail> userdetail = await dataloader.getuserdetail();
    for (User e in users) {
      if (e.email == email && e.password == password) {
        /*UserDetail*/ var userdetailmatch =
            userdetail.firstWhere((element) => element.id == e.id);
        if (userdetailmatch != null) {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString(loggdin, json.encode(userdetailmatch.toJson()));
          return true;
        }
      }
    }
    return false;
  }

  Future logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(loggdin);
  }

  Future<UserDetail?> getloggedinuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userstring = prefs.getString(loggdin);
    if (userstring != null) {
      return UserDetail.fromJson(jsonDecode(userstring));
    }
    return null;
  }
}
