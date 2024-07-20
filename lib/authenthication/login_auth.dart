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
  static String isUserloggedin = 'Logged';//use this key to save the data updated
  
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
  // Save user details
  Future<void> saveUserDetail(UserDetail userDetail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Save the updated user details
    prefs.setString(isUserloggedin, jsonEncode(userDetail.toJson()));
  }
  //
//   
}
// Future<bool> changeProfileImage(String newImagePath) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? userdetailJson = prefs.getString(isUserloggedin);

//   if (userdetailJson != null) {
//     UserDetail userDetail = UserDetail.fromJson(jsonDecode(userdetailJson));
//     userDetail.profileImage!.imagePath = newImagePath;

//     // Save updated user details
//     prefs.setString(isUserloggedin, jsonEncode(userDetail.toJson()));
//     return true;
//   }
//   return false;
// }

// Future<bool> changeprofiles(String newpic) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? userdetailjson = prefs.getString(
  //       Dataloader.userdetailkey); //load the key value// that is userdetail
  //   if (userdetailjson != null) {
  //     List detaillist = jsonDecode(userdetailjson);
  //     List<UserDetail> details =
  //         detaillist.map((e) => UserDetail.fromJson(e)).toList();

  //     for (UserDetail detail in details) {
  //       if (detail.profileImage!.imagePath == newpic) {
  //         detail.profileImage!.imagePath = newpic;

  //         String updatedpic = jsonEncode(detail.toJson());
  //         List updatelist = details.map((e) => e.toJson()).toList();

  //          save updated user detail
  //         prefs.setString(Dataloader.userdetailkey, jsonEncode(updatelist));
  //         return true;
  //       }
  //     }
  //   }
  //   return false;
  // }


//Copy code
