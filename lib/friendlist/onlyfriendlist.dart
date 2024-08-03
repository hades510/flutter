import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/authenthication/login_auth.dart';
import 'package:socialapp/dataloader.dart';
import 'package:socialapp/models/user_detail.dart';

class FriendsListScreen extends StatefulWidget {
  final int loggedInUserId;

  const FriendsListScreen({super.key, required this.loggedInUserId});

  @override
  State<FriendsListScreen> createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends State<FriendsListScreen> {
  List<UserDetail> friends = [];
  late Auth auth;

  @override
  void initState() {
    super.initState();
    auth = Auth(Dataloader());
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    final prefs = await SharedPreferences.getInstance();
    final friendsJson = prefs.getString('user_${widget.loggedInUserId}_friends') ?? '[]';
    List<int> friendIds = List<int>.from(jsonDecode(friendsJson));

    Dataloader dataloader = Dataloader();
    List<UserDetail> allUsers = await dataloader.getuserdetail();
    setState(() {
      friends = allUsers.where((user) => friendIds.contains(user.id)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends List'),
      ),
      body: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, index) {
          UserDetail friend = friends[index];
          return ListTile(
            leading: (friend.profileImage?.isNetworkUrl ?? false)
                ? CircleAvatar(
                    backgroundImage: NetworkImage(friend.profileImage!.imagePath ?? ''),
                  )
                : CircleAvatar(
                    backgroundImage: FileImage(File(friend.profileImage?.imagePath ?? '')),
                  ),
            title: Text(friend.basicInfo!.name!),
            subtitle: Text('ID: ${friend.id}'),
          );
        },
      ),
    );
  }
}
