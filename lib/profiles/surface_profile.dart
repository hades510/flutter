import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/authenthication/login_auth.dart';
import 'package:socialapp/dataloader.dart';
import 'package:socialapp/feeds/Albumscreen.dart';
import 'package:socialapp/friendlist/requestlist.dart';
import 'package:socialapp/friendlist/sendlist.dart';
import 'package:socialapp/friendlist/sendrequest.dart';
import 'package:socialapp/home.dart';
import 'package:socialapp/login.dart';
import 'package:socialapp/models/user.dart';
import 'package:socialapp/models/user_detail.dart';
import 'package:socialapp/models/user_friendlist.dart';
import 'package:socialapp/models/user_post.dart';
import 'package:socialapp/profiles/addpost.dart';

import 'package:socialapp/profiles/image_full.dart';
import 'package:socialapp/profiles/view_profile.dart';

class SurfaceProfile extends StatefulWidget {
  const SurfaceProfile({super.key});

  @override
  State<SurfaceProfile> createState() => _SurfaceProfileState();
}

class _SurfaceProfileState extends State<SurfaceProfile> {
  late Auth auth;
  UserDetail? userDetail;
  User? user;
  UserPost? post;
  final ImagePicker picker = ImagePicker();
  File? profile;
  File? cover;
  List<UserPost> userpost = []; //pushing the userpost valueddc
  List<User> userlist = [];
  @override
  void initState() {
    super.initState();
    //loading
    auth = Auth(Dataloader());
    _loaduserDetail(); //holds info about currently logged users
    _loadcover();
    _loadprofile();
    _loaduserPost();
    _loadusers();
    // _updaterequestlist();
    // print(userDetail?.id);
  }

//   late Future<List<UserDetail>> _nonFriendUsersFuture;
//   void _updaterequestlist() {
//     setState(() {
//       _nonFriendUsersFuture = _getNonFriendUsers(userDetail!.id!);
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
//           !friends.contains(user.id) &&
//           !sentRequests.contains(user.id) &&
//           !receiveRequest.contains(user.id);
//     }).toList();

//     return nonFriendUsers;
//   }

  Future<void> _loaduserPost() async {
    if (userDetail != null) {
      Dataloader dataloader = Dataloader();
      List<UserPost> post = await dataloader.getloggeduserpost(userDetail!.id!);
      setState(() {
        userpost = post;
      });
    }
  }

  Future<void> _loadusers() async {
    if (userDetail != null) {
      Dataloader dataloader = Dataloader();
      List<User> user = await dataloader.getloggeduser(userDetail!.id!);
      setState(() {
        userlist = user;
      });
    }
  }

  Future<void> _deletePost(int postId) async {
    // Delete post from storage
    final auth = Auth(Dataloader());
    //if done this it will delete all the data from here,and only the
    // userpost.removeWhere((element) => element.postId == postId);
    // final prefs = await SharedPreferences.getInstance();
    // prefs.setString(Dataloader.userpostkey,
    //     json.encode(userpost.map((e) => e.toJson()).toList()));
    await auth.deletePost(postId);

    // Refresh the list of posts
    _loaduserPost();
  }

  void _loaduserDetail() async {
    //This method fetches the logged-in user's details and updates userDetail.
    //After setting userDetail, it proceeds to call _loaduserPost() and _loadusers().
    UserDetail? detail = await auth.getloggedinuser();
    setState(() {
      userDetail = detail;
    });
    // print(userDetail!.id);
    //You need to call _loaduserPost() and _loadusers()
    // after fetching userDetail to ensure these methods have the necessary data
    //(i.e., the userDetail object) to fetch user-specific posts and users.
    await _loaduserPost();
    await _loadusers();
    //Since _loaduserPost() and _loadusers() are dependent on userDetail,
    // i must first ensure userDetail is loaded.
    // By calling these methods within _loaduserDetail(),
    // you ensure that the data is fetched in the right order.
  }

