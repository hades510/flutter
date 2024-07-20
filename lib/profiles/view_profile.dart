import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:socialapp/authenthication/dddart.dart';
import 'package:socialapp/change_psw.dart';
import 'package:socialapp/dataloader.dart';
import 'package:socialapp/home.dart';
import 'package:socialapp/login.dart';
// import 'package:socialapp/models/user.dart';
import 'package:socialapp/models/user_detail.dart';
import 'package:socialapp/profiles/cover_full.dart';
import 'package:socialapp/profiles/profile_full.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';

import '../authenthication/login_auth.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile({super.key});

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  late Auth auth;
  UserDetail? userDetail;
  //image
  final ImagePicker picker = ImagePicker();
  File? profile;
  File? cover;
  String? profielbase64;

  @override
  void initState() {
    super.initState();
    auth = Auth(Dataloader());
    _loaduserDetail();
  }

  void _loaduserDetail() async {
    UserDetail? detail = await auth.getloggedinuser();
    setState(() {
      userDetail = detail;
      if (userDetail!.profileImage != null &&
          !userDetail!.profileImage!.isNetworkUrl!) {
        final imagepath = base64Decode(userDetail!.profileImage!.imagePath!);

        // Creating a temporary file to store the image data
        final tempDir = Directory.systemTemp;
        final tempFile = File('${tempDir.path}/temp_profile_image.png');

        // Write the decoded data to the temporary file
        tempFile.writeAsBytesSync(imagepath);

        // Update _imageFile with the temporary file
        profile = tempFile;
      }
    });
  }
 Future<void> _changeProfilePicture() async {
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery, // Change to ImageSource.camera for camera
      imageQuality: 100, // Adjust image quality as needed
    );

    if (pickedFile != null) {
      setState(() {
        profile = File(pickedFile.path);
      });

      // Update user details with the new profile image
      if (userDetail != null) {
        final bytes = profile!.readAsBytesSync();
        userDetail!.profileImage = ProfileImage(
          isNetworkUrl: false,
          imagePath: base64Encode(bytes), // Encode file to base64
        );

        // Save the updated user detail (e.g., to SharedPreferences or server)
        await auth
      }
    }
  }

