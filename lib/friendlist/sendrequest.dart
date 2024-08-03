// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:socialapp/models/user_detail.dart';
// import 'package:socialapp/models/user_friendlist.dart';

// import '../authenthication/login_auth.dart';
// import '../dataloader.dart';
// // Assuming you have methods to send friend requests

// class UserListScreen extends StatefulWidget {
//   final int loggedInUserId; //current logged in user

//   UserListScreen({required this.loggedInUserId});

//   @override
//   _UserListScreenState createState() => _UserListScreenState();
// }

// class _UserListScreenState extends State<UserListScreen> {
//   List<UserDetail> users = [];
//   List<UserDetail> friends = []; //stores the friends of the logged in
//   late Auth auth;
//   Dataloader dataloder = Dataloader();

//   @override
//   void initState() {
//     super.initState();
//     auth = Auth(Dataloader());
//     _loadUsers();
//     // _loadFriends();
//   }

//   Future<void> _loadUsers() async {
//     // Load users from your data source
//     // This is a placeholder method
//     // users = await loadUsersFromDataSource();
//     List<UserDetail> list = await dataloder.getuserdetail();
//     setState(() {
//       //filter out the logged in user from the list
//       users =
//           list.where((element) => element.id != widget.loggedInUserId).toList();
//     });
//   }

// //   Future<void> _loadFriends() async {
// //     List<UserFriendlist> friendlist =
// //         await dataloder.getLoggedFriendlist(widget.loggedInUserId);
// //     List<int> friendsid = friendlist
// //         .map((e) => e.requestedTo == widget.loggedInUserId
// //             ? e.requestedBy!
// //             : e.requestedTo!).toSet()// to set is used to insure that no duplicate users appear in the list
// //         .toList();
// // ///converts the list to set and then back to list to remove duplicates since sets inherently do not allow duplicate valuse
// //         //
// //     //filter friend fro the user list
// //     setState(() {
// //       users =
// //           users.where((element) => !friendsid.contains(element.id)).toList();
// //     });
// //   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('User List')),
//       body: ListView.builder(
//         itemCount: users.length,
//         itemBuilder: (context, index) {
//           final user = users[index];
//           return ListTile(
//             leading: user.profileImage != null
//                 ? (user.profileImage!.isNetworkUrl ?? false)
//                     ? CircleAvatar(
//                         backgroundImage:
//                             NetworkImage(user.profileImage!.imagePath!),
//                       )
//                     : CircleAvatar(
//                         backgroundImage:
//                             FileImage(File(user.profileImage!.imagePath!)),
//                       )
//                 : const CircleAvatar(child: Icon(Icons.person)),
//             title: Text(user.basicInfo!.name!),
//             subtitle: Text('User ID: ${user.id}'),
//             trailing: ElevatedButton(
//               onPressed: () async {
//                 await dataloder.sendRequest(widget.loggedInUserId, user.id!);

//                 // sendFriendRequest(
//                 //     widget.loggedInUserId, user.id!); //recevier id
//                 print(user.id); //request send to
//                 print(widget.loggedInUserId); //request send by
//               },
//               child: Text('Send Request'),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// //

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/dataloader.dart';
import 'package:socialapp/friendlist/requestlist.dart';
import 'package:socialapp/models/user_detail.dart';
import 'package:socialapp/models/user_friendlist.dart';

class UserListScreen extends StatefulWidget {
  final int loggedInUserId;

  const UserListScreen({super.key, required this.loggedInUserId});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late Future<List<UserDetail>> _nonFriendUsersFuture;
  Dataloader dataloader = Dataloader();

  @override
  void initState() {
    super.initState();
    _loadnewlist();
  }

  void _loadnewlist() {
    setState(() {
      _nonFriendUsersFuture = _getNonFriendUsers(widget.loggedInUserId);
    });
  }
//current user friendlist
  Future<List<int>> _getUserFriends(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final friendsJson = prefs.getString('user_${userId}_friends') ?? '[]';
    List<int> friendIds = List<int>.from(jsonDecode(friendsJson));
    return friendIds;
  }
//current users request list
  Future<List<int>> _getSentRequests(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final sentRequestsJson = prefs.getString(Dataloader.sendrequestkey) ?? '[]';
    List<UserFriendlist> sentRequests = (jsonDecode(sentRequestsJson) as List)
        .map((e) => UserFriendlist.fromJson(e))
        .toList();
    return sentRequests.map((request) => request.requestedTo!).toList();
  }

  Future<List<UserDetail>> _getNonFriendUsers(int userId) async {
    // Fetch all users
    Dataloader dataloader = Dataloader();
    List<UserDetail> allUsers = await dataloader.getuserdetail();
    
    // Fetch friends and sent requests
    List<int> friends = await _getUserFriends(userId);
    List<int> sentRequests = await _getSentRequests(userId);

    // Exclude friends and those to whom a request has been sent
    List<UserDetail> nonFriendUsers = allUsers.where((user) {
      return user.id != userId &&
          !friends.contains(user.id) &&
          !sentRequests.contains(user.id);
    }).toList();

    return nonFriendUsers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Non-Friend Users'),
      ),
      body: FutureBuilder<List<UserDetail>>(
        future: _nonFriendUsersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || (snapshot.data!.isEmpty)) {
            return const Center(
              child: Text('No users available'),
            );
          } else {
            final List<UserDetail> nonFriendUsers = snapshot.data!;
            return ListView.builder(
              itemCount: nonFriendUsers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: (nonFriendUsers[index].profileImage?.isNetworkUrl ??
                          false)
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(
                              nonFriendUsers[index].profileImage!.imagePath ??
                                  ''),
                        )
                      : CircleAvatar(
                          backgroundImage: FileImage(File(
                              nonFriendUsers[index].profileImage?.imagePath ??
                                  '')),
                        ),
                  title: Text(nonFriendUsers[index].basicInfo!.name!),
                  subtitle: Text('${nonFriendUsers[index].id}'),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      await dataloader.sendRequest(
                          widget.loggedInUserId, nonFriendUsers[index].id!);
                      print(nonFriendUsers[index].id);
                      print(widget.loggedInUserId);
                      //used in callback
                    },
                    child: Text('Send Request'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
