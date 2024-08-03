import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/courses/available%20courses.dart';
import 'package:socialapp/dataloader.dart';
import 'package:socialapp/dumbscreen.dart';
import 'package:socialapp/friendlist/sendlist.dart';
import 'package:socialapp/friendlist/requestlist.dart';
import 'package:socialapp/feeds/newsfeed.dart';
import 'package:socialapp/friendlist/onlyfriendlist.dart';
// import 'package:socialapp/login.dart';
import 'package:socialapp/models/user_detail.dart';
import 'package:socialapp/models/user_friendlist.dart';
import 'package:socialapp/profiles/surface_profile.dart';
import 'package:socialapp/signup.dart';

import 'authenthication/login_auth.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Dataloader dataloader = Dataloader();
  late Auth auth;
  UserDetail? userDetail;
  @override
  void initState() {
    auth = Auth(
        dataloader); //after splash screen it is being called, it is again loaded when loffed in,again called when logged out
    super.initState();
    loadData();
    _loaduserDetail(); //logged user
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isJsonLoaded = prefs.getBool("jsonData") ??
        false; //here it load the fetched json data if there is not data in shared preferences
    //send false
    if (!isJsonLoaded) {
      dataloader.loadalluserdatas();
      prefs.setBool("jsonData", true);
    }
  }

  void _loaduserDetail() async {
    //gets logged user
    UserDetail? detail = await auth.getloggedinuser();
    setState(() {
      userDetail = detail;
    });
  }
  //creating a common parent screen for handling the callback of recevied request

  

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            // elevation: 15,
            toolbarHeight: 40,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Social App',
                  style: TextStyle(fontFamily: 'Title'),
                ),
                Container(
                    width: 120,
                    // color: Colors.black,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Signup(),
                              )),
                          child: const CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.black,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SentFriendRequestsScreen(
                                          userId: userDetail!.id!),
                                ));
                          },
                          child: const CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 15,
                            child: Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        //
                      ],
                    ))
              ],
            ),
            bottom: TabBar(
              tabs: [
                const Icon(
                  Icons.home_outlined,
                  size: 30,
                ),
                const Icon(Icons.people_alt_outlined),
                Image.asset(
                  'assets/images/courses.png',
                  cacheHeight: 30,
                  cacheWidth: 30,
                  color: Colors.black,
                ),
                const Icon(
                  Icons.account_circle,
                  size: 30,
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Newsfeed(),
              userDetail?.id == null
                  ?
                  // FriendRequestsScreen(userId: userDetail?.id ?? 1)
                  Friendlist()
                  : FriendsListScreen(loggedInUserId: userDetail!.id!),
              // FriendRequest(loggedInUserId: userDetail!.id!),
              AvailableCourses(),
              SurfaceProfile(),
            ],
          ),
        ));
  }
}
