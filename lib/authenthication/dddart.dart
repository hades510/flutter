// // import 'dart:convert';

// // import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// // import '../dataloader.dart';
// // import '../models/user.dart';
// // import 'dart.dart';
// // // import 'data_loader.dart'; // Make sure to import your DataLoader class here

// // class ChangePasswordScreen extends StatefulWidget {
// //   final int userId;

// //   const ChangePasswordScreen({super.key, required this.userId});

// //   @override
// //   _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
// // }

// // class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
// //   final _formKey = GlobalKey<FormState>();
// //   final _currentPasswordController = TextEditingController();
// //   final _newPasswordController = TextEditingController();
// //   final _confirmPasswordController = TextEditingController();
// //   bool _isLoading = false;

// //   @override
// //   void dispose() {
// //     _currentPasswordController.dispose();
// //     _newPasswordController.dispose();
// //     _confirmPasswordController.dispose();
// //     super.dispose();
// //   }

// //   Future updatePassword(int userid, String? password) async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     String? userjson = prefs.getString(Dataloader.userkey);
// //     if (userjson != null) {
// //       List userlist = jsonDecode(userjson);
// //       for (var user in userlist) {
// //         if (user['Id'] == userid) {
// //           user['Password'] = password;
// //           break;
// //         }
// //       }
// //       String updatedjson = jsonEncode(userlist);
// //       prefs.setString(Dataloader.userkey, updatedjson);
// //       print('hello');//printed
// //     }
// //   }

// //   Future<void> _changePassword() async {
// //     if (_formKey.currentState!.validate()) {
// //       setState(() {
// //         _isLoading = true;
// //       });

// //       // Load existing user data
// //       Dataloader dataLoader = Dataloader();
// //       List<User> users = await dataLoader.getuser();
// //       User? user = users.firstWhere((user) => user.id == widget.userId);

// //       // Check if the current password matches
// //       if (user != null
// //        && user.password == _currentPasswordController.text) {
// //         // Update the password
// //         await updatePassword(widget.userId, _newPasswordController.text);

// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text('Password changed successfully')),
// //         );
// //       } else {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text('Current password is incorrect')),
// //         );
// //       }

// //       setState(() {
// //         _isLoading = false;
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Change Password'),
// //       ),
// //       body: _isLoading
// //           ? const Center(child: CircularProgressIndicator())
// //           : Padding(
// //               padding: const EdgeInsets.all(16.0),
// //               child: Form(
// //                 key: _formKey,
// //                 child: Column(
// //                   children: [
// //                     TextFormField(
// //                       controller: _currentPasswordController,
// //                       decoration:
// //                           const InputDecoration(labelText: 'Current Password'),
// //                       obscureText: true,
// //                       validator: (value) {
// //                         if (value == null || value.isEmpty) {
// //                           return 'Please enter your current password';
// //                         }
// //                         return null;
// //                       },
// //                     ),
// //                     TextFormField(
// //                       controller: _newPasswordController,
// //                       decoration:
// //                           const InputDecoration(labelText: 'New Password'),
// //                       validator: (value) {
// //                         if (value == null || value.isEmpty) {
// //                           return 'Please enter a new password';
// //                         }
// //                         return null;
// //                       },
// //                     ),
// //                     TextFormField(
// //                       controller: _confirmPasswordController,
// //                       decoration: const InputDecoration(
// //                           labelText: 'Confirm New Password'),
// //                       obscureText: true,
// //                       validator: (value) {
// //                         if (value == null || value.isEmpty) {
// //                           return 'Please confirm your new password';
// //                         }
// //                         if (value != _newPasswordController.text) {
// //                           return 'Passwords do not match';
// //                         }
// //                         return null;
// //                       },
// //                     ),
// //                     const SizedBox(height: 20),
// //                     ElevatedButton(
// //                       onPressed: _changePassword,
// //                       child: const Text('Change Password'),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //     );
// //   }
// // }
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:socialapp/dataloader.dart';
// import 'package:socialapp/models/user_detail.dart';

// import '../models/user.dart';
// import 'login_auth.dart';
// // import 'models/user.dart';

// class ChangePsw extends StatefulWidget {
//   const ChangePsw({super.key});

//   @override
//   State<ChangePsw> createState() => _ChangePswState();
// }

// class _ChangePswState extends State<ChangePsw> {
//   final formkey = GlobalKey<FormState>();
//   final TextEditingController oldpsw = TextEditingController();
//   final TextEditingController newpsw = TextEditingController();
//   final TextEditingController confirmpsw = TextEditingController();
//   bool obscureold = false;
//   bool obscurenew = false;
//   bool obscureconfirm = false;
//   Dataloader dataloader = Dataloader();

//   @override
//   void initState() {
//     super.initState();
//     dataloader.loadalluserdatas();
//   }

//   @override
//   void dispose() {
//     oldpsw.dispose();
//     newpsw.dispose();
//     confirmpsw.dispose();
//     super.dispose();
//   }

