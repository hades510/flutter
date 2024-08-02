import 'dart:io';

import 'package:flutter/material.dart';

import '../authenthication/login_auth.dart';
import '../dataloader.dart';
import '../models/user_detail.dart';
import '../models/user_friendlist.dart';

class ReceivedFriendRequestsScreen extends StatefulWidget {
  final int userId;

  const ReceivedFriendRequestsScreen({super.key, required this.userId});

  @override
  State<ReceivedFriendRequestsScreen> createState() =>
      _ReceivedFriendRequestsScreenState();
}

class _ReceivedFriendRequestsScreenState
    extends State<ReceivedFriendRequestsScreen> {
  List<UserDetail> users = [];
  List<UserFriendlist> requestlist = [];
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
    List<UserDetail> userDetail = await dataloader.getuserdetail();
    List<UserFriendlist> flist =
        await dataloader.getreceiverequest(widget.userId);
    setState(() {
      users = userDetail;
      requestlist = flist;
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
                    :const Text('No request');
              },
            );
          }
        },
      ),
    );
  }

  Future _fetchFriendRequests() async {
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