  //  this updated the whole post removing all the other posts
  // Future<void> _updateUserPosts(List<UserPost> updatedPosts) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   // Convert the list of UserPost objects to JSON string
  //   String jsonPosts =
  //       jsonEncode(updatedPosts.map((post) => post.toJson()).toList());
  //   // Save the JSON string to SharedPreferences
  //   await prefs.setString(userpostkey, jsonPosts);
  // }

//when you want
  // Future<void> _updatelikeandDislike(
  //     int postId, bool isLiked, bool isDisliked) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? postsJson = prefs.getString(
  //       Dataloader.userpostkey); //retrieves the json string og the post

  //   if (postsJson != null) {
  //     // Decode the JSON string to get the list of posts
  //     List<dynamic> postsList = jsonDecode(
  //         postsJson); // converts tha above json string to the list of dynamic objects
  //     // Convert the list to a list of UserPost objects
  //     List<UserPost> updatedPosts =
  //         postsList.map((postJson) => UserPost.fromJson(postJson)).toList();

  //     // Find the post with the matching ID
  //     UserPost? postToUpdate = updatedPosts.firstWhere(
  //       (post) => post.postId == postId,
  //     ); //ensures that only the wanted post is updated rather than affecting all the post
  //     if (postToUpdate != null) {
  //       // Update the like/dislike states
  //       postToUpdate.isliked = isLiked;
  //       postToUpdate.isDisliked = isDisliked;

  //       // Update the like/dislike counts
  //       if (isLiked) {
  //         postToUpdate.postLikedBy ??= [];

  //         if (!postToUpdate.postLikedBy!
  //             .any((like) => like.userId == userDetail!.id)) {
  //           postToUpdate.postLikedBy!.add(PostLikedBy(
  //               userId: userDetail!.id,
  //               dateTime: DateTime.now().toIso8601String()));
  //         }
  //         if (postToUpdate.isDisliked) {
  //           postToUpdate.isDisliked = false;
  //           postToUpdate.postLikedBy!.removeWhere(
  //               (like) => like.userId == userDetail!.id); // Remove dislike
  //         }
  //       } else {
  //         postToUpdate.postLikedBy?.removeWhere(
  //             (like) => like.userId == userDetail!.id); // Remove like
  //       }

  //       if (isDisliked) {
  //         if (postToUpdate.postLikedBy
  //                 ?.any((like) => like.userId == userDetail!.id) ??
  //             false) {
  //           postToUpdate.postLikedBy!.removeWhere((like) =>
  //               like.userId == userDetail!.id); // Remove like ifp disliked
  //         }
  //       }

  //       // Convert the updated list back to JSON
  //       String updatedPostsJson =
  //           jsonEncode(updatedPosts.map((post) => post.toJson()).toList());
  //       // Save the updated JSON string to SharedPreferences
  //       await prefs.setString(Dataloader.userpostkey, updatedPostsJson);
  //     }
  //   }
  // }

  Future<void> _updatecover(File file) async {
    final prefs = await SharedPreferences.getInstance();
    Dataloader dataloader = Dataloader();
    List<UserDetail> userdetail = await dataloader.getuserdetail();
    UserDetail? tempUser =
        userdetail.firstWhere((element) => element.id == userDetail!.id);

    if (tempUser != null) {
      int indexFinder =
          userdetail.indexWhere((element) => element.id == userDetail!.id);

      tempUser.coverImage =
          CoverImage(isNetworkUrl: false, imagepath: file.path);

      userdetail.removeAt(indexFinder);
      userdetail.insert(indexFinder, tempUser);

      String coverjson = json.encode(userdetail);
      await prefs.setString(Dataloader.userdetailkey, coverjson);
    }
    if (userDetail != null) {
      final userid = userDetail!.id;
      await prefs.setString('cover_$userid', file.path);

      setState(() {
        cover = file;
      });
      userDetail!.coverImage = CoverImage(imagepath: file.path);
      await auth.saveUserDetail(userDetail!);
    }
  }

