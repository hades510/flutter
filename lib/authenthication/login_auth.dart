import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/dataloader.dart';
import 'package:socialapp/models/user_detail.dart';
import 'package:socialapp/models/user_friendlist.dart';
import 'package:socialapp/models/user_post.dart';

import '../models/user.dart';

class Auth {
  static String isUserloggedin =
      'Logged'; //use this key to save the data updated

  Dataloader dataloader;
  Auth(this.dataloader);
//login
  Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    String? userjson = prefs.getString(Dataloader.userkey);
    if (userjson != null) {
      List userlist = json.decode(userjson);
      List<User> users = userlist.map((e) => User.fromJson(e)).toList();
//iterates through list f users
      for (User e in users) {
        if (e.email == email && e.password == password) {
          String? userdetailjson = prefs.getString(Dataloader.userdetailkey);

          if (userdetailjson != null) {
            // Decodes the JSON string to a list of UserDetail objects and finds the one matching the logged-in user’s ID.
            List detaillist = json.decode(userdetailjson);
            List<UserDetail> details =
                detaillist.map((e) => UserDetail.fromJson(e)).toList();

            UserDetail userdetailmatch =
                details.firstWhere((element) => element.id == e.id);

            if (userdetailmatch != null) {
              // Saves the JSON string of the UserDetail object under the key isUserloggedin.
              //This key is used to store the details of the logged-in user, effectively marking them as logged in.
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

  Future<bool> forgotpassword(String email, String newpassword) async {
    final prefs = await SharedPreferences.getInstance();
    String? userjson = prefs.getString(Dataloader.userkey);
//got the value and created a list of objects
    if (userjson != null) {
      List userlist = jsonDecode(userjson);
      List<User> users = userlist.map((e) => User.fromJson(e)).toList();

      for (User user in users) {
        if (user.email == email) {
          user.password = newpassword;

          String updatedjson = jsonEncode(user.toJson());
          List updatelist = users.map((e) => e.toJson()).toList();

          prefs.setString(Dataloader.userkey, jsonEncode(updatelist));
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

  //add user detail(did this mainly for signing new users,as during login i compared user and userdetail id so )
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

  Future<void> updateReactforPost(
      int postId, bool isLiked, bool isDisliked, int loggedId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? postsJson = prefs.getString(
        Dataloader.userpostkey); //retrieves the json string og the post

    if (postsJson != null) {
      // Decode the JSON string to get the list of posts
      List<dynamic> postsList = jsonDecode(
          postsJson); // converts tha above json string to the list of dynamic objects
      // Convert the list to a list of UserPost objects
      List<UserPost> updatedPosts =
          postsList.map((postJson) => UserPost.fromJson(postJson)).toList();

      // Find the post with the matching ID
      UserPost? postToUpdate = updatedPosts.firstWhere(
        (post) => post.postId == postId,
      ); //ensures that only the wanted post is updated rather than affecting all the post
      if (postToUpdate != null) {
        // Update the like/dislike states
        postToUpdate.isliked = isLiked;
        postToUpdate.isDisliked = isDisliked;

        // Update the like/dislike counts
        if (isLiked) {
          postToUpdate.postLikedBy ??= [];

          if (!postToUpdate.postLikedBy!
              .any((like) => like.userId == loggedId)) {
            postToUpdate.postLikedBy!.add(PostLikedBy(
                userId: loggedId, dateTime: DateTime.now().toIso8601String()));
            // Icon(Icons.thumb_up_alt);
          }

          /// Output: 2024-07-31T12:59:57.123456Z (example format)
          if (postToUpdate.isDisliked ?? true) {
            postToUpdate.isDisliked = false;
            postToUpdate.postLikedBy!.removeWhere(
                (like) => like.userId == loggedId); // Remove dislike
            // Icon(Icons.thumb_up_alt_outlined);
          }
        } else {
          postToUpdate.postLikedBy
              ?.removeWhere((like) => like.userId == loggedId); // Remove like
        }

        if (isDisliked) {
          if (postToUpdate.postLikedBy
                  ?.any((like) => like.userId == loggedId) ??
              false) {
            postToUpdate.postLikedBy!.removeWhere(
                (like) => like.userId == loggedId); // Remove like ifp disliked
          }
        }

        // Convert the updated list back to JSON
        String updatedPostsJson =
            jsonEncode(updatedPosts.map((post) => post.toJson()).toList());
        // Save the updated JSON string to SharedPreferences
        await prefs.setString(Dataloader.userpostkey, updatedPostsJson);
      }
    }
  }

  Future<void> updateReactforImage(
      int postID, int imageID, bool isliked, bool isDisliked) async {
    final prefs = await SharedPreferences.getInstance();
    String? postjson = prefs.getString(Dataloader.userpostkey);

    if (postjson != null) {
      List postlist = json.decode(postjson);
      List<UserPost> updatedpost =
          postlist.map((e) => UserPost.fromJson(e)).toList();

      UserPost? postToupdate =
          updatedpost.firstWhere((element) => element.postId == postID);

      if (postToupdate != null) {
        Postedphoto? imageToupdate =
            postToupdate.image!.firstWhere((element) => element.id == imageID);
        if (imageToupdate != null) {
          imageToupdate.isLiked = isliked;
          imageToupdate.isDisliked = isDisliked;

          if (isliked) {
            imageToupdate.likeCount = (imageToupdate.likeCount ?? 0) + 1;
            if (imageToupdate.isDisliked!) {
              imageToupdate.isDisliked = false;
              imageToupdate.likeCount = (imageToupdate.likeCount ?? 0) - 1;
            }
          } else {
            if (imageToupdate.isLiked!) {
              imageToupdate.isLiked = false;
              imageToupdate.likeCount = (imageToupdate.likeCount ?? 0) - 1;
            }
          }
          if (isDisliked) {
            imageToupdate.likeCount = (imageToupdate.likeCount ?? 0) - 1;
            if (imageToupdate.isLiked!) {
              imageToupdate.isLiked = false;
              imageToupdate.likeCount = (imageToupdate.likeCount ?? 0) - 1;
            }
          }
          String updatedpostjson =
              json.encode(updatedpost.map((e) => e.toJson()).toList());
          await prefs.setString(Dataloader.userpostkey, updatedpostjson);
        }
      }
    }
  }

  // Future<void> sendFriendRequest(UserFriendlist request) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String? requestJson = prefs.getString('requests');

  //   List<UserFriendlist> requests = [];
  //   if (requestJson != null) {
  //     List requestList = jsonDecode(requestJson);
  //     requests = requestList.map((e) => UserFriendlist.fromJson(e)).toList();
  //   }

  //   // Add or update the friend request
  //   requests.removeWhere(
  //       (r) => r.userId == request.userId && r.friendId == request.friendId);
  //   requests.add(request);

  //   // Save updated friend requests back to SharedPreferences
  //   prefs.setString(
  //       'requests', jsonEncode(requests.map((r) => r.toJson()).toList()));
  // }
  // Future<void> updateFriendRequest(UserFriendlist request) async {

  //   final prefs = await SharedPreferences.getInstance();
  //   String? requestJson = prefs.getString(Dataloader.userdfriendlistkey);

  //   if (requestJson != null) {
  //     List requestList = jsonDecode(requestJson);
  //     List<UserFriendlist> requests = requestList.map((e) => UserFriendlist.fromJson(e)).toList();

  //     // Update the request in the list
  //     var index = requests.indexWhere((r) => r.userListId == request.userListId);
  //     if (index != -1) {
  //       requests[index] = request;
  //       prefs.setString(Dataloader.userdfriendlistkey, jsonEncode(requests.map((r) => r.toJson()).toList()));
  //     }
  //   }
  // }
  // Future<List<UserFriendlist>> _getFriendRequests() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String? jsonString = prefs.getString('friend_requests');
  //   if (jsonString == null) return [];
  //   List<dynamic> jsonList = jsonDecode(jsonString);
  //   return jsonList.map((json) => UserFriendlist.fromJson(json)).toList();
  // }

  // Future<void> _saveFriendRequests(List<UserFriendlist> requests) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String jsonString = jsonEncode(requests.map((req) => req.toJson()).toList());
  //   await prefs.setString('friend_requests', jsonString);
  // }

  // Future<void> sendFriendRequest(UserFriendlist request) async {
  //   List<UserFriendlist> requests = await _getFriendRequests();
  //   requests.add(request);
  //   await _saveFriendRequests(requests);
  // }

  // Future<void> acceptFriendRequest(int userListId) async {
  //   List<UserFriendlist> requests = await _getFriendRequests();
  //   UserFriendlist? request = requests.firstWhere((req) => req.userListId == userListId, );

  //   if (request != null) {
  //     request.hasNewRequestAccepted = true;
  //     request.hasNewRequest = false;
  //     await _saveFriendRequests(requests);
  //   }
  // }

  // Future<List<UserFriendlist>> getUserRequests(int userId) async {
  //   List<UserFriendlist> requests = await _getFriendRequests();
  //   return requests.where((req) => req.friendId == userId && !req.hasRemoved!).toList();
  // }

  // Future<List<UserFriendlist>> getUserFriends(int userId) async {
  //   List<UserFriendlist> requests = await _getFriendRequests();
  //   return requests.where((req) => req.userId == userId && req.hasNewRequestAccepted!).toList();
  // }
}
