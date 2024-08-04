import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/models/course_categories.dart';
import 'package:socialapp/models/courses.dart';
import 'package:socialapp/models/courses_by_category.dart';
import 'package:socialapp/models/instructor.dart';
import 'package:socialapp/models/user.dart';
import 'package:socialapp/models/user_detail.dart';
import 'package:socialapp/models/user_friendlist.dart';
import 'package:socialapp/models/user_post.dart';
// Future<Map<String,dynamic>> loaduser() async {
//   String userjson = await rootBundle
//       .loadString('assets/jsonfile/user.json'); //fetch data in string
//   return jsonDecode(userjson); // returns a json structure
// }

// Loads a JSON file containing user data from the assets bundle.
// Parses the JSON string into a list of dynamic objects.
// Maps each dynamic object to a User instance using the User.fromJson constructor.
// Returns a Future that completes with a list of User objects.

//
//
// }

//use this as the data for shared prefrence as it is the one that loads all the data
//
class Dataloader {
  static String userkey = 'users';
  static String userdetailkey = 'userdetail';
  static String userpostkey = 'userpost';
  static String userdfriendlistkey = 'userfriend';
  static String friendlistkey = 'friendlist';
  static String courseskey = 'courses';
  static String coursebykey = 'coursebycategories';
  static String coursescategorykey = 'coursescategory';
  static String instructorkey = 'instrucor';
  static String sendrequestkey = 'sendrequest';
  static String receiverequestkey = 'receiverequest';

  Future loadalluserdatas() async {
    SharedPreferences prefs = await SharedPreferences
        .getInstance(); //when chnaged it get's new password

    bool isjsonLoaded = prefs.getBool('jsonDataLoaded') ?? false;

    if (!isjsonLoaded) {
      String userjson = await rootBundle
          .loadString('assets/jsonfile/user.json'); //fetch data in string
      // print('$userjson');
      prefs.setString(userkey, userjson);

      String userdetailjson =
          await rootBundle.loadString('assets/jsonfile/user_detail.json');
      prefs.setString(userdetailkey, userdetailjson);

      String userpostjson =
          await rootBundle.loadString('assets/jsonfile/user_post.json');
      prefs.setString(userpostkey, userpostjson);

      String userfriendjson =
          await rootBundle.loadString('assets/jsonfile/user_friendlist.json');
      prefs.setString(userdfriendlistkey, userfriendjson);

      String coursesjson =
          await rootBundle.loadString('assets/jsonfile/courses.json');
      prefs.setString(courseskey, coursesjson);

      String coursesbyjson = await rootBundle
          .loadString('assets/jsonfile/courses_by_categories.json');
      prefs.setString(coursebykey, coursesbyjson);

      String coursecategoryjson =
          await rootBundle.loadString('assets/jsonfile/course_categories.json');
      prefs.setString(coursescategorykey, coursecategoryjson);

      String instructorjson =
          await rootBundle.loadString('assets/jsonfile/instructor.json');
      prefs.setString(instructorkey, instructorjson);

      prefs.setBool('jsonDataLoaded', true);
    }
  }

