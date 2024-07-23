// // // if (userDetail!.profileImage != null &&
// // //     userDetail!.profileImage!.isNetworkUrl!) {
// // //   // Display network image
// // //   _imageFile = null;
// // // } else {
// // //   // Handle local or base64 image
// // //   _loadLocalImage();
// // // }

// // // void _loadLocalImage() async {
// // //   final imagepath = base64Decode(userDetail!.profileImage!.imagePath!);

// // //   // Write the decoded data to a temporary file
// // //   final tempDir = await getTemporaryDirectory();
// // //   final tempFile = File('${tempDir.path}/temp_profile_image.png');
// // //   tempFile.writeAsBytesSync(imagepath);

// // //   setState(() {
// // //     _imageFile = tempFile;
// // //   });
// // // }

// // // Future<void> _updateProfileImage(ImageSource source) async {
// // //   final picker = ImagePicker();
// // //   final pickedFile = await picker.pickImage(source: source);
// // //   if (pickedFile != null) {
// // //     final file = File(pickedFile.path);
// // //     final imageBytes = await file.readAsBytes();
// // //     final base64Image = base64Encode(imageBytes);

// // //     setState(() {
// // //       _imageFile = file;
// // //       userDetail!.profileImage!.imagePath = base64Image;
// // //       userDetail!.profileImage!.isNetworkUrl =
// // //           false; // Update flag for local image
// // //     });

// // //     // Save the updated user details
// // //     await auth.saveUserDetail(userDetail!);
// // //   }
// // // }

// // // Future<void> _changePassword() async {
// // //   Navigator.push(
// // //     context,
// // //     MaterialPageRoute(builder: (context) => ChangePasswordPage()),
// // //   );
// // // }
// // import 'dart:convert';
// // import 'dart:io';

// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:socialapp/testing/test_auth.dart';
// // import 'package:socialapp/testing/test_changepsw.dart';
// // import 'package:socialapp/testing/test_dataloader.dart';
// // import 'package:socialapp/testing/test_login.dart';
// // import 'package:socialapp/testing/test_userdetail_model.dart';

// // class ProfilePage extends StatefulWidget {
// //   @override
// //   _ProfilePageState createState() => _ProfilePageState();
// // }

// // class _ProfilePageState extends State<ProfilePage> {
// //   late Auth auth;
// //   UserDetail? userDetail;
// //   File? _imageFile;

// //   @override
// //   void initState() {
// //     super.initState();
// //     auth = Auth(Dataloader());
// //     _loadUserDetail();
// //     _loadprofileimage();
// //   }

// //   void _loadUserDetail() async {
// //     UserDetail? detail = await auth.getloggedinuser();
// //     setState(() {
// //       userDetail = detail;
// //     });
// //   }

// // //here i sent the file path throug updateimage shared preferences
// //   Future<void> _loadprofileimage() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final imagepath = prefs.getString('profile_image_path');
// //     if (imagepath != null) {
// //       setState(() {
// //         _imageFile = File(imagepath);
// //       });
// //     }
// //   }

// //   Future<void> _updateimage(File file) async {
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.setString('profile_image_path', file.path);
// //     setState(() {
// //       _imageFile = file;
// //     });

