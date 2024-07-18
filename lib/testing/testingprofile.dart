import 'package:flutter/material.dart';

import 'testogin.dart';
import 'testuserdetail.dart';

class ProfileScreen extends StatelessWidget {
  final AuthService _authService;

  /// The line `ProfileScreen({required AuthService authService}) : _authService = authService;` in the
  /// `ProfileScreen` class is a constructor that takes an `AuthService` object as a required parameter
  /// and assigns it to the private `_authService` variable of the `ProfileScreen` class.
  const ProfileScreen({required AuthService authService})
      : _authService = authService;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserDetailModel?>(
      future: _authService.getloggedinuser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading profile'));
        } else if (snapshot.hasData) {
          UserDetailModel user = snapshot.data!;
          return Scaffold(
            appBar: AppBar(title: const Text('Profile')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  user.profileImage != null
                      ? Image.network(user.profileImage!.imagePath!)
                      : const Placeholder(
                          fallbackHeight: 100, fallbackWidth: 100),
                  Text('Name: ${user.basicInfo?.name}'),
                  // Text('Email: ${}'),
                  ElevatedButton(
                    onPressed: () async {
                      await _authService.logout();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: Text('No user logged in'));
        }
      },
    );
  }
}
