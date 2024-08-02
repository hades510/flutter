// import 'package:flutter/material.dart';
// import 'package:socialapp/authenthication/login_auth.dart';
// import 'package:socialapp/dataloader.dart';
// import 'package:socialapp/models/user_detail.dart';
// import 'package:socialapp/models/user_friendlist.dart';
// // Import your Auth class

// class UserListScreen extends StatefulWidget {
//   final int loggedInUserId;

//   UserListScreen({required this.loggedInUserId});

//   @override
//   _UserListScreenState createState() => _UserListScreenState();
// }

// class _UserListScreenState extends State<UserListScreen> {
//   late List<UserDetail> users = [];
//   late Auth auth;
//   Dataloader dataloader = Dataloader();

//   @override
//   void initState() {
//     super.initState();
//     auth = Auth(Dataloader());
//     _loadUsers();
//   }

//   Future<void> _loadUsers() async {
//     // Load users from your data source
//     // This is a placeholder method
//     // users = await loadUsersFromDataSource();
//     List<UserDetail> list = await dataloader.getuserdetail();
//     setState(() {
//       users =
//           list.where((element) => element.id != widget.loggedInUserId).toList();
//     });
//   }

//   Future<void> _sendFriendRequest(UserDetail user) async {
//     final request = UserFriendlist(
//       userId: widget.loggedInUserId,
//       friendId: user.id!,
//       requestedBy: widget.loggedInUserId,
//       createdAt: DateTime.now().toIso8601String(),
//       hasNewRequest: true,
//       hasNewRequestAccepted: false,
//       hasRemoved: false,
//     );

//     await auth.sendFriendRequest(request);

//     // Update the UI to reflect changes
//     _loadUsers();

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//           content: Text('Friend request sent to ${user.basicInfo!.name!}')),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Users')),
//       body: ListView.builder(
//         itemCount: users.length,
//         itemBuilder: (context, index) {
//           final user = users[index];
//           return ListTile(
//             title: Text(user.basicInfo!.name!),
//             trailing: ElevatedButton(
//               onPressed: () => _sendFriendRequest(user),
//               child: Text('Send Request'),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:socialapp/models/user_detail.dart';
import 'package:socialapp/models/user_friendlist.dart';

import '../authenthication/login_auth.dart';
import '../dataloader.dart';
// Assuming you have methods to send friend requests

class UserListScreen extends StatefulWidget {
  final int loggedInUserId;

  UserListScreen({required this.loggedInUserId});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<UserDetail> users = [];
  late Auth auth;
  Dataloader dataloder = Dataloader();

  @override
  void initState() {
    super.initState();
    auth = Auth(Dataloader());
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    // Load users from your data source
    // This is a placeholder method
    // users = await loadUsersFromDataSource();
    List<UserDetail> list = await dataloder.getuserdetail();
    setState(() {
      users =
          list.where((element) => element.id != widget.loggedInUserId).toList();
    });
  }

  // Future<void> _sendFriendRequest(int friendId) async {
  //   // Create a new friend request
  //   final request = UserFriendlist(
  //     // userListId: DateTime.now().microsecondsSinceEpoch,//unique id
  //     userId: widget.loggedInUserId,
  //     requestedTo: friendId,
  //     friendId: friendId,
  //     requestedBy: widget.loggedInUserId,
  //     createdAt: DateTime.now().toIso8601String(),
  //     hasNewRequest: true,
  //     hasNewRequestAccepted: false,
  //     hasRemoved: false,
  //   );

  //   // Send the friend request to  local data source
  //   await auth.sendFriendRequest(request);
  //   _loadUsers();

  //   // Update UI or show confirmation
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text('Friend request sent to user $friendId')),
  //   );
  // }
  // Future<void> sendFriendRequest(int senderId, int receiverId) async {
  //   // Create a new friend request object
  //   UserFriendlist newRequest = UserFriendlist(
  //     userListId: DateTime.now().millisecondsSinceEpoch, // or another unique ID
  //     userId: senderId,
  //     friendId: receiverId,
  //     requestedBy: senderId,
  //     createdAt: DateTime.now().toIso8601String(),
  //     hasNewRequest: true,
  //     hasNewRequestAccepted: false,
  //     hasRemoved: false,
  //   );

  //   // Fetch existing requests for both sender and receiver
  //   List<UserFriendlist> senderRequests =
  //       await dataloder.geloggedinrequest(senderId);
  //   List<UserFriendlist> receiverRequests =
  //       await dataloder.geloggedinrequest(receiverId);

  //   // Update the sender's list
  //   senderRequests.add(newRequest);
  //   await dataloder.updateFriendRequests(senderId, senderRequests);

  //   // Update the receiver's list
  //   receiverRequests.add(newRequest);
  //   await dataloder.updateFriendRequests(receiverId, receiverRequests);

  //   // await dataloder.saverequest(senderRequests);
  //   setState(() {
  //     print('Friend request sent from user $senderId to user $receiverId.');
  //   });

  //   // Optionally, notify both users about the new request
  //   // (implementation depends on how you handle notifications)
  // }

  // Future <void> _sendrequest()
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User List')),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            leading: user.profileImage != null
                ? (user.profileImage!.isNetworkUrl ?? false)
                    ? CircleAvatar(
                        backgroundImage:
                            NetworkImage(user.profileImage!.imagePath!),
                      )
                    : CircleAvatar(
                        backgroundImage:
                            FileImage(File(user.profileImage!.imagePath!)),
                      )
                : const CircleAvatar(child: Icon(Icons.person)),
            title: Text(user.basicInfo!.name!),
            subtitle: Text('User ID: ${user.id}'),
            trailing: ElevatedButton(
              onPressed: () async {
                await dataloder.sendRequest(widget.loggedInUserId, user.id!);
                
                // sendFriendRequest(
                //     widget.loggedInUserId, user.id!); //recevier id
                print(user.id); //request send to
                print(widget.loggedInUserId); //request send by
              },
              child: Text('Send Request'),
            ),
          );
        },
      ),
    );
  }
}

//
