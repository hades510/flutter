import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:socialapp/testing/test_auth.dart';
import 'package:socialapp/testing/test_dataloader.dart';
import 'package:socialapp/testing/test_userdetail_model.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Auth auth;
  UserDetail? userDetail;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    auth = Auth(Dataloader());
    _loadUserDetail();
  }

  void _loadUserDetail() async {
    UserDetail? detail = await auth.getloggedinuser();
    setState(() {
      userDetail = detail;
      if (userDetail!.profileImage != null &&
          userDetail!.profileImage!.isNetworkUrl!) {
        // Display network image
        _imageFile = null;
      } else {
        // Handle local or base64 image
        _loadLocalImage();
      }
    });
  }

  void _loadLocalImage() async {
    final imagepath = base64Decode(userDetail!.profileImage!.imagePath!);

    // Write the decoded data to a temporary file
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/temp_profile_image.png');
    tempFile.writeAsBytesSync(imagepath);

    setState(() {
      _imageFile = tempFile;
    });
  }

  Future<void> _updateProfileImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final imageBytes = await file.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      setState(() {
        _imageFile = file;
        userDetail!.profileImage!.imagePath = base64Image;
        userDetail!.profileImage!.isNetworkUrl =
            false; // Update flag for local image
      });

      // Save the updated user details
      await auth.saveUserDetail(userDetail!);
    }
  }

  // Future<void> _changePassword() async {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => ChangePasswordPage()),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: userDetail == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
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
                      : userDetail!.profileImage!.isNetworkUrl!
                          ? Image.network(
                              userDetail!.profileImage!.imagePath!,
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            )
                          : SizedBox(),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _updateProfileImage(ImageSource.gallery),
                    child: Text("Change Profile Picture"),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("Change Password"),
                  ),
                ],
              ),
            ),
    );
  }
}