// //     //updating the image and saving it
// //     if (userDetail != null) {
// //       userDetail!.profileImage = ProfileImage(
// //           imagePath:
// //               file.path); //this can be problem for all users update profile
// //       await auth.saveUserDetail(userDetail!);
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text("Profile")),
// //       body: userDetail == null
// //           ? Center(child: CircularProgressIndicator())
// //           : Padding(
// //               padding: const EdgeInsets.all(16.0),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   _imageFile != null
// //                       ? Image.file(
// //                           _imageFile!,
// //                           fit: BoxFit.cover,
// //                           width: 100,
// //                           height: 100,
// //                         )
// //                       : userDetail!.profileImage!.isNetworkUrl!
// //                           ? Image.network(
// //                               userDetail!.profileImage!.imagePath!,
// //                               fit: BoxFit.cover,
// //                               width: 100,
// //                               height: 100,
// //                             )
// //                           : SizedBox(),
// //                   SizedBox(height: 16),
// //                   ElevatedButton(
// //                     onPressed: () async {
// //                       final ImagePicker picker = ImagePicker();
// //                       final picked =
// //                           await picker.pickImage(source: ImageSource.camera);
// //                       if (picked != null) {
// //                         final file = File(picked.path);
// //                         await _updateimage(file);
// //                       }
// //                     },
// //                     //  _updateProfileImage(ImageSource.camera),
// //                     child: Text("Change Profile Picture"),
// //                   ),
// //                   SizedBox(height: 16),
// //                   ElevatedButton(
// //                     onPressed: () {
// //                       Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder: (context) => const ChangePasswordPage(),
// //                           ));
// //                     },
// //                     child: Text("Change Password"),
// //                   ),
// //                   SizedBox(height: 16),
// //                   ElevatedButton(
// //                     onPressed: () async {
// //                       await auth.logout();
// //                       Navigator.pushReplacement(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder: (context) => const LoginPage(),
// //                           ));
// //                     },
// //                     child: Text("logout"),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //     );
// //   }
// // }
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:socialapp/testing/test_auth.dart';
// import 'package:socialapp/testing/test_changepsw.dart';
// import 'package:socialapp/testing/test_dataloader.dart';
// import 'package:socialapp/testing/test_login.dart';
// import 'package:socialapp/testing/test_userdetail_model.dart';

// class ProfilePage extends StatefulWidget {
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   late Auth auth;
//   UserDetail? userDetail;
//   File? _imageFile;
//   String? updatename;
//   TextEditingController namechange = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     auth = Auth(Dataloader());
//     _loadUserDetail();
//     _loadProfileImage(); // Load the profile image on init
//     _loadname();
//   }

//   void _loadUserDetail() async {
//     UserDetail? detail = await auth.getloggedinuser();
//     setState(() {
//       userDetail = detail;
//     });
//   }

//   Future<void> _updateProfileImage(File file) async {
//     final prefs = await SharedPreferences.getInstance();

//     if (userDetail != null) {
//       final userId = userDetail!.id; // Get the user ID from UserDetail
//       final imagePathKey = 'profile_image_path_$userId';
//       await prefs.setString(
//           imagePathKey, file.path); // Save the profile image path

//       setState(() {
//         _imageFile = file; // Update local state with the new image
//       });

//       // Optionally update userDetail with the new image path
//       userDetail!.profileImage = ProfileImage(imagePath: file.path);
//       await auth.saveUserDetail(userDetail!); // Save the updated UserDetail
//     }
//   }

//   Future<void> _loadProfileImage() async {
//     final prefs = await SharedPreferences.getInstance();

//     if (userDetail != null) {
//       final userId = userDetail!.id; // Get the user ID from UserDetail
//       final imagePathKey = 'profile_image_path_$userId';
//       final imagePath =
//           prefs.getString(imagePathKey); // Retrieve the saved image path

//       if (imagePath != null) {
//         setState(() {
//           _imageFile =
//               File(imagePath); // Update local state with the saved image
//         });
//       }
//     }
//   }

//   Future<void> _updatename(String newname) async {
//     final prefs = await SharedPreferences.getInstance();

//     if (userDetail != null) {
//       final userid = userDetail!.id;
//       final namekey = 'name_$userid';
//       await prefs.setString(namekey, newname);
//       // userDetail!.basicInfo!.name = newname;
//       setState(() {
//         updatename = newname;
//         userDetail!.basicInfo!.name =
//             newname; //updating the userdetail with newname
//       });
//       await auth.saveUserDetail(userDetail!); //save the updated userDtail
//     }
//   }

//   Future<void> _loadname() async {
//     final prefs = await SharedPreferences.getInstance();
//     if (userDetail != null) {
//       final userid = userDetail!.id;
//       final namekey = 'name_$userid';
//       final uname = prefs.getString(namekey);