//   Future<void> changepassword() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? loggedInUserJson = prefs.getString(Auth.isUserloggedin);
//     if (loggedInUserJson != null) {
//       /// The above code snippet is declaring a Map variable named `loggedInUserMap` in Dart. It is then
//       /// using `jsonDecode` function to parse a JSON string `loggedInUserJson` and store the result in
//       /// the `loggedInUserMap` variable. The `loggedInUserJson` is assumed to be a JSON string
//       /// representing key-value pairs, and `jsonDecode` is used to convert it into a Map with String
//       /// keys and dynamic values.
//       Map<String, dynamic> loggedInUserMap = jsonDecode(loggedInUserJson);
//       User loggedInUser = User.fromJson(loggedInUserMap);
//       print('Logged In User: ${loggedInUser.password}');
//       print('Entered Old Password: ${oldpsw.text}');

//       if (oldpsw.text == loggedInUser.password) {
//         if (newpsw.text == confirmpsw.text) {
//           loggedInUser.password = newpsw.text;

//           List<User> users = await dataloader.getuser();
//           // Update the user in the users list
//           for (int i = 0; i < users.length; i++) {
//             if (users[i].id == loggedInUser.id) {
//               users[i] = loggedInUser;
//               break;
//             }
//           }

//           // Save the updated users list back to SharedPreferences
//           List<Map<String, dynamic>> updatedUsersMap =
//               users.map((user) => user.toJson()).toList();
//           prefs.setString(Dataloader.userkey, jsonEncode(updatedUsersMap));

//           // Also update the logged-in user data in SharedPreferences
//           prefs.setString(
//               Auth.isUserloggedin, jsonEncode(loggedInUser.toJson()));

//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Password changed successfully')),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('New passwords do not match')),
//           );
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Old password is incorrect')),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('User not logged in')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 25),
//           child: Form(
//             key: formkey,
//             child: Center(
//               child: SingleChildScrollView(
//                 child: ConstrainedBox(
//                   constraints: BoxConstraints(
//                     maxHeight: MediaQuery.of(context).size.height,
//                     maxWidth: MediaQuery.of(context).size.width,
//                   ),
//                   child: IntrinsicHeight(
//                     child: Column(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.all(5),
//                           decoration: BoxDecoration(
//                               border: Border.all(),
//                               borderRadius: BorderRadius.circular(10)),
//                           child: Image.asset(
//                             'assets/images/reload.png',
//                             height: 50,
//                             width: 50,
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         const Text(
//                           'Change Password',
//                           style: TextStyle(
//                               fontSize: 30, fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         TextFormField(
//                             controller: oldpsw,
//                             obscureText: !obscureold,
//                             decoration: InputDecoration(
//                               contentPadding:
//                                   const EdgeInsets.symmetric(vertical: 25),
//                               labelText: 'Old Password',
//                               prefixIcon: const Icon(Icons.lock),
//                               suffixIcon: IconButton(
//                                 onPressed: () {
//                                   setState(() {
//                                     obscureold = !obscureold;
//                                   });
//                                 },
//                                 icon: obscureold
//                                     ? const Icon(Icons.visibility_off)
//                                     : const Icon(Icons.visibility),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderSide:
//                                     const BorderSide(color: Colors.white),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide:
//                                     const BorderSide(color: Colors.white),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               filled: true,
//                               fillColor:
//                                   const Color.fromARGB(255, 241, 240, 240),
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter your old password';
//                               } else {
//                                 return null;
//                               }
//                             }),
//                         const SizedBox(
//                           height: 8,
//                         ),
//                         TextFormField(
//                             controller: newpsw,
//                             obscureText: !obscurenew,
//                             decoration: InputDecoration(
//                               contentPadding:
//                                   const EdgeInsets.symmetric(vertical: 25),
//                               labelText: 'New Password',
//                               prefixIcon: const Icon(Icons.lock),
//                               suffixIcon: IconButton(
//                                 onPressed: () {
//                                   setState(() {
//                                     obscurenew = !obscurenew;
//                                   });
//                                 },
//                                 icon: obscurenew
//                                     ? const Icon(Icons.visibility_off)
//                                     : const Icon(Icons.visibility),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderSide:
//                                     const BorderSide(color: Colors.white),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide:
//                                     const BorderSide(color: Colors.white),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               filled: true,
//                               fillColor:
//                                   const Color.fromARGB(255, 241, 240, 240),
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter your new password';
//                               } else {
//                                 return null;
//                               }
//                             }),
//                         const SizedBox(
//                           height: 8,
//                         ),
//                         TextFormField(
//                           controller: confirmpsw,
//                           obscureText: !obscureconfirm,
//                           decoration: InputDecoration(
//                             contentPadding:
//                                 const EdgeInsets.symmetric(vertical: 25),
//                             labelText: 'Confirm Password',
//                             prefixIcon: const Icon(Icons.lock),
//                             suffixIcon: IconButton(
//                               onPressed: () {
//                                 setState(() {
//                                   obscureconfirm = !obscureconfirm;
//                                 });
//                               },
//                               icon: obscureconfirm
//                                   ? const Icon(Icons.visibility_off)
//                                   : const Icon(Icons.visibility),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: const BorderSide(color: Colors.white),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: const BorderSide(color: Colors.white),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             filled: true,
//                             fillColor: const Color.fromARGB(255, 241, 240, 240),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please confirm the password';
//                             } else {
//                               return null;
//                             }
//                           },
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             if (formkey.currentState!.validate()) {
//                               changepassword();
//                             }
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.all(22),
//                             decoration: BoxDecoration(
//                               color: Colors.black,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 'Submit',
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w400,
//                                     fontSize: 18),
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
