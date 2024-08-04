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
/////
///
///
///
///
///

// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:socialapp/dataloader.dart';
// import 'package:socialapp/models/user_detail.dart';
// import 'package:socialapp/models/user_friendlist.dart';

// class UserListScreen extends StatefulWidget {
//   final int loggedInUserId;

//   const UserListScreen({super.key, required this.loggedInUserId});

//   @override
//   State<UserListScreen> createState() => _UserListScreenState();
// }

// class _UserListScreenState extends State<UserListScreen> {
//   late Future<List<UserDetail>> _nonFriendUsersFuture;
//   Dataloader dataloader = Dataloader();
//   @override
//   void initState() {
//     super.initState();
//     _loadnewlist();
//   }

//   void _loadnewlist() {
//     setState(() {
//       _nonFriendUsersFuture = _getNonFriendUsers(widget.loggedInUserId);
//     });
//   }

//   void _refresh() {
//     //used for call back funtion
//     setState(() {
//       _nonFriendUsersFuture = _getNonFriendUsers(widget.loggedInUserId);
//     });
//   }

// //current user friendlist for exclusion
//   Future<List<int>> _getUserFriends(int userId) async {
//     final prefs = await SharedPreferences.getInstance();
//     final friendsJson = prefs.getString('user_${userId}_friends') ?? '[]';
//     List<int> friendIds = List<int>.from(jsonDecode(friendsJson));
//     return friendIds;
//   }

// //current users request list for wxclusion
//   Future<List<int>> _getSentRequests(int userId) async {
//     final prefs = await SharedPreferences.getInstance();
//     final sentRequestsJson = prefs.getString(Dataloader.sendrequestkey) ?? '[]';
//     List<UserFriendlist> sentRequests = (jsonDecode(sentRequestsJson) as List)
//         .map((e) => UserFriendlist.fromJson(e))
//         .toList();
//     return sentRequests.map((request) => request.requestedTo!).toList();
//   }

//   Future<List<int>> _getReceivedrequest(int userId) async {
//     final prefs = await SharedPreferences.getInstance();
//     final receivejson = prefs.getString(Dataloader.receiverequestkey) ?? '[]';
//     List<UserFriendlist> receivelist = (jsonDecode(receivejson) as List)
//         .map((e) => UserFriendlist.fromJson(e))
//         .toList();
//     return receivelist.map((e) => e.requestedBy!).toList();
//   }

// //exclusion
//   Future<List<UserDetail>> _getNonFriendUsers(int userId) async {
//     // Fetch all users
//     Dataloader dataloader = Dataloader();
//     List<UserDetail> allUsers = await dataloader.getuserdetail();

//     // Fetch friends and sent requests
//     List<int> friends = await _getUserFriends(userId);
//     List<int> sentRequests = await _getSentRequests(userId);
//     List<int> receiveRequest = await _getReceivedrequest(userId);

//     // Exclude friends and those to whom a request has been sent
//     List<UserDetail> nonFriendUsers = allUsers.where((user) {
//       return user.id != userId &&
//               !friends.contains(user.id) &&
//               !sentRequests.contains(user.id)
//           //  &&
//           // !receiveRequest.contains(user.id)
//           ;
//     }).toList();

//     return nonFriendUsers;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Non-Friend Users'),
//       ),
//       body: FutureBuilder<List<UserDetail>>(
//         future: _nonFriendUsersFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           } else if (!snapshot.hasData || (snapshot.data!.isEmpty)) {
//             return const Center(
//               child: Text('No users available'),
//             );
//           } else {
//             final List<UserDetail> nonFriendUsers = snapshot.data!;
//             return ListView.builder(
//               itemCount: nonFriendUsers.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   leading: (nonFriendUsers[index].profileImage?.isNetworkUrl ??
//                           false)
//                       ? CircleAvatar(
//                           backgroundImage: NetworkImage(
//                               nonFriendUsers[index].profileImage!.imagePath ??
//                                   ''),
//                         )
//                       : CircleAvatar(
//                           backgroundImage: FileImage(File(
//                               nonFriendUsers[index].profileImage?.imagePath ??
//                                   '')),
//                         ),
//                   title: Text(nonFriendUsers[index].basicInfo!.name!),
//                   subtitle: Text('${nonFriendUsers[index].id}'),
//                   trailing: ElevatedButton(
//                     onPressed: () async {
//                       await dataloader.sendRequest(
//                           widget.loggedInUserId, nonFriendUsers[index].id!);
//                       print(nonFriendUsers[index].id);
//                       print(widget.loggedInUserId);
//                       _refresh();
//                       //used in callback
//                       _loadnewlist();
//                     },
//                     child: Text('Send Request'),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/dataloader.dart';
import 'dart:convert';
import 'dart:io';

