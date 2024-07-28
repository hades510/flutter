import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/authenthication/login_auth.dart';
import 'package:socialapp/dataloader.dart';
import 'package:socialapp/feeds/Albumscreen.dart';
import 'package:socialapp/login.dart';
import 'package:socialapp/models/user.dart';
import 'package:socialapp/models/user_detail.dart';
import 'package:socialapp/models/user_post.dart';
import 'package:socialapp/profiles/addpost.dart';
import 'package:socialapp/profiles/cover_full.dart';
import 'package:socialapp/profiles/profile_full.dart';
import 'package:socialapp/profiles/view_profile.dart';

class SurfaceProfile extends StatefulWidget {
  const SurfaceProfile({super.key});

  @override
  State<SurfaceProfile> createState() => _SurfaceProfileState();
}

class _SurfaceProfileState extends State<SurfaceProfile> {
  late Auth auth;
  UserDetail? userDetail;
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
  }

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

  void _loaduserDetail() async {
    //This method fetches the logged-in user's details and updates userDetail.
    //After setting userDetail, it proceeds to call _loaduserPost() and _loadusers().
    UserDetail? detail = await auth.getloggedinuser();
    setState(() {
      userDetail = detail;
    });
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

  // Future<void> _loaduserDetail() async {
  //   // Fetch user detail and posts
  //   final auth = Auth(Dataloader());
  //   UserDetail? detail = await auth.getloggedinuser();
  //   final prefs = await SharedPreferences.getInstance();
  //   String? postJson = prefs.getString(Dataloader.userpostkey);
  //   List<UserPost> posts = postJson != null
  //       ? (json.decode(postJson) as List)
  //           .map((e) => UserPost.fromJson(e))
  //           .toList()
  //       : [];
  //   setState(() {
  //     userDetail = detail;
  //     userPost = posts.where((post) => post.userId == detail?.id).toList();
  //   });
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
          'cover_$userid'); //retriving image path (from updateprofile)

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
    return Scaffold(
      body: userDetail == null
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
                            ));
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
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 230,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () {
                              print('open pcitrue');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullCoverPic(
                                    imagepath: cover!,
                                  ), //here i passed the userdetail used to display the current logged profile detail
                                ),
                              );
                            },
                            child: cover != null
                                ? Image.file(
                                    cover!,
                                    fit: BoxFit.fill,
                                  )
                                : userDetail!.coverImage!.isNetworkUrl!
                                    ? Image.network(
                                        userDetail!.coverImage!.imagepath!,
                                        fit: BoxFit.cover,
                                      )
                                    : const SizedBox(),
                          ),
                        ),
                        Positioned(
                          left: 5,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullProfilePic(
                                    imagefile: profile!,
                                  ),
                                ),
                              );
                            },
                            child: (userDetail?.profileImage?.isNetworkUrl ??
                                    false)
                                ? CircleAvatar(
                                    radius: 80,
                                    backgroundImage: NetworkImage(
                                        userDetail!.profileImage!.imagePath!),
                                  )
                                : CircleAvatar(
                                    radius: 80,
                                    backgroundImage: FileImage(
                                      File(
                                          userDetail?.profileImage?.imagePath ??
                                              ''),
                                    ),
                                  ),
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
                        Text(
                          userDetail!.basicInfo?.name ?? '',
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(),
                        Text(
                          userDetail!.basicInfo?.summary ?? '',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: 162.9,
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
                              width: 162.9,
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
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Divider(),

                  //still no when update, remember not chnages for SP
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
                            leading: (userDetail!.profileImage?.isNetworkUrl ??
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
                            // subtitle: Text(userlist[index].email!),
                          ),
                          // const SizedBox(
                          //   height: 8,
                          // ),
                          Text(userpost[index].title!),
                          Text(userpost[index].description!),
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
                          Container(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  // enableFeedback: true,
                                  tooltip: 'Like',
                                  onPressed: () {
                                    setState(() {
                                      userpost[index].isliked =
                                          !userpost[index].isliked;
                                      if (userpost[index].isliked) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                duration: Duration(seconds: 1),
                                                content:
                                                    Text('Liked the post')));
                                      }
                                    });
                                  },
                                  icon: userpost[index].isliked
                                      ? const Icon(Icons.thumb_up_alt)
                                      : const Icon(Icons.thumb_up_alt_outlined),
                                ),
                                IconButton(
                                  tooltip: 'Dislike',
                                  onPressed: () {
                                    setState(() {
                                      userpost[index].isDisliked =
                                          !userpost[index].isDisliked;
                                      if (userpost[index].isDisliked) {
                                        userpost[index].isliked = false;
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                duration: Duration(seconds: 1),
                                                content:
                                                    Text('Disliked the post')));
                                      }
                                    });
                                  },
                                  icon: userpost[index].isDisliked
                                      ? const Icon(Icons.thumb_down_alt)
                                      : const Icon(
                                          Icons.thumb_down_alt_outlined),
                                ),
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
        return Image.file(File(image[0].url!));
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
            // onTap: () => Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => FullImageScreen(
            //           images: image, detail: detail, user: user),
            //     )),
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
      // onTap: () => Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) =>
      //           FullImageScreen(images: image, detail: detail, user: user),
      //     )),
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
                    ? Image.file(File(image[index].url!))
                    : Image.network(image[index].url!),
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
                ? Image.file(File(image[index].url!))
                : Image.network(image[index].url!);
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