  Future<void> _loadcover() async {
    //initialized
    final prefs = await SharedPreferences.getInstance();
    if (userDetail != null) {
      final userid = userDetail!.id;

      //for all both the profile image there is same key

      final imagepath = prefs.getString(
          'cover_$userid'); //retriving image path (from updateprofile)[

      if (imagepath != null) {
        setState(() {
          cover =
              File(imagepath); //updates the local state with the saved image
        });
      }
    }
  }

  Future<void> _updateprofile(File file) async {
    final prefs = await SharedPreferences.getInstance();
    Dataloader dataloader = Dataloader();
    List<UserDetail> userdetail = await dataloader.getuserdetail();
    UserDetail? tempUser =
        userdetail.firstWhere((element) => element.id == userDetail!.id);

    if (tempUser != null) {
      int indexFinder =
          userdetail.indexWhere((element) => element.id == userDetail!.id);

      tempUser.profileImage =
          ProfileImage(imagePath: file.path, isNetworkUrl: false);

      userdetail.removeAt(indexFinder);
      userdetail.insert(indexFinder, tempUser);

      String profilejson = json.encode(userdetail);
      await prefs.setString(Dataloader.userdetailkey, profilejson);
    }
    if (userDetail != null) {
      final userid = userDetail!.id;

      await prefs.setString('profile_$userid', file.path);

      setState(() {
        profile = file;
      });
      userDetail!.profileImage = ProfileImage(imagePath: file.path);
      await auth.saveUserDetail(userDetail!);
    }
  }