// void _loadUserDetail() async {
//     UserDetail? detail = await auth.getloggedinuser(); // Fetch user details
//     setState(() {
//       userDetail = detail;
//       if (userDetail?.profileImage != null && !userDetail!.profileImage!.isNetworkUrl!) {
//         profile = File(base64Decode(userDetail!.profileImage!.imagePath!));
//       }
//     });
//   }
  // void _changeprofile() async {
  //   bool replaces = await auth.changeprofiles(profielbase64!);
  //   if (replaces == false) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('failed')));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('User Profile'),
            GestureDetector(
                onTap: () {
                  if (userDetail == null) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ));
                  } else {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePsw(),
                        ));
                  }
                },
                child: const Icon(
                  Icons.lock,
                )),
          ],
        ),
      ),
      body: userDetail == null
          ? const Center(
              child: Text('No user logged in'),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 275,
                    child: Stack(
                      /// The above code is setting the `clipBehavior` property of an object to `Clip.none`. This
                      /// means that clipping behavior is disabled for the object, allowing it to be drawn outside
                      /// its bounds.
                      clipBehavior: Clip.none,

                      //enabled the overlapping effect to the profilepicture
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
                                    builder: (context) =>
                                        FullCoverPic(detail: userDetail!),
                                  ));
                            },
                            child: Image.network(
                              userDetail!.coverImage!.imagepath!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Image.asset('assets/images/test.jpg', fit: BoxFit.cover),
                        ),
                        Positioned(
                          left: 16,
                          bottom: 2,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullProfilePic(
                                      detail: userDetail!,
                                    ),
                                  ));
                            },
                            child: CircleAvatar(
                              radius: 70,
                              backgroundImage: NetworkImage(
                                  userDetail!.profileImage!.imagePath!),
                              // AssetImage('assets/images/test.jpg'),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 220,
                          top: 185,
                          child: GestureDetector(
                            onTap: () {
                              print('profile');
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Choose profile Picture'),
                                    actions: [
                                      TextButton(
                                          onPressed: () async {
                                            XFile? camera =
                                                await picker.pickImage(
                                                    source: ImageSource.camera);
                                            if (camera != null) {
                                              profile = File(camera.path);
                                              List<int> bytes =
                                                  await profile!.readAsBytes();
                                              profielbase64 =
                                                  base64Encode(bytes);
                                              setState(() {});
                                              // if (userDetail != null) {
                                              //   userDetail!.profileImage =
                                              //       ProfileImage(
                                              //     isNetworkUrl: false,
                                              //     imagePath: profielbase64,
                                              //   );
                                              // }
                                            }
                                          },
                                          child: const Text('Take Picture')),
                                      TextButton(
                                          onPressed: () async {
                                            XFile? gallery =
                                                await picker.pickImage(
                                                    source:
                                                        ImageSource.gallery);
                                            if (gallery != null) {
                                              setState(() {
                                                profile = File(gallery.path);
                                              });
                                            }
                                          },
                                          child: const Text(
                                              'Choose from Gallery')),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const CircleAvatar(
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
                            top: 150,
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
                                              XFile? camera =
                                                  await picker.pickImage(
                                                      source:
                                                          ImageSource.camera);
                                              if (camera != null) {
                                                setState(() {
                                                  cover = File(camera.path);
                                                });
                                              }
                                            },
                                            child: const Text('Take Picture')),
                                        TextButton(
                                            onPressed: () async {
                                              XFile? gallery =
                                                  await picker.pickImage(
                                                      source:
                                                          ImageSource.gallery);
                                              if (gallery != null) {
                                                setState(() {
                                                  cover = File(gallery.path);
                                                });
                                              }
                                            },
                                            child: const Text(
                                                'Choose from Gallery')),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const CircleAvatar(
                                  backgroundColor: Colors.black,
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                  )),
                            )),
                      ],
                    ),
                  ),
                  // IconButton(
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) =>
                  //                 ChangePasswordScreen(userId: 1),
                  //           ));
                  //     },
                  //     icon: const Icon(Icons.add)),
                  // const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userDetail!.basicInfo?.name ?? '',
                                  style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text('${userDetail!.id}'),
                                const SizedBox(height: 8),
                                Text(
                                  userDetail!.basicInfo?.summary ?? '',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[700]),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () async {
                                await auth.logout();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        duration: Duration(seconds: 1),
                                        content: Text('Logged out')));
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginPage(),
                                    ));
                              },
                              child: const Icon(Icons.logout),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Basic Information'),
                              _buildInfoRow('Gender',
                                  userDetail!.basicInfo?.gender ?? ''),
                              _buildInfoRow('Date of Birth',
                                  userDetail!.basicInfo?.dob ?? ''),
                              _buildInfoRow('Marital Status',
                                  userDetail!.basicInfo?.maritalStatus ?? ''),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildcontainer(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle("Work Experience"),
                              ...userDetail!
                                  .workExperience! //here spread operator is used to insert all the elements to another collection
                                  .map((work) => _buildWorkExperience(work)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildcontainer(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Skills'),
                              _buildChips(userDetail!.skills!
                                  .map((skill) => skill.title!)
                                  .toList()),
                              const SizedBox(height: 16),
                              _buildSectionTitle('Hobbies'),
                              _buildChips(userDetail!.hobbies!
                                  .map((hobby) => hobby.title!)
                                  .toList()),
                              const SizedBox(height: 16),
                              _buildSectionTitle('Languages'),
                              _buildChips(userDetail!.languages!
                                  .map((lang) => lang.title!)
                                  .toList()),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildcontainer(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Education'),
                              ...userDetail!.education!.map(
                                  (education) => _buildEducation(education)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildcontainer(Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle('Accomplishments'),
                            ...userDetail!.accomplishments!
                                .map((acc) => _buildAccomplishment(acc)),
                          ],
                        )),
                        const SizedBox(height: 16),
                        _buildcontainer(Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle('Contact Information'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Mobile No.',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[700]),
                                ),
                                Text(
                                  userDetail!.contactInfo?.mobileNo ?? '',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[700]),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            // _buildInfoRow(
                            //     'Mobile No', userDetail.contactInfo?.mobileNo ?? ''),
                            _buildSectionTitle('Social Media'),
                            ...userDetail!.contactInfo!.socialMedia!
                                .map((social) => _buildSocialMedia(social)),
                          ],
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // Future<UserDetail> _fetchUserData() async {
  Widget _buildcontainer(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(10)),
      child: child,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkExperience(WorkExperience work) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            work.jobTitle!,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            '${work.organizationName} (${work.startDate} - ${work.endDate})',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          Text(
            work.summary!,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildChips(List<String> items) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: items.map((item) {
        return Chip(
          label: Text(
            item,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
        );
      }).toList(),
    );
  }

  Widget _buildEducation(Education education) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            education.level!,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            '${education.organizationName} (${education.startDate} - ${education.endDate})',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          Text(
            education.summary!,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildAccomplishment(Accomplishments accomplishment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            accomplishment.title!,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            accomplishment.description!,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMedia(SocialMedia social) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          children: [
            // _buildSectionTitle("Social Media"),
            GestureDetector(
              onTap: () async {
                final Uri url = Uri.parse(social.url!);
                print(url);

                await launchUrl(url);
              },
              child: Text(
                social.title!,
                style: const TextStyle(color: Colors.blue, fontSize: 16),
              ),
            )
          ],
        ));
  }
}