//       if (uname != null) {
//         setState(() {
//           updatename = uname;
//           userDetail!.basicInfo!.name = uname;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Profile")),
//       body: userDetail == null
//           ? Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _imageFile != null
//                       ? Image.file(
//                           _imageFile!,
//                           fit: BoxFit.cover,
//                           width: 100,
//                           height: 100,
//                         )
//                       : Image.network(
//                           userDetail!.profileImage!.imagePath!,
//                           fit: BoxFit.cover,
//                           width: 100,
//                           height: 100,
//                         ),
//                   SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () async {
//                       final ImagePicker picker = ImagePicker();
//                       final picked =
//                           await picker.pickImage(source: ImageSource.camera);
//                       if (picked != null) {
//                         final file = File(picked.path);
//                         await _updateProfileImage(file); // Update profile image
//                       }
//                     },
//                     child: Text("Change Profile Picture"),
//                   ),
//                   SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const ChangePasswordPage(),
//                           ));
//                     },
//                     child: Text("Change Password"),
//                   ),
//                   SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () async {
//                       await auth.logout();
//                       Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const LoginPage(),
//                           ));
//                     },
//                     child: Text("Logout"),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         userDetail!.basicInfo?.name ?? '',
//                         style: const TextStyle(
//                             fontSize: 28, fontWeight: FontWeight.bold),
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           showDialog(
//                             context: context,
//                             builder: (context) {
//                               return AlertDialog(
//                                 title: const Text('Your name'),
//                                 content: TextField(
//                                   controller: namechange,
//                                   decoration: const InputDecoration(
//                                     labelText: 'Name',
//                                     border: OutlineInputBorder(),
//                                     focusedBorder: OutlineInputBorder(),
//                                   ),
//                                 ),
//                                 actions: [
//                                   TextButton(
//                                       onPressed: () => Navigator.pop(context),
//                                       child: const Text('Cancel')),
//                                   TextButton(
//                                       onPressed: () {
//                                         if (namechange.text.isNotEmpty) {
//                                           _updatename(namechange.text);
//                                           Navigator.pop(context);
//                                         }
//                                       },
//                                       child: const Text('Submit')),
//                                 ],
//                               );
//                             },
//                           );
//                         },
//                         child: const Icon(
//                           Icons.edit_outlined,
//                           size: 30,
//                         ),
//                       )
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   _buildcontainer(
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             _buildSectionTitle("Work Experience"),
//                             const Icon(
//                               Icons.edit_outlined,
//                               size: 30,
//                             ),
//                           ],
//                         ),
//                         ...userDetail!
//                             .workExperience! //here spread operator is used to insert all the elements to another collection
//                             .map((work) => _buildWorkExperience(work)),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildcontainer(Widget child) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//       decoration: BoxDecoration(
//           border: Border.all(), borderRadius: BorderRadius.circular(10)),
//       child: child,
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Text(
//         title,
//         style: const TextStyle(
//             fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
//       ),
//     );
//   }

//   Widget _buildWorkExperience(WorkExperience work) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             work.jobTitle!,
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//           ),
//           Text(
//             '${work.organizationName} (${work.startDate} - ${work.endDate})',
//             style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//           ),
//           Text(
//             work.summary!,
//             style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/testing/test_auth.dart';
import 'package:socialapp/testing/test_changepsw.dart';
import 'package:socialapp/testing/test_dataloader.dart';
import 'package:socialapp/testing/test_login.dart';
import 'package:socialapp/testing/test_userdetail_model.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Auth auth;
  UserDetail? userDetail;
  File? _imageFile;
  String? updatename;
  TextEditingController namechange = TextEditingController();

  //work
  final workformkey = GlobalKey<FormState>();
  TextEditingController job = TextEditingController();
  TextEditingController organization = TextEditingController();
  TextEditingController jobsummary = TextEditingController();
  DateTime? sdate;
  DateTime? edate;
  String? startdate;
  String? enddate;

  @override
  void initState() {
    super.initState();
    auth = Auth(Dataloader());
    _loadUserDetail();
    _loadProfileImage();
    _loadname();
    _loadWorkExperience();
  }

  void _loadUserDetail() async {
    UserDetail? detail = await auth.getloggedinuser();
    setState(() {
      userDetail = detail;
    });
  }

  Future<void> _updateProfileImage(File file) async {
    final prefs = await SharedPreferences.getInstance();

    if (userDetail != null) {
      final userId = userDetail!.id;
      final imagePathKey = 'profile_image_path_$userId';
      await prefs.setString(imagePathKey, file.path);

      setState(() {
        _imageFile = file;
      });

      userDetail!.profileImage = ProfileImage(imagePath: file.path);
      await auth.saveUserDetail(userDetail!);
    }
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();

    if (userDetail != null) {
      final userId = userDetail!.id;
      final imagePathKey = 'profile_image_path_$userId';
      final imagePath = prefs.getString(imagePathKey);

      if (imagePath != null) {
        setState(() {
          _imageFile = File(imagePath);
        });
      }
    }
  }

  Future<void> _updatename(String newname) async {
    final prefs = await SharedPreferences.getInstance();

    if (userDetail != null) {
      final userid = userDetail!.id;
      final namekey = 'name_$userid';
      await prefs.setString(namekey, newname);

      setState(() {
        updatename = newname;
        userDetail!.basicInfo!.name = newname;
      });
      await auth.saveUserDetail(userDetail!);
    }
  }

  Future<void> _loadname() async {
    final prefs = await SharedPreferences.getInstance();
    if (userDetail != null) {
      final userid = userDetail!.id;
      final namekey = 'name_$userid';
      final uname = prefs.getString(namekey);

      if (uname != null) {
        setState(() {
          updatename = uname;
          userDetail!.basicInfo!.name = uname;
        });
      }
    }
  }

  Future<void> _updateworkexp(
      List<WorkExperience> updatedWorkExperience) async {
    final prefs = await SharedPreferences.getInstance();

    if (userDetail != null) {
      final userId = userDetail!.id;
      final workExperienceKey = 'work_experience_$userId';
      final workExperienceJson =
          updatedWorkExperience.map((e) => e.toJson()).toList();

      await prefs.setString(workExperienceKey, jsonEncode(workExperienceJson));

      setState(() {
        userDetail!.workExperience = updatedWorkExperience;
      });

      await auth.saveUserDetail(userDetail!);
    }
  }

  Future<void> _loadWorkExperience() async {
    final prefs = await SharedPreferences.getInstance();

    if (userDetail != null) {
      final userId = userDetail!.id;
      final workExperienceKey = 'work_experience_$userId';
      final workExperienceJson = prefs.getString(workExperienceKey);

      if (workExperienceJson != null) {
        final List<dynamic> jsonList = jsonDecode(workExperienceJson);
        final workExperienceList =
            jsonList.map((e) => WorkExperience.fromJson(e)).toList();

        setState(() {
          userDetail!.workExperience = workExperienceList;
        });
      }
    }
  }

  Future<void> _addworkexp() async {
    showDialog(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: _buildSectionTitle('Add Work Experience'),
            content: Form(
              key: workformkey,
              child: Container(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    TextFormField(
                      controller: job,
                      decoration: const InputDecoration(
                        labelText: 'Job Title',
                        enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                        errorBorder: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a job title' : null,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: jobsummary,
                      decoration: const InputDecoration(
                        labelText: 'Summary',
                        enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                        errorBorder: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a jobsummary' : null,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: organization,
                      decoration: const InputDecoration(
                        labelText: 'Organization',
                        enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                        errorBorder: OutlineInputBorder(),
                      ),
                      validator: (value) => value!.isEmpty
                          ? 'Please enter the organization name'
                          : null,
                    ),
                    ListTile(
                      title: Text(sdate == null
                          ? 'Select a date'
                          : 'Startdate $startdate'),
                      onTap: () async {
                        DateTime? picker = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1990),
                            lastDate: DateTime.now());
                        if (picker != null && picker != sdate) {
                          setState(() {
                            sdate = picker;
                            startdate = DateFormat('y-MM-dd').format(sdate!);
                            if (edate != null && edate!.isBefore(sdate!)) {
                              edate = null;
                            }
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: Text(edate == null
                          ? 'Select a date'
                          : 'Enddate ${DateFormat('y-MM-dd').format(edate!)}'),
                      onTap: () async {
                        if (sdate == null) {
                          return;
                        }
                        DateTime? picker = await showDatePicker(
                            context: context,
                            initialDate: edate ??
                                (sdate != null
                                    ? sdate!.add(
                                        const Duration(days: 1),
                                      )
                                    : DateTime.now()),
                            firstDate: sdate?.add(const Duration(days: 1)) ??
                                DateTime.now(),
                            lastDate: DateTime.now());
                        if (picker != null && picker != sdate) {
                          setState(() {
                            edate = picker;

                            enddate = DateFormat('y-MM-dd').format(edate!);
                          });
                        }
                      },
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (workformkey.currentState!.validate()) {
                            if (userDetail != null) {
                              final workexp = WorkExperience(
                                  jobTitle: job.text,
                                  startDate: startdate,
                                  endDate: enddate,
                                  organizationName: organization.text,
                                  summary: jobsummary.text);
                              final updatedList = List<WorkExperience>.from(
                                  userDetail!.workExperience ?? []);
                              updatedList.add(workexp);
                              _updateworkexp(updatedList);
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: const Text('Submit')),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _removeWorkExperience(WorkExperience work) {
    if (userDetail != null) {
      final updatedList =
          List<WorkExperience>.from(userDetail!.workExperience ?? []);
      updatedList.remove(work);
      _updateworkexp(updatedList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      resizeToAvoidBottomInset: true, //ensures content resizing
      body: userDetail == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _imageFile != null
                        ? Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          )
                        : Image.network(
                            userDetail!.profileImage!.imagePath!,
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final picked =
                            await picker.pickImage(source: ImageSource.camera);
                        if (picked != null) {
                          final file = File(picked.path);
                          await _updateProfileImage(file);
                        }
                      },
                      child: Text('Change Profile Image'),
                    ),
                    SizedBox(height: 16),
                    Text('Name: ${userDetail!.basicInfo!.name}'),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Change Name'),
                              content: TextField(
                                controller: namechange,
                                decoration:
                                    InputDecoration(labelText: 'New Name'),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _updatename(namechange.text);
                                    Navigator.pop(context);
                                  },
                                  child: Text('Update'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text('Update Name'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChangePasswordPage(),
                            ));
                      },
                      child: Text("Change Password"),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        await auth.logout();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ));
                      },
                      child: Text("Logout"),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _addworkexp,
                      child: Text('Add Work Experience'),
                    ),
                    ...?userDetail!.workExperience?.map(
                      (work) => _buildContainer(
                        ListTile(
                          title: Text(work.jobTitle ?? ''),
                          subtitle: Text(work.organizationName ?? ''),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _removeWorkExperience(work),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionTitle('Skills'),
                        const Icon(
                          Icons.edit_outlined,
                          size: 30,
                        )
                      ],
                    ),
                    _buildChips(userDetail!.skills!
                        .map((skill) => skill.title!)
                        .toList()),
                    // Expanded(
                    //   child: ListView(
                    //     children: userDetail!.workExperience
                    //             ?.map((work) => _buildContainer(
                    //                   ListTile(
                    //                     title: Text(work.jobTitle ?? ''),
                    //                     subtitle:
                    //                         Text(work.organizationName ?? ''),
                    //                     trailing: IconButton(
                    //                       icon: Icon(Icons.delete),
                    //                       onPressed: () =>
                    //                           _removeWorkExperience(work),
                    //                     ),
                    //                   ),
                    //                 ))
                    //             .toList() ??
                    //         [],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildContainer(Widget child) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
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
}