  Future<void> _loadprofile() async {
    //initialized
    final prefs = await SharedPreferences.getInstance();
    if (userDetail != null) {
      final userid = userDetail!.id;
      final imagepath = prefs.getString(
          'profile_$userid'); //retriving image path (from updateprofile)

      if (imagepath != null) {
        setState(() {
          profile =
              File(imagepath); //updates the local state with the saved image
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // user = userlist.firstWhere((element) => element.id == userDetail!.id);
    int indexfinder = userlist.indexWhere(
      (element) => element.id == userDetail!.id,
    );
    return Scaffold(
      body: userDetail == null //just gives the details of the logged in user
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //
                  const Text(
                    'No user Logged in !!',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 100,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10)),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => const LoginPage(),
                        //     ));
                      },
                      child: const Center(
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          //
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  SizedBox(
                    height: 230,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: GestureDetector(
                            // onTap: () {
                            //   print('open pcitrue');
                            //   Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => ImageFull(
                            //         imagefile: cover ?? File(''),
                            //         text: 'Cover picture',
                            //       ), //here i passed the userdetail used to display the current logged profile detail
                            //     ),
                            //   );
                            // },
                            onTap: () {
                              (userDetail?.coverImage?.isNetworkUrl ?? false)
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ImageFull(
                                          text: 'Cover Picture',
                                          networkurl:
                                              userDetail!.coverImage!.imagepath,
                                        ),
                                      ))
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ImageFull(
                                          text: "Cover Picture",
                                          imagefile: File(userDetail!
                                              .coverImage!.imagepath!),
                                        ),
                                      ));
                            },
                            child: cover != null
                                ? Image.file(
                                    cover!,
                                    fit: BoxFit.fill,
                                  )
                                : (userDetail?.coverImage?.isNetworkUrl ?? true)
                                    ? Image.network(
                                        userDetail?.coverImage?.imagepath ??
                                            'https://images.stockcake.com/public/8/d/7/8d7ad827-243c-4c0f-912e-aef97670a14f_large/workshop-safety-gear-stockcake.jpg',
                                        fit: BoxFit.cover,
                                      )
                                    : const SizedBox(),
                          ),
                        ),
                        Positioned(
                          left: 5,
                          bottom: 0,
                          child: GestureDetector(
                              // onTap: () {
                              //   Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => ImageFull(
                              //         imagefile: profile ?? File(''),
                              //         text: 'Profile Picture',
                              //       ),
                              //     ),
                              //   );
                              // },
                              onTap: () {
                                (userDetail?.profileImage?.isNetworkUrl ??
                                        false)
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ImageFull(
                                            text: 'Cover Picture',
                                            networkurl: userDetail!
                                                .profileImage!.imagePath,
                                          ),
                                        ))
                                    : Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ImageFull(
                                            text: "Cover Picture",
                                            imagefile: File(userDetail!
                                                .profileImage!.imagePath!),
                                          ),
                                        ));
                              },
                              child: profile != null
                                  ? CircleAvatar(
                                      radius: 80,
                                      backgroundImage: FileImage(profile!),
                                    )
                                  : (userDetail?.profileImage?.isNetworkUrl ??
                                          true)
                                      ? CircleAvatar(
                                          radius: 80,
                                          backgroundImage: NetworkImage(userDetail
                                                  ?.profileImage?.imagePath ??
                                              'https://images.stockcake.com/public/8/d/7/8d7ad827-243c-4c0f-912e-aef97670a14f_large/workshop-safety-gear-stockcake.jpg'),
                                        )
                                      : const SizedBox()
                              // (userDetail?.profileImage?.isNetworkUrl ??
                              //         false)
                              //     ? CircleAvatar(
                              //         radius: 80,
                              //         backgroundImage: NetworkImage(userDetail
                              //                 ?.profileImage?.imagePath ??
                              //             'https://images.stockcake.com/public/8/d/7/8d7ad827-243c-4c0f-912e-aef97670a14f_large/workshop-safety-gear-stockcake.jpg'),
                              //       )
                              //     : CircleAvatar(
                              //         radius: 80,
                              //         backgroundImage: FileImage(
                              //           File(
                              //               userDetail!.profileImage!.imagePath!),
                              //         ),
                              //       ),
                              ),
                        ),
                        Positioned(
                          right: 235,
                          top: 185,
                          child: GestureDetector(
                            onTap: () {
                              print('profile');
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return AlertDialog(
                                      title:
                                          const Text('Choose profile Picture'),
                                      actions: [
                                        TextButton(
                                            onPressed: () async {
                                              final picked =
                                                  await picker.pickImage(
                                                      source:
                                                          ImageSource.camera);

                                              if (picked != null) {
                                                final file = File(picked.path);
                                                await _updateprofile(
                                                    file); //update profile
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: const Text('Take Picture')),
                                        TextButton(
                                            onPressed: () async {
                                              final picked =
                                                  await picker.pickImage(
                                                      source:
                                                          ImageSource.gallery);

                                              if (picked != null) {
                                                final file = File(picked.path);
                                                await _updateprofile(file);
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: const Text(
                                                'Choose from Gallery ')),
                                      ],
                                    );
                                  });
                                },
                              );
                            },
                            child: const CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.black,
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            right: 16,
                            top: 155,
                            child: GestureDetector(
                              onTap: () {
                                print('Choose cover');
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Choose cover Picture'),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            final picked =
                                                await picker.pickImage(
                                                    source: ImageSource.camera);

                                            if (picked != null) {
                                              final file = File(picked.path);
                                              await _updatecover(file);
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: const Text('Take Picture'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            final picked =
                                                await picker.pickImage(
                                                    source:
                                                        ImageSource.gallery);

                                            if (picked != null) {
                                              final file = File(picked.path);
                                              await _updatecover(file);
                                              Navigator.pop(context);
                                            }
                                          },
                                          child:
                                              const Text('Choose from Gallery'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.black,
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                  )),
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              userDetail?.basicInfo?.name ?? '',
                              style: const TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SentFriendRequestsScreen(
                                                userId: userDetail!.id!),
                                      ));
                                },
                                icon: const Icon(
                                  Icons.view_agenda,
                                  color: Colors.white,
                                )),
                            GestureDetector(
                                onTap: () async {
                                  await auth.logout();
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Home(),
                                      ),
                                      (route) => false);
                                },
                                child: const Icon(Icons.logout)),
                          ],
                        ),
                        const SizedBox(),
                        Text(
                          userDetail?.basicInfo?.summary ??
                              'Just the demo summary ',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        Text('User ID: ${userDetail?.id}'),
                        const SizedBox(
                          height: 15,
                        ),
                        Wrap(
                          runSpacing: 5,
                          spacing: 5,
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: 163,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ViewProfile(),
                                    )),
                                title: const Text(
                                  'Edit Profile',
                                  style: TextStyle(color: Colors.white),
                                ),
                                leading: const Icon(
                                  Icons.edit_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            // const SizedBox(
                            //   width: 5,
                            // ),
                            Container(
                              width: 163,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AddPost(),
                                  ),
                                ),
                                leading: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                title: const Text(
                                  'Add post',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Container(
                              width: 163,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ReceivedFriendRequestsScreen(
                                              userId: userDetail!.id!,
                                              // onRequestRejected:
                                              //     _updaterequestlist,
                                            )
                                        // FriendRequest(
                                        //   loggedInUserId: userDetail!.id!,
                                        // ),
                                        )),
                                leading: const Icon(
                                  Icons.people_alt,
                                  color: Colors.white,
                                ),
                                title: const Text('Requests',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            Container(
                              width: 163,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          // SendFriendRequestScreen(
                                          //     loggedInUserId: userDetail!.id!)
                                          UserListScreen(
                                              loggedInUserId: userDetail!.id!),
                                    )),
                                leading: const Icon(
                                  Icons.person_add,
                                  color: Colors.white,
                                ),
                                title: const Text('Send Req.',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Divider(),
                  ListView.separated(
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: userpost.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                              leading: (userDetail!
                                          .profileImage?.isNetworkUrl ??
                                      false) //this place the value that can have a value false if it is null
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          userDetail!.profileImage!.imagePath!),
                                    )
                                  : CircleAvatar(
                                      backgroundImage: FileImage(File(
                                          userDetail!.profileImage?.imagePath ??
                                              '')),
                                    ),
                              title: Text(userDetail!.basicInfo!.name!),
                              subtitle: Text(userlist[indexfinder].email!),
                              trailing: IconButton(
                                  onPressed: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Delete Post'),
                                        content: const Text(
                                            'Are you sure you want to delete this post?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              _deletePost(
                                                  userpost[index].postId!);
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Home(),
                                                  ),
                                                  (route) => false);
                                              // Navigator.pushReplacement(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //       builder: (context) =>
                                              //           const Home(),
                                              //     ));
                                            },
                                            child: const Text('Delete'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('Cancel'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.cancel))),

                          // ListTile(
                          //   leading: (userDetail!.profileImage?.isNetworkUrl ??
                          //           false) //this place the value that can have a value false if it is null
                          //       ? CircleAvatar(
                          //           backgroundImage: NetworkImage(
                          //               userDetail!.profileImage!.imagePath!),
                          //         )
                          //       : CircleAvatar(
                          //           backgroundImage: FileImage(File(
                          //               userDetail!.profileImage?.imagePath ??
                          //                   '')),
                          //         ),
                          //   title: Text(userDetail!.basicInfo!.name!),
                          //   // subtitle: Text(userlist[index].email!),
                          // ),
                          // const SizedBox(
                          //   height: 8,
                          // ),
                          Text(userpost[index].title!),
                          // Text(userpost[index].description!),
                          Card(
                            elevation: 5,
                            child: _builderimage(
                              userpost[index].image!,
                              userDetail!,
                              userpost[index],
                              // userlist[index],
                            ),
                          ), //here with list<postedphot> i passed userdetail userpost[index] also
                          // Text('${userpost[index].image!.length}'),
                          // for (var image in userpost[index].image!) _builderimage(image),
                          Text(userpost[index].createdAt.toString()),
                          Text(
                              'Likes ${userpost[index].postLikedBy?.length ?? 0}'),
                          //

                          SizedBox(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                    tooltip: 'Like',
                                    onPressed: () async {
                                      setState(() {
                                        if (userpost[index].isliked ?? false) {
                                          userpost[index].isliked = false;
                                          userpost[index]
                                              .postLikedBy
                                              ?.removeWhere((like) =>
                                                  like.userId ==
                                                  userDetail!.id);
                                        } else {
                                          userpost[index].isliked = true;
                                          userpost[index].isDisliked =
                                              false; // Ensure dislike is false
                                          userpost[index].postLikedBy ??= [];
                                          if (!userpost[index].postLikedBy!.any(
                                              (element) =>
                                                  element.userId ==
                                                  userDetail!.id)) {
                                            userpost[index].postLikedBy!.add(
                                                PostLikedBy(
                                                    userId: userDetail!.id,
                                                    dateTime: DateTime.now()
                                                        .toIso8601String()));
                                          }
                                        }
                                      });
                                      await auth.updateReactforPost(
                                          userpost[index].postId!,
                                          userpost[index].isliked ?? false,
                                          userpost[index].isDisliked ?? false,
                                          userDetail!.id!);
                                      // _loaduserPost();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        duration: const Duration(seconds: 1),
                                        content: Text(
                                            userpost[index].isliked ?? false
                                                ? 'Liked the post'
                                                : 'Unlike the post'),
                                      ));
                                    },
                                    icon: const Icon(
                                        Icons.thumb_up_alt_outlined)),
                                //  userpost[index].isliked ?? false
                                //     ? const Icon(Icons.thumb_up_alt)
                                //     : const Icon( Icons.thumb_up_alt_outlined)
                                //     ),

                                // Text(
                                //     '${userpost[index].likeCount} Likes'), // Display like count

                                //gives the number of likes
                                // IconButton(
                                //   tooltip: 'Like',
                                //   onPressed: () async {
                                //     setState(() {
                                //       if (userpost[index].isliked) {
                                //         userpost[index].isliked = false;
                                //         userpost[index].likeCount--;
                                //       } else {
                                //         userpost[index].isliked = true;
                                //         userpost[index].likeCount++;
                                //         userpost[index].isDisliked =
                                //             false; // Ensure dislike is false
                                //       }
                                //       if (userpost[index].isDisliked) {
                                //         userpost[index]
                                //             .likeCount++; // Adjust likeCount if necessary
                                //       }
                                //     });
                                //     //updating the data
                                //     await _updatePostLikeDislike(
                                //       userpost[index].postId!,
                                //       userpost[index].isliked,
                                //       userpost[index].isDisliked,
                                //     );
                                //     // _updateuserpost(userpost); // Save updated posts
                                //     ScaffoldMessenger.of(context)
                                //         .showSnackBar(SnackBar(
                                //       duration: Duration(seconds: 1),
                                //       content: Text(userpost[index].isliked
                                //           ? 'Liked the post'
                                //           : 'Unliked the post'),
                                //     ));
                                //   },
                                //   icon: userpost[index].isliked
                                //       ? Icon(Icons.thumb_up_alt)
                                //       : Icon(Icons.thumb_up_alt_outlined),
                                // ),
                                // IconButton(
                                //   tooltip: 'Dislike',
                                //   onPressed: () {
                                //     setState(() {
                                //       if (userpost[index].isDisliked) {
                                //         userpost[index].isDisliked = false;
                                //         userpost[index]
                                //             .likeCount++; // Adjust likeCount if necessary
                                //       } else {
                                //         userpost[index].isDisliked = true;
                                //         userpost[index].likeCount--;
                                //         userpost[index].isliked =
                                //             false; // Ensure like is false
                                //         if (userpost[index].isliked) {
                                //           userpost[index]
                                //               .likeCount--; // Adjust likeCount if necessary
                                //         }
                                //       }
                                //       // _updateuserpost(userpost); // Save updated posts
                                //       ScaffoldMessenger.of(context)
                                //           .showSnackBar(SnackBar(
                                //         duration: Duration(seconds: 1),
                                //         content: Text(userpost[index].isDisliked
                                //             ? 'Disliked the post'
                                //             : 'Undisliked the post'),
                                //       ));
                                //     });
                                //   },
                                //   icon: userpost[index].isDisliked
                                //       ? Icon(Icons.thumb_down_alt)
                                //       : Icon(Icons.thumb_down_alt_outlined),
                                // ),
                                // Text(
                                //     '${userpost[index].likeCount} Likes'), // Display like count
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
    );
  }

  Widget _builderimage(
      List<Postedphoto> image, UserDetail detail, UserPost userpost
      // User user
      ) {
    int remainimages =
        image.length - 3; //remaining after 3 images foe the stack
    //if only one image
    if (image.length == 1) {
      if (userpost.postId! > 10) {
        return GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageFull(
                    imagefile: File(image[0].url!),
                    text: 'Pictures',
                  ),
                )),
            child: Image.file(File(image[0].url!)));
      } else {
        return Image.network(image[0].url!);
      }
      // return (image[0].isNetworkurl = false)
      //     ? Image.network(image[0].url!)
      //     : Image.file(
      //         File(image[0].url!),
      //         height: 400,
      //         width: double.infinity,
      //         fit: BoxFit.fill,
      //       );
      // return Image.network(
      //   image[0].url!,
      //   // width: double.infinity,
      // );
    } else if (image.length == 3) {
      return Column(
        children: [
          //this is if there is 3 photo
          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullImageScreen(
                    images: image,
                    detail: detail,
                    user: user,
                    post: userpost,
                  ),
                )),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              children: [
                (userpost.postId! > 10)
                    ? Image.file(
                        File(image[0].url!),
                        fit: BoxFit.fill,
                      )
                    : Image.network(image[0].url!),
                //
                (userpost.postId! > 10)
                    ? Image.file(
                        File(image[1].url!),
                        fit: BoxFit.fill,
                      )
                    : Image.network(image[1].url!),
                // (image[0].isNetworkurl)
                //     ? Image.network(
                //         image[0].url!,
                //       )
                //
                // (image[1].isNetworkurl ?? false)
                //     ? Image.network(image[1].url!)
                //     : Image.file(
                //         File(image[1].url!),
                //         fit: BoxFit.fill,
                //       ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          (userpost.postId! > 10) //bool comes null
              ? Image.file(
                  (File(image[2].url!)),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.fill,
                )
              : Image.network(image[2].url!)
          // Image.network(
          //   image[2].url!,
          // )
        ],
      );
    }
