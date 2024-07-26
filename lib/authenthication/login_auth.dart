import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/dataloader.dart';
import 'package:socialapp/models/user_detail.dart';

import '../models/user.dart';

class Auth {
  static String 
  isUserloggedin =
      'Logged'; //use this key to save the data updated

  Dataloader dataloader;
  Auth(this.dataloader);
//login
  Future<bool> login(String email, String password) async {
    //retrived data to shared prefernces
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userjson = prefs.getString(Dataloader.userkey);
    if (userjson != null) {
      //decoding json data to list of user obj
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
}

/*
class NewsFeedPage extends StatefulWidget {
  @override
  _NewsFeedPageState createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  late Auth auth;
  UserDetail? currentUserDetail;

  @override
  void initState() {
    super.initState();
    auth = Auth(Dataloader());
    _loadUserDetail();
  }

  Future<void> _loadUserDetail() async {
    final userId = 'current_user_id'; // Get the logged-in user's ID
    final detail = await auth.getUserDetail(userId);
    setState(() {
      currentUserDetail = detail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('News Feed')),
      body: currentUserDetail == null
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                // Display user details
                ListTile(
                  leading: currentUserDetail!.profileImage != null
                      ? Image.file(
                          File(currentUserDetail!.profileImage!.imagePath!),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : Icon(Icons.account_circle, size: 50),
                  title: Text(currentUserDetail!.name ?? 'No Name'),
                ),
                // Display posts and other news feed content
              ],
            ),
    );
  }
}
*/
