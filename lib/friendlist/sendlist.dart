import 'dart:io';

import 'package:flutter/material.dart';

import '../authenthication/login_auth.dart';
import '../dataloader.dart';
import '../models/user_detail.dart';
import '../models/user_friendlist.dart';

class SentFriendRequestsScreen extends StatefulWidget {
  final int userId;

  const SentFriendRequestsScreen({super.key, required this.userId});

  @override
  State<SentFriendRequestsScreen> createState() =>
      _SentFriendRequestsScreenState();
}

class _SentFriendRequestsScreenState extends State<SentFriendRequestsScreen> {
  List<UserDetail> users = [];
  List<UserFriendlist> sendrequest = [];
  List<UserDetail> acceptedlist = [];
  UserDetail? userDetail;
  late Auth auth;

  @override
  void initState() {
    super.initState();
    auth = Auth(Dataloader());
    _loaduserdetail();
    _loaddata();
  }

  void _loaduserdetail() async {
    UserDetail? detail = await auth.getloggedinuser();
    setState(() {
      userDetail = detail;
    });
  }

  Future<void> _loaddata() async {
    Dataloader dataloader = Dataloader();
    List<UserDetail> detail = await dataloader.getuserdetail();
    List<UserFriendlist> list =
        await dataloader.getSentFriendRequests(widget.userId);
    // List<UserDetail> accepted =
    //     await dataloader.getAcceptedFriends(widget.userId);
    setState(() {
      users = detail;
      sendrequest = list;
      // acceptedlist = accepted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sent Friend Requests'),
      ),
      body: FutureBuilder(
        future: _fetchSentRequests(),
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
              child: Text('No sent friend requests'),
            );
          } else {
            final List<UserFriendlist> sentRequests =
                snapshot.data as List<UserFriendlist>;
            return ListView.builder(
              itemCount: sentRequests.length,
              itemBuilder: (context, index) {
                return _buildRequestItem(sentRequests[index]);
              },
            );
          }
        },
      ),
    );
  }

  Future<List<UserFriendlist>> _fetchSentRequests() async {
    Dataloader dataloader = Dataloader();
    return dataloader.getSentFriendRequests(widget.userId);
  }

  UserDetail getid(int id) {
    return users.firstWhere((element) => element.id == id);
  }

  Widget _buildRequestItem(UserFriendlist request) {
    UserDetail detail = getid(request.requestedTo!);
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
      title: Text('To: ${request.requestedTo}'),
      subtitle: Text('Status: ${_getStatus(request)}'),
      trailing: _buildStatusBadge(request),
    );
  }

  String _getStatus(UserFriendlist request) {
    if (request.hasNewRequestAccepted!) {
      return 'Accepted';
    } else if (request.hasRemoved!) {
      return 'Removed';
    } else if (request.hasNewRequest!) {
      return 'Pending';
    } else {
      return 'Unknown';
    }
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