//if there are more than 3 photos
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullImageScreen(
              images: image,
              detail: detail,
              user: user,
              post: userpost,
            ),
          )),
      child: GridView.builder(
        shrinkWrap: true, //allows widget to adjust it's size with content
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            // childAspectRatio: 1,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2),

        itemCount: image.length > 3 ? 4 : image.length,
        //if the image lenth is more than 3 the value is set to 4 , but if less then the vakue is set to image.length
        itemBuilder: (context, index) {
          if (index == 3 && remainimages > 0) {
            //this condition makes the +X for image display
            return Stack(
              fit: StackFit.expand,
              children: [
                (userpost.postId! > 10)
                    ? Image.file(File(image[index].url!), fit: BoxFit.fill)
                    : Image.network(image[index].url!, fit: BoxFit.fill),
                // Image.network(
                //   image[index].url!,
                //   fit: BoxFit.cover,
                // ),
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Text(
                      '+$remainimages',
                      style: const TextStyle(color: Colors.grey, fontSize: 25),
                    ),
                  ),
                )
              ],
            );
          } else {
            return (userpost.postId! > 10)
                ? Image.file(File(image[index].url!), fit: BoxFit.fill)
                : Image.network(image[index].url!, fit: BoxFit.fill);
          }
        },
      ),
    );
    // return Image.network(
    //   // width: 390,
    //   image.url!,
    //   // fit: BoxFit.fitWidth,
    //   // cacheHeight: 200,
    //   // cacheWidth: 200,
    // );
  }
}
