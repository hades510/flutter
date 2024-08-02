import 'package:flutter/material.dart';

import '../dataloader.dart';
import '../models/user_friendlist.dart';

class SentFriendRequestsScreen extends StatelessWidget {
  final int userId;

  const SentFriendRequestsScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sent Friend Requests'),
      ),
      body: FutureBuilder(
        future: _fetchSentRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || (snapshot.data as List<UserFriendlist>).isEmpty) {
            return const Center(
              child: Text('No sent friend requests'),
            );
          } else {
            final List<UserFriendlist> sentRequests = snapshot.data as List<UserFriendlist>;
            return ListView.builder(
              itemCount: sentRequests.length,
              itemBuilder: (context, index) {
                return _buildRequestItem(sentRequests[index]);
              },
            );
          }
        },
      ),
    );
  }

  Future<List<UserFriendlist>> _fetchSentRequests() async {
    Dataloader dataloader = Dataloader();
    return dataloader.getSentFriendRequests(userId);
  }

  Widget _buildRequestItem(UserFriendlist request) {
    return ListTile(
      title: Text('To: ${request.requestedTo}'),
      subtitle: Text('Status: ${_getStatus(request)}'),
      trailing: _buildStatusBadge(request),
    );
  }

  String _getStatus(UserFriendlist request) {
    if (request.hasNewRequestAccepted!) {
      return 'Accepted';
    } else if (request.hasRemoved!) {
      return 'Removed';
    } else if (request.hasNewRequest!) {
      return 'Pending';
    } else {
      return 'Unknown';
    }
  }

  Widget _buildStatusBadge(UserFriendlist request) {
    if (request.hasRemoved!) {
      return const Icon(Icons.cancel, color: Colors.red);
    } else if (request.hasNewRequestAccepted!) {
      return const Icon(Icons.check_circle, color: Colors.green);
    } else if (request.hasNewRequest!) {
      return Icon(Icons.access_time, color: Colors.blue);
    } else {
      return const Icon(Icons.done, color: Colors.grey);
    }
  }
}
