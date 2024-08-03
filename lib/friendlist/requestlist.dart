import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../authenthication/login_auth.dart';
import '../dataloader.dart';
import '../models/user_detail.dart';
import '../models/user_friendlist.dart';

class ReceivedFriendRequestsScreen extends StatefulWidget {
  //received list
  final int userId; // logged user id
  final VoidCallback onRequestRejected;

  const ReceivedFriendRequestsScreen(
      {super.key, required this.userId, required this.onRequestRejected});

  @override
  State<ReceivedFriendRequestsScreen> createState() =>
      _ReceivedFriendRequestsScreenState();
}

class _ReceivedFriendRequestsScreenState
    extends State<ReceivedFriendRequestsScreen> {
  List<UserDetail> users = [];
  List<UserFriendlist> requestlist = [];
  List<UserDetail> acceptedlist = [];
  late Auth auth;
  UserDetail? userDetail;
  @override
  void initState() {
    super.initState();
    auth = Auth(Dataloader());
    _loadedetail();
    _loaddata();
  }

  void _loadedetail() async {
    UserDetail? detail = await auth.getloggedinuser();
    setState(() {
      userDetail = detail;
    });
  }

  Future<void> _loaddata() async {
    Dataloader dataloader = Dataloader();
    List<UserDetail> userDetail = await dataloader
        .getuserdetail(); //getting all the details of the user basically for displaying the user
    List<UserFriendlist> flist =
        await dataloader.getreceiverequest(widget.userId);
    // List<UserDetail> accepted =
    //     await dataloader.getAcceptedFriends(widget.userId);
    setState(() {
      users = userDetail;
      requestlist = flist;
      // acceptedlist = accepted;
    });
  }

  void _accept(UserFriendlist request) async {
    Dataloader dataloader = Dataloader();
    //handling if accepted
    //update the shared preferences
    final prefs = await SharedPreferences.getInstance();

    //if accepted remove it from list of requst
    final requestJson = prefs.getString(Dataloader.receiverequestkey) ?? '[]';
    List jsonList = jsonDecode(requestJson);
    List<UserFriendlist> requestreceived =
        jsonList.map((e) => UserFriendlist.fromJson(e)).toList();

    requestreceived.removeWhere((element) =>
        element.requestedBy == request.requestedBy &&
        element.requestedTo == request.requestedTo);

    await prefs.setString(
        Dataloader.receiverequestkey, jsonEncode(requestreceived));

    //update the send request list
    final sentrequestjson = prefs.getString(Dataloader.sendrequestkey) ?? '[]';
    List jsonlist = jsonDecode(sentrequestjson);
    List<UserFriendlist> requestsend =
        jsonlist.map((e) => UserFriendlist.fromJson(e)).toList();

    final requestindex = requestsend.indexWhere((element) =>
        element.requestedTo == request.requestedTo &&
        element.requestedBy == request.requestedBy);

    if (requestindex != -1) {
      //empty
      requestsend[requestindex] =
          requestsend[requestindex].copyWith(hasNewRequestAccepted: true);
      await prefs.setString(Dataloader.sendrequestkey, jsonEncode(requestsend));
    }
    _updateFriendLists(request.requestedBy!, request.requestedTo!);

    setState(() {
      //refresh
    });
  }

//update both the list used on accept only
  void _updateFriendLists(int user1Id, int user2Id) async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve existing friend lists
    final user1FriendsJson = prefs.getString('user_${user1Id}_friends') ?? '[]';
    List jsonListUser1 = jsonDecode(user1FriendsJson);
    List<int> user1Friends = List<int>.from(jsonListUser1);

    final user2FriendsJson = prefs.getString('user_${user2Id}_friends') ?? '[]';
    List jsonListUser2 = jsonDecode(user2FriendsJson);
    List<int> user2Friends = List<int>.from(jsonListUser2);

    // Add each other to friend lists
    user1Friends.add(user2Id);
    user2Friends.add(user1Id);

    // Save updated friend lists
    await prefs.setString('user_${user1Id}_friends', jsonEncode(user1Friends));
    await prefs.setString('user_${user2Id}_friends', jsonEncode(user2Friends));
  }

  void _reject(UserFriendlist request) async {
    final prefs = await SharedPreferences.getInstance();
    //remove from list of request
    final requestjson = prefs.getString(Dataloader.receiverequestkey) ?? '[]';
    List jsonList = jsonDecode(requestjson);
    List<UserFriendlist> requestreceived =
        jsonList.map((e) => UserFriendlist.fromJson(e)).toList();

    requestreceived.removeWhere((element) =>
        element.requestedBy == request.requestedBy &&
        element.requestedTo == request.requestedTo);

    await prefs.setString(
        Dataloader.receiverequestkey, jsonEncode(requestreceived));
    await Dataloader().updateSentRequest(
        request.requestedBy!, request.requestedTo!,
        isRejected: true);
    widget.onRequestRejected();

    //added steps which worked
    // final sentRequestJson = prefs.getString(Dataloader.sendrequestkey) ?? '[]';
    // List jsonListSent = jsonDecode(sentRequestJson);
    // List<UserFriendlist> requestSent =
    //     jsonListSent.map((e) => UserFriendlist.fromJson(e)).toList();

    // final requestIndex = requestSent.indexWhere((element) =>
    //     element.requestedTo == request.requestedTo &&
    //     element.requestedBy == request.requestedBy);

    // if (requestIndex != -1) {
    //   // Update status of the sent request
    //   requestSent[requestIndex] = requestSent[requestIndex].copyWith(
    //     hasRemoved: true,
    //   );
    //   await prefs.setString(Dataloader.sendrequestkey, jsonEncode(requestSent));
    // }

    setState(() {
      //refreshing
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Received Friend Requests'),
      ),
      body: FutureBuilder(
        future: _fetchFriendRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData ||
              (snapshot.data as List<UserFriendlist>).isEmpty) {
            return const Center(
              child: Text('No friend requests'),
            );
          } else {
            final List<UserFriendlist> friendRequests =
                snapshot.data as List<UserFriendlist>;
            return ListView.builder(
              itemCount: friendRequests.length,
              itemBuilder: (context, index) {
                return friendRequests.isNotEmpty
                    ? _buildRequestItem(friendRequests[index])
                    : const Text('No request');
              },
            );
          }
        },
      ),
    );
  }

  Future _fetchFriendRequests() async {
    //loads the list
    Dataloader dataloader = Dataloader();
    return dataloader.getreceiverequest(widget.userId);
  }

  UserDetail getid(int id) {
    return users.firstWhere((element) => element.id == id);
  }

  Widget _buildRequestItem(UserFriendlist request) {
    UserDetail detail = getid(request.requestedBy!);
    return ListTile(
      leading: (detail.profileImage?.isNetworkUrl ?? false)
          ? CircleAvatar(
              backgroundImage:
                  NetworkImage(detail.profileImage!.imagePath ?? ''),
            )
          : CircleAvatar(
              backgroundImage:
                  FileImage(File(detail.profileImage?.imagePath ?? '')),
            ),
      title: Text(detail.basicInfo!.name!),
      subtitle: Text('${detail.id}'),
      trailing: Row(
        /// The above code snippet is written in Dart and it is setting the `mainAxisSize` property to
        /// `MainAxisSize.min`. This property is typically used in Flutter widgets to control the size of
        /// the main axis of a widget, such as a Row or Column. Setting it to `MainAxisSize.min` means
        /// that the widget should take up the minimum amount of space along the main axis.
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              onPressed: () {
                _accept(request);
              },
              icon: const Icon(
                Icons.check,
                color: Colors.green,
              )),
          IconButton(
              onPressed: () {
                _reject(request);
              },
              icon: const Icon(
                Icons.cancel,
                color: Colors.red,
              )),
        ],
      ),
    );
  }
}

// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:socialapp/authenthication/login_auth.dart';
// import 'package:socialapp/dataloader.dart';
// import 'package:socialapp/models/user_detail.dart';
// import 'package:socialapp/models/user_friendlist.dart';
// import 'package:socialapp/models/user_post.dart';

// class FriendRequest extends StatelessWidget {
//   final int loggedInUserId;
//   const FriendRequest({
//     super.key,
//     required this.loggedInUserId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Friend List'),
//       ),
//       body: FutureBuilder(
//         future: _fetchdata(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(
//                 backgroundColor: Colors.black,
//               ),
//             );
//           } else if (snapshot.hasError) {
//             return Text('${snapshot.error}');
//           } else {
//             return FriendRequestScreen(
//               friendlist: snapshot.data['friendlist'],
//               userDetail: snapshot.data['userDetail'],
//               userpost: snapshot.data['userpost'],
//             );
//           }
//         },
//       ),
//     );
//   }

//   Future _fetchdata() async {
//     Dataloader dataloader = Dataloader();
//     List<UserFriendlist> friendlist =
//         await dataloader.geloggedinrequest(loggedInUserId);
//     List<UserDetail> userDetail = await dataloader.getuserdetail();
//     List<UserPost> userpost = await dataloader.getuserpost();
//     return {
//       'friendlist': friendlist,
//       'userDetail': userDetail,
//       'userpost': userpost // for loading the post on the other profile screen
//     };
//   }
// }

// class FriendRequestScreen extends StatefulWidget {
//   List<UserFriendlist> friendlist;
//   List<UserDetail> userDetail;
//   List<UserPost> userpost;
//   FriendRequestScreen(
//       {super.key,
//       required this.friendlist,
//       required this.userDetail,
//       required this.userpost});

//   @override
//   State<FriendRequestScreen> createState() => _FriendRequestScreenState();
// }

// Dataloader dataloader = Dataloader();
// late Auth auth;
// UserDetail? userDetail;
// List<UserFriendlist>? friendlist;

// class _FriendRequestScreenState extends State<FriendRequestScreen> {
//   @override
//   void initState() {
//     super.initState();
//     auth = Auth(dataloader);
//     _loaduserDetail();
//     _loadrequest();
//   }