import 'package:socialapp/models/user_detail.dart';
import 'package:socialapp/models/user_friendlist.dart';

class UserListScreen extends StatefulWidget {
  final int loggedInUserId;

  const UserListScreen({super.key, required this.loggedInUserId});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late Future<List<UserDetail>> _allUsersFuture;
  List<UserDetail> _allUsers = [];
  List<UserDetail> _filteredUsers = [];
  String search = '';
  Dataloader dataloader = Dataloader();
  List<int> _userFriends = [];
  List<int> _sentRequests = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

//current user friend list
  Future<List<int>> _getUserFriends(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final friendsJson = prefs.getString('user_${userId}_friends') ?? '[]';
    List<int> friendIds = List<int>.from(jsonDecode(friendsJson));
    return friendIds;
  }

//current users request list for wxclusion
  Future<List<int>> _getSentRequests(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final sentRequestsJson = prefs.getString(Dataloader.sendrequestkey) ?? '[]';
    List<UserFriendlist> sentRequests = (jsonDecode(sentRequestsJson) as List)
        .map((e) => UserFriendlist.fromJson(e))
        .toList();
    return sentRequests.map((request) => request.requestedTo!).toList();
  }

  Future<void> _loadData() async {
    List<UserDetail> users = await dataloader.getuserdetail();
    List<int> friends = await _getUserFriends(widget.loggedInUserId);
    List<int> sentRequests = await _getSentRequests(widget.loggedInUserId);

    setState(() {
      _allUsers = users
          .where((user) => user.id != widget.loggedInUserId)
          .toList(); // Exclude logged-in user
      _filteredUsers = _allUsers;
      _userFriends = friends;
      _sentRequests = sentRequests;
    });
  }

  void _filterUsers(String input) {
    setState(() {
    /// The above Dart code snippet is filtering a list of users based on a search input. It is checking
    /// if the name of each user (accessed through `user.basicInfo?.name`) contains the search input
    /// (case-insensitive) using the `contains` method. If the name contains the search input, the user
    /// is included in the filtered list `_filteredUsers`.
      search = input;
      _filteredUsers = _allUsers
          .where((user) =>
              user.basicInfo?.name
                  ?.toLowerCase()
                  .contains(input.toLowerCase()) ??
              false)
          .toList();
    });
  }

  Future<void> _sendRequest(int receiverId) async {
    await dataloader.sendRequest(widget.loggedInUserId, receiverId);
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Users'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterUsers,
              decoration: const InputDecoration(
                hintText: 'Search by name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _filteredUsers.length,
        itemBuilder: (context, index) {
          final user = _filteredUsers[index];
          bool isFriend = _userFriends.contains(user.id);
          bool hasSentRequest = _sentRequests.contains(user.id);

          return ListTile(
            leading: (user.profileImage?.isNetworkUrl ?? false)
                ? CircleAvatar(
                    backgroundImage:
                        NetworkImage(user.profileImage?.imagePath ?? ''),
                  )
                : CircleAvatar(
                    backgroundImage:
                        FileImage(File(user.profileImage?.imagePath ?? '')),
                  ),
            title: Text(user.basicInfo?.name ?? 'No Name'),
            subtitle: Text('ID: ${user.id}'),
            trailing: ElevatedButton(
              onPressed: isFriend
                  ? null
                  : () async {
                      await _sendRequest(user.id!);
                    },
              child: Icon(
                isFriend
                    ? Icons.check_circle
                    : hasSentRequest
                        ? Icons.access_time
                        : Icons.add,
                color: isFriend
                    ? Colors.green
                    : hasSentRequest
                        ? Colors.orange
                        : Colors.blue,
              ),
            ),
          );
        },
      ),
    );
  }
}