  // gets
  Future<List<User>> getuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString(userkey); //also get password new
    if (user != null) {
      /// The line `List userlist = json.decode(user);` is decoding a JSON string stored in the variable
      /// `user` into a Dart object.
      List userlist = json.decode(user);
      return userlist.map((e) => User.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<List<User>> getloggeduser(int id) async {
    final prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString(userkey); //gets json encode data
    // print('$prefs');
    // print('$user');
    if (user != null) {
      List userlist = json.decode(user);
      return userlist
          .map((e) => User.fromJson(e))
          .where((element) => element.id == id)
          .toList();
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
  //  print('$prefs');
  //   print('$detail');
  //   print('$detaillist');

  Future<List<UserPost>> getuserpost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? post = prefs.getString(userpostkey);
    // print('$post');//working
    if (post != null) {
      List postlist = json.decode(post);
      return postlist.map((e) => UserPost.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<List<UserPost>> getloggeduserpost(int id) async {
    final prefs = await SharedPreferences.getInstance();
    String? post = prefs.getString(userpostkey);
    if (post != null) {
      List postlist = json.decode(post);
      return postlist
          .map((e) => UserPost.fromJson(e))
          .where((element) => element.userId == id)
          .toList();
    } else {
      return [];
    }
  }

  Future<List<UserFriendlist>> getfriendlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userfriend = prefs.getString(userdfriendlistkey);
    if (userfriend != null) {
      List userfriendlist = jsonDecode(userfriend);
      return userfriendlist.map((e) => UserFriendlist.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  // Future<List<UserFriendlist>> geloggedinrequest(int id) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String? request = prefs.getString(userdfriendlistkey); //loads the json file
  //   if (request != null) {
  //     List requestlist = json.decode(request);
  //     return requestlist
  //         .map((e) => UserFriendlist.fromJson(e))
  //         .where((element) => element.userId == id)
  //         .toList();
  //   } else {
  //     return [];
  //   }
  // }

  //for storing request
  Future<void> sendRequest(int senderid, int receiverid) async {
    final prefs = await SharedPreferences.getInstance();

    //load request sent for sender
    final senrequestJson = prefs.getString(sendrequestkey) ?? '[]';
    print('cureent sent request: $senrequestJson');
    List jsonlist = jsonDecode(senrequestJson);
    List<UserFriendlist> list =
        jsonlist.map((e) => UserFriendlist.fromJson(e)).toList();

//remove any existing request from sender to receiver
    list.removeWhere((element) =>
        element.requestedTo == receiverid && element.requestedBy == senderid);

    ///
    ///
    if (!list.any((element) =>
        element.requestedBy == senderid && element.requestedTo == receiverid)) {
      list.add(UserFriendlist(
        // userId: senderid,
        requestedBy: senderid,
        requestedTo: receiverid,
        hasNewRequest: true,
        hasRemoved: false,
        hasNewRequestAccepted: false,
        createdAt: DateTime.now().toIso8601String(),
      ));
      await prefs.setString(sendrequestkey, jsonEncode(list));
    }

    //load received request for receiver
    final receiverequest = prefs.getString(receiverequestkey) ?? '[]';
    List receiverjsonlist = jsonDecode(receiverequest);
    List<UserFriendlist> receiverlist =
        receiverjsonlist.map((e) => UserFriendlist.fromJson(e)).toList();

//remove any existing request from sender to receiver
    receiverlist.removeWhere((element) =>
        element.requestedBy == senderid && element.requestedTo == receiverid);

    ///
    ///
    if (!receiverlist.any((element) =>
        element.requestedBy == senderid && element.requestedTo == receiverid)) {
      receiverlist.add(UserFriendlist(
        requestedBy: senderid,
        requestedTo: receiverid,
        hasNewRequest: true,
        hasNewRequestAccepted: false,
        hasRemoved: false,
      ));
      await prefs.setString(receiverequestkey, jsonEncode(receiverlist));
    }
  }

  Future<List<UserFriendlist>> getreceiverequest(int userId) async {
    //gives the request reeived from other user
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(receiverequestkey) ?? '[]';
    List jsonlist = jsonDecode(jsonString);
    final List<UserFriendlist> list =
        jsonlist.map((jsonItem) => UserFriendlist.fromJson(jsonItem)).toList();
    // Filter requests where the user is the receiver
    return list.where((request) => request.requestedTo == userId).toList();
  }

  Future<List<UserFriendlist>> getSentFriendRequests(int userId) async {
    //gives the list of request send by the user
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(sendrequestkey) ?? '[]';

    final List<dynamic> jsonList = json.decode(jsonString);
    final List<UserFriendlist> requests =
        jsonList.map((jsonItem) => UserFriendlist.fromJson(jsonItem)).toList();

    // Filter for the sent requests
    return requests.where((request) => request.requestedBy == userId).toList();
  }

  //specifically used for updating the list of send request
  Future<void> updateSentRequest(int senderId, int receiverId,
      {bool isRejected = false}) async {
    final prefs = await SharedPreferences.getInstance();

    // Load and update the sent requests for the sender
    final sentRequestsJson = prefs.getString(sendrequestkey) ?? '[]';
    List<UserFriendlist> sentRequests = (jsonDecode(sentRequestsJson) as List)
        .map((e) => UserFriendlist.fromJson(e))
        .toList();

    sentRequests.removeWhere((request) =>
        request.requestedTo == receiverId && request.requestedBy == senderId);

    if (!isRejected) {
      sentRequests.add(UserFriendlist(
        requestedBy: senderId,
        requestedTo: receiverId,
        hasNewRequest: false,
        hasRemoved: false,
        hasNewRequestAccepted: true,
        createdAt: DateTime.now().toIso8601String(),
      ));
    }

    await prefs.setString(sendrequestkey, jsonEncode(sentRequests));

    // Load and update the received requests for the receiver
    final receivedRequestsJson = prefs.getString(receiverequestkey) ?? '[]';
    List<UserFriendlist> receivedRequests =
        (jsonDecode(receivedRequestsJson) as List)
            .map((e) => UserFriendlist.fromJson(e))
            .toList();

    receivedRequests.removeWhere((request) =>
        request.requestedBy == senderId && request.requestedTo == receiverId);

    if (!isRejected) {
      receivedRequests.add(UserFriendlist(
        requestedBy: senderId,
        requestedTo: receiverId,
        hasNewRequest: false,
        hasNewRequestAccepted: true,
        hasRemoved: false,
      ));
    }

    await prefs.setString(receiverequestkey, jsonEncode(receivedRequests));
  }

  //for getting the logged in users friendlist
  // Future<List<UserFriendlist>> getLoggedFriendlist(int userid) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final friendjson = prefs.getString('user_${userid}_friends') ?? '[]';

  //   List jsonList = jsonDecode(friendjson);
  //   //converting list of maps into list of UserFriednlist obj
  //   List<UserFriendlist> friendlist =
  //       jsonList.map((e) => UserFriendlist.fromJson(e)).toList();

  //   //filter the list for friends of the logged in user
  //   List<UserFriendlist> list = friendlist
  //       .where((element) =>
  //           element.requestedTo == userid || element.requestedBy == userid)
  //       .toList();

  //   return list;
  // }

//for getting friendlist
// Future<List<UserFriendlist>>
  Future<List<Courses>> getCourse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? courses = prefs.getString(courseskey);
    if (courses != null) {
      List courseslist = jsonDecode(courses);
      return courseslist.map((e) => Courses.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<List<CourseBy>> getcoursesby() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? coursescategory = prefs.getString(coursebykey);
    if (coursescategory != null) {
      List coursescategorylist = jsonDecode(coursescategory);
      return coursescategorylist.map((e) => CourseBy.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<List<CoursesCategory>> getcoursecategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? category = prefs.getString(coursescategorykey);
    if (category != null) {
      List categorylist = jsonDecode(category);
      return categorylist.map((e) => CoursesCategory.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<List<Instructor>> getInstructor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? instructor = prefs.getString(instructorkey);
    if (instructor != null) {
      List instructorlist = jsonDecode(instructor);
      return instructorlist.map((e) => Instructor.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  // Future<void> sendFriendRequest(UserFriendlist request) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   List<UserFriendlist> requests = [];

  //   // Load existing friend requests
  //   String? requestJson = prefs.getString(userdfriendlistkey);
  //   if (requestJson != null) {
  //     List requestList = jsonDecode(requestJson);
  //     requests = requestList.map((e) => UserFriendlist.fromJson(e)).toList();
  //   }

  //   // Add new request
  //   requests.removeWhere(
  //       (r) => r.userId == request.userId && r.friendId == request.friendId);
  //   requests.add(request);

  //   // Save updated friend requests
  //   String updatedJson = jsonEncode(requests.map((e) => e.toJson()).toList());
  //   await prefs.setString(userdfriendlistkey, updatedJson);
  // }

  Future<List<UserFriendlist>> getRequestsForUser(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    String? requestJson = prefs.getString(Dataloader.userdfriendlistkey);

    if (requestJson != null) {
      List requestList = jsonDecode(requestJson);
      List<UserFriendlist> requests =
          requestList.map((e) => UserFriendlist.fromJson(e)).toList();

      // Filter requests to show only those where the user is the friend
      return requests.where((request) => request.friendId == userId).toList();
    }

    return [];
  }
//   Future<void> updateFriendRequest(int userListId, UserFriendlist updatedRequest) async {
//   final prefs = await SharedPreferences.getInstance();
//   String? requestJson = prefs.getString('requests');

//   if (requestJson != null) {
//     try {
//       // Decode the JSON string
//       List<dynamic> requestList = jsonDecode(requestJson);

//       // Convert the list of dynamic items to a list of UserFriendlist objects
//       List<UserFriendlist> requests = requestList.map((e) => UserFriendlist.fromJson(e)).toList();

//       // Find the index of the request to be updated by userListId
//       int index = requests.indexWhere((r) => r.userListId == userListId);

//       if (index != -1) {
//         // Update the request at the found index
//         requests[index] = updatedRequest;

//         // Save the updated list back to SharedPreferences
//         await prefs.setString('requests', jsonEncode(requests.map((r) => r.toJson()).toList()));
//       } else {
//         print('Request with ID $userListId not found for update');
//       }
//     } catch (e) {
//       print('Error updating friend request: $e');
//     }
//   } else {
//     if (kDebugMode) {
//       print('No requests found in SharedPreferences');
//     }
//   }
// }
  Future<void> updateFriendRequests(
      int userId, List<UserFriendlist> updatedRequests) async {
    final prefs = await SharedPreferences.getInstance();
    String? requestJson = prefs.getString('requests');

    if (requestJson != null) {
      try {
        // Decode the JSON string
        List<dynamic> requestList = jsonDecode(requestJson);

        // Convert the list of dynamic items to a list of UserFriendlist objects
        List<UserFriendlist> requests =
            requestList.map((e) => UserFriendlist.fromJson(e)).toList();

        // Create a map for fast lookups
        Map<int, UserFriendlist> requestMap = {
          for (var r in requests) r.userListId!: r
        };

        // Update the requests in the map if they belong to the given userId
        for (var updatedRequest in updatedRequests) {
          if (updatedRequest.userId == userId) {
            requestMap[updatedRequest.userListId!] = updatedRequest;
          }
        }

        // Convert the map back to a list
        List<UserFriendlist> updatedRequestList = requestMap.values.toList();

        // Save the updated list back to SharedPreferences
        await prefs.setString('requests',
            jsonEncode(updatedRequestList.map((r) => r.toJson()).toList()));
      } catch (e) {
        print('Error updating friend requests: $e');
      }
    } else {
      print('No requests found in SharedPreferences');
    }
  }
}
