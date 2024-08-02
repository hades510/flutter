import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:socialapp/login.dart';

class Friendlist extends StatelessWidget {
  const Friendlist({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: const TextSpan(
                  style: TextStyle(fontSize: 30, color: Colors.black),
                  children: [
                    TextSpan(text: 'Login'),
                    TextSpan(text: 'First', style: TextStyle(fontSize: 10))
                  ]),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  )),
              child: Container(
                width: 100,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)),
                child:const Center(
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:socialapp/dataloader.dart';
// import 'authenthication/login_auth.dart';
// import 'models/user_friendlist.dart';

// class FriendRequestsScreen extends StatefulWidget {
//   int? userId;

//   FriendRequestsScreen({this.userId});

//   @override
//   _FriendRequestsScreenState createState() => _FriendRequestsScreenState();
// }

// class _FriendRequestsScreenState extends State<FriendRequestsScreen> {
//   late Future<List<UserFriendlist>> _requests;
//   late Auth _auth;

//   @override
//   void initState() {
//     super.initState();
//     _auth = Auth(Dataloader());
//     _requests = _auth.getUserRequests(widget.userId!);
//   }

//   Future<void> _acceptRequest(int userListId) async {
//     await _auth.acceptFriendRequest(userListId);
//     setState(() {
//       _requests = _auth.getUserRequests(widget.userId!);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Friend Requests')),
//       body: FutureBuilder<List<UserFriendlist>>(
//         future: _requests,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No friend requests'));
//           }
//           List<UserFriendlist> requests = snapshot.data!;
//           return ListView.builder(
//             itemCount: requests.length,
//             itemBuilder: (context, index) {
//               final request = requests[index];
//               return ListTile(
//                 title: Text('Request from user ${request.requestedBy}'),
//                 trailing: ElevatedButton(
//                   onPressed: () => _acceptRequest(request.userListId!),
//                   child: Text('Accept'),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
