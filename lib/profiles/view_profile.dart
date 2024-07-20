import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
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
      //checking if profileimage is null and the state of the check if it is network or local
      if (userDetail!.profileImage != null &&
          userDetail!.profileImage!.isNetworkUrl!) {
        //this displays the original/initial  image;
        profile = null;
      } else {
        //separate fn created because of async type was needed
        _loadprofileImage();
      }
      if (userDetail!.coverImage != null &&
          userDetail!.coverImage!.isNetworkUrl!) {
        cover = null;
      } else {
        _loadcoverImage();
      }
    });
  }

  //here this method was created, beacuse it has a async fn which needs to be set inside the setState

  //
  /// The function `_loadprofileImage` decodes a base64 image, saves it as a temporary file, and updates
  /// the profile with the temporary file.
  void _loadprofileImage() async {
    final imagepath = base64Decode(userDetail!.profileImage!
        .imagePath!); //decode the image that is located inside it into  uint8list

    // Creating a temporary file to store the image data
    //
    //creates a temporary directory
    final tempDir = await getTemporaryDirectory();
    // Creates a temporary file path in the temporary directory to store the image
    final tempFile = File('${tempDir.path}/temp_profile_image.png');

    // Write the decoded image data (Uint8List) to the temporary file
    // This will effectively save the image data as a file on the device
    tempFile.writeAsBytesSync(imagepath);
    setState(() {
      // Update profile with the temporary file
      profile = tempFile;
    });
  }

  Future _updateProfileImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final imageBytes = await file.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      setState(() {
        profile = file;
        userDetail!.profileImage!.imagePath = base64Image;
        userDetail!.profileImage!.isNetworkUrl =
            false; // Update flag for local image
      });

      // Save the updated user details
      await auth.saveUserDetail(userDetail!);
    }
  }

  void _loadcoverImage() async {
    final imagepath = base64Decode(userDetail!.coverImage!.imagepath!);

    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/temp_cover_image.png');
    tempFile.writeAsBytesSync(imagepath);
    setState(() {
      cover = tempFile;
    });
  }

  Future _updatecoverImage(ImageSource source) async {
    final picker = ImagePicker();
    XFile? picked = await picker.pickImage(source: source);
    if (picked != null) {
      File file = File(picked.path);
      Uint8List imagebytes = await file.readAsBytes();
      String base64string = base64Encode(imagebytes);

      setState(() {
        cover = file;
        userDetail!.coverImage!.imagepath = base64string;
        userDetail!.coverImage!.isNetworkUrl = false;
      });

      //for saving
      await auth.saveUserDetail(userDetail!);
    }
  }

  //created this imageprovider fn cause ternary operator in background image did't work
  //kept show error The argument type 'Object' can't be assigned to the parameter type 'ImageProvider<Object>?'
  ImageProvider<Object>? _getprofileimage() {
    if (profile != null) {
      return FileImage(profile!);
    } else if (userDetail != null && userDetail!.profileImage != null) {
      if (userDetail!.profileImage!.isNetworkUrl!) {
        return NetworkImage(userDetail!.profileImage!.imagePath!);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
// void _loadUserDetail() async {
//     UserDetail? detail = await auth.getloggedinuser(); // Fetch user details
//     setState(() {
//       userDetail = detail;
//
//     });
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('User Profile'),
            userDetail == null
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: const Icon(Icons.login)
                    // const Text(
                    //   'Login',
                    //   style: TextStyle(color: Colors.black),
                    // ),
                    )
                : ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePsw(),
                          ));
                    },
                    child: Image.asset('assets/images/reload.png',
                        height: 25, width: 25),
                    // const Text(
                    //   'Change Password',
                    //   style: TextStyle(color: Colors.black),
                    // ),
                  ),
            // GestureDetector(
            //     onTap: () {
            //       if (userDetail == null) {
            //         Navigator.pushReplacement(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) => const LoginPage(),//
            //             ));
            //       } else {
            //         Navigator.push(//here only used push because if i backed the
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) => const ChangePsw(),
            //             ));
            //       }
            //     },
            //     child:
            //     const Icon(
            //       Icons.lock,
            //     ),
            //     ),
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
                                    builder: (context) => FullCoverPic(
                                        detail:
                                            userDetail!), //here i passed the userdetail used to display the current logged profile detail
                                  ));
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
                              backgroundImage: _getprofileimage(),
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
                                          onPressed: () {
                                            _updateProfileImage(
                                                ImageSource.camera);
                                            Navigator.pop(context);
                                          },
                                          // XFile? camera =
                                          //     await picker.pickImage(
                                          //         source: ImageSource.camera);
                                          // if (camera != null) {
                                          //   profile = File(camera.path);
                                          //   List<int> bytes =
                                          //       await profile!.readAsBytes();
                                          //   profielbase64 =
                                          //       base64Encode(bytes);
                                          //   setState(() {});
                                          //

                                          child: const Text('Take Picture')),
                                      TextButton(
                                          onPressed: () {
                                            _updateProfileImage(
                                                ImageSource.gallery);
                                            Navigator.pop(context);
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
                                            onPressed: () {
                                              _updatecoverImage(
                                                  ImageSource.camera);
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Take Picture')),
                                        TextButton(
                                            onPressed: () {
                                              _updatecoverImage(
                                                  ImageSource.gallery);
                                              Navigator.pop(context);
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
                                      builder: (context) => const Home(),
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