//   void _loaduserDetail() async {
//     UserDetail? detail = await auth.getloggedinuser();
//     setState(() {
//       userDetail = detail;
//     });
//   }

//   void _loadrequest() async {
//     List<UserFriendlist> list = await dataloader.loadrequest();
//     setState(() {
//       friendlist = list;
//     });
//   }

//   // Future<void> updateFriendRequest(UserFriendlist request) async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   String? requestJson = prefs.getString('requests');

//   //   if (requestJson != null) {
//   //     List requestList = jsonDecode(requestJson);
//   //     List<UserFriendlist> requests =
//   //         requestList.map((e) => UserFriendlist.fromJson(e)).toList();

//   //     // Update the request in the list
//   //     var index =
//   //         requests.indexWhere((r) => r.userListId == request.userListId);
//   //     if (index != -1) {
//   //       requests[index] = request;
//   //       prefs.setString(
//   //           'requests', jsonEncode(requests.map((r) => r.toJson()).toList()));
//   //     }
//   //   }
//   // }

//   // Future<void> _acceptRequest(UserFriendlist request) async {
//   //   request.hasNewRequest = false;
//   //   request.hasNewRequestAccepted = true;

//   //   await updateFriendRequest(request);

//   //   setState(() {});
//   //   // Notify the user
//   //   ScaffoldMessenger.of(context).showSnackBar(
//   //     SnackBar(content: Text('Friend request accepted')),
//   //   );

//   //   // Refresh the UI
//   // }

//   // Future<void> _rejectRequest(UserFriendlist request) async {
//   //   // Update the request status
//   //   request.hasNewRequest = false;
//   //   request.hasRemoved = true;

//   //   // Update the request in the data source
//   //   await updateFriendRequest(request);

//   //   // Notify the user
//   //   ScaffoldMessenger.of(context).showSnackBar(
//   //     SnackBar(content: Text('Friend request rejected')),
//   //   );

//   //   // Refresh the UI
//   //   setState(() {});
//   // }

//   // void _showRequestDialog(BuildContext context, UserFriendlist request) {
//   //   showDialog(
//   //     context: context,
//   //     builder: (context) {
//   //       return AlertDialog(
//   //         title: Text(
//   //             'Friend Request from ${getid(request.userId!).basicInfo!.name!}'),
//   //         content: Text('Do you want to accept or reject this friend request?'),
//   //         actions: [
//   //           TextButton(
//   //             onPressed: () {
//   //               _acceptRequest(request);
//   //               Navigator.of(context).pop();
//   //             },
//   //             child: Text('Accept'),
//   //           ),
//   //           TextButton(
//   //             onPressed: () {
//   //               _rejectRequest(request);
//   //               Navigator.of(context).pop();
//   //             },
//   //             child: Text('Reject'),
//   //           ),
//   //         ],
//   //       );
//   //     },
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView.builder(
//         itemCount: widget.friendlist.length,
//         itemBuilder: (context, index) {
//           // final request = widget.friendlist[index];
//           return _buildfriednList(widget.friendlist[index]);
//         },
//       ),
//     );
//   }
// //used for getting the user details

//   UserDetail getid(int userid) {
//     return widget.userDetail.firstWhere((element) => element.id == userid);
//   }
// //used for getting the userpost

//   List<UserPost> getUserPosts(int userId) {
//     return widget.userpost.where((post) => post.userId == userId).toList();
//   }

//   Widget _buildfriednList(UserFriendlist model) {
//     UserDetail detail = getid(model.friendId!);
//     return ListTile(
//       leading: (detail.profileImage?.isNetworkUrl ?? false)
//           ? CircleAvatar(
//               backgroundImage:
//                   NetworkImage(detail.profileImage!.imagePath ?? ''),
//             )
//           : CircleAvatar(
//               backgroundImage:
//                   FileImage(File(detail.profileImage?.imagePath ?? '')),
//             ),
//       title: Text(detail.basicInfo!.name!),
//       subtitle: Text('Friend ID: ${model.friendId}'),
//       trailing: _buildStatusBadge(model),
//       // onTap: () {
//       //   if (model.hasNewRequestAccepted != true) {
//       //     _showRequestDialog(context, model);
//       //   }
//       // },
//       // onTap: () {
//       //   Navigator.push(
//       //     context,
//       //     MaterialPageRoute(
//       //       builder: (context) => OtherProfiles(
//       //         userDetail: detail,
//       //         userpost: getUserPosts(detail.id!),
//       //       ), //don't understand why use detail instead of userDetail
//       //     ),
//       //   );
//       // },
//     );
//   }

//   Widget _buildStatusBadge(UserFriendlist request) {
//     if (request.hasRemoved!) {
//       return const Icon(Icons.cancel, color: Colors.red);
//     } else if (request.hasNewRequestAccepted!) {
//       return const Icon(Icons.check_circle, color: Colors.green);
//     } else if (request.hasNewRequest!) {
//       return Icon(Icons.access_time, color: Colors.blue);
//     } else {
//       return const Icon(Icons.done, color: Colors.grey);
//     }
//   }
// }
//
