import 'dart:io';

import 'package:flutter/material.dart';

import 'package:socialapp/authenthication/login_auth.dart';
import 'package:socialapp/dataloader.dart';
import 'package:socialapp/models/user_detail.dart';
import 'package:socialapp/models/user_friendlist.dart';
import 'package:socialapp/models/user_post.dart';

class OnlyFriendlist extends StatelessWidget {
  final int loggedInUserId;
  const OnlyFriendlist({
    super.key,
    required this.loggedInUserId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friend List'),
      ),
      body: FutureBuilder(
        future: _fetchdata(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black,
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            return FriendRequestScreen(
              friendlist: snapshot.data['friendlist'],
              userDetail: snapshot.data['userDetail'],
              userpost: snapshot.data['userpost'],
            );
          }
        },
      ),
    );
  }

  Future _fetchdata() async {
    Dataloader dataloader = Dataloader();
    List<UserFriendlist> friendlist =
        await dataloader.geloggedinrequest(loggedInUserId);
    List<UserDetail> userDetail = await dataloader.getuserdetail();
    List<UserPost> userpost = await dataloader.getuserpost();
    return {
      'friendlist': friendlist,
      'userDetail': userDetail,
      'userpost': userpost // for loading the post on the other profile screen
    };
  }
}

class FriendRequestScreen extends StatefulWidget {
  List<UserFriendlist> friendlist;
  List<UserDetail> userDetail;
  List<UserPost> userpost;
  FriendRequestScreen(
      {super.key,
      required this.friendlist,
      required this.userDetail,
      required this.userpost});

  @override
  State<FriendRequestScreen> createState() => _FriendRequestScreenState();
}

Dataloader dataloader = Dataloader();
late Auth auth;
UserDetail? userDetail;
List<UserFriendlist>? friendlist;

class _FriendRequestScreenState extends State<FriendRequestScreen> {
  @override
  void initState() {
    super.initState();
    auth = Auth(dataloader);
    _loaduserDetail();
  }

  void _loaduserDetail() async {
    UserDetail? detail = await auth.getloggedinuser();
    setState(() {
      userDetail = detail;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter friend list to show only those with hasNewRequestAccepted = true
    List<UserFriendlist> filteredFriendlist = widget.friendlist
        .where((friend) => friend.hasNewRequestAccepted == true)
        .toList();
    return Scaffold(
      body: ListView.builder(
        itemCount: filteredFriendlist.length,
        itemBuilder: (context, index) {
          return _buildfriednList(filteredFriendlist[index]);
        },
      ),
    );
  }
//used for getting the user details

  UserDetail getid(int userid) {
    return widget.userDetail.firstWhere((element) => element.id == userid);
  }
//used for getting the userpost

  List<UserPost> getUserPosts(int userId) {
    return widget.userpost.where((post) => post.userId == userId).toList();
  }

  Widget _buildfriednList(UserFriendlist model) {
    UserDetail detail = getid(model.friendId!);
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
      subtitle: Text('Friend ID: ${model.friendId}'),
      trailing: _buildStatusBadge(model),
    );
  }

  Widget _buildStatusBadge(UserFriendlist request) {
    if (request.hasRemoved!) {
      return const Icon(Icons.cancel, color: Colors.red);
    } else if (request.hasNewRequestAccepted!) {
      return const Icon(Icons.check_circle, color: Colors.green);
    } else if (request.hasNewRequest!) {
      return Icon(Icons.access_time, color: Colors.blue);
    } else {
      return const Icon(Icons.done, color: Colors.grey);
    }
  }
}
