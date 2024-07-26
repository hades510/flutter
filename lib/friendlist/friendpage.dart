import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:socialapp/dataloader.dart';
import 'package:socialapp/models/user_detail.dart';
import 'package:socialapp/models/user_friendlist.dart';

class FriendRequest extends StatelessWidget {
  const FriendRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friend Request'),
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
            );
          }
        },
      ),
    );
  }

  Future _fetchdata() async {
    Dataloader dataloader = Dataloader();
    List<UserFriendlist> friendlist = await dataloader.getfriendlist();
    List<UserDetail> userDetail = await dataloader.getuserdetail();
    return {'friendlist': friendlist, 'userDetail': userDetail};
  }
}

class FriendRequestScreen extends StatefulWidget {
  List<UserFriendlist> friendlist;
  List<UserDetail> userDetail;
  FriendRequestScreen(
      {super.key, required this.friendlist, required this.userDetail});

  @override
  State<FriendRequestScreen> createState() => _FriendRequestScreenState();
}

Dataloader dataloader = Dataloader();

class _FriendRequestScreenState extends State<FriendRequestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.friendlist.length,
        itemBuilder: (context, index) {
          // final request = widget.friendlist[index];
          return _buildfriednList(widget.friendlist[index]);
        },
      ),
    );
  }

  UserDetail getid(int userid) {
    return widget.userDetail.firstWhere((element) => element.id == userid);
  }

  Widget _buildfriednList(UserFriendlist model) {
    UserDetail detail = getid(model.friendId!);
    return ListTile(
      leading: (detail.profileImage?.isNetworkUrl ?? false)
          ? CircleAvatar(
              backgroundImage: NetworkImage(detail.profileImage!.imagePath!),
            )
          : CircleAvatar(
              backgroundImage:
                  FileImage(File(detail.profileImage?.imagePath ?? '')),
            ),
      title: Text(detail.basicInfo!.name!),
      subtitle: Text('Friend ID: ${model.friendId}'),
      trailing: _buildStatusBadge(model),
      onTap: () {
        // Handle tap action
      },
    );
  }

  Widget _buildStatusBadge(UserFriendlist request) {
    if (request.hasRemoved!) {
      return const Icon(Icons.cancel, color: Colors.red);
    } else if (request.hasNewRequestAccepted!) {
      return const Icon(Icons.check_circle, color: Colors.green);
    } else if (request.hasNewRequest!) {
      return const Icon(Icons.access_time, color: Colors.blue);
    } else {
      return const Icon(Icons.done, color: Colors.grey);
    }
  }
}
