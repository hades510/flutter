import 'package:socialapp/models/user_friendlist.dart';

class User {
  int? id;
  String? name;
  String? email;
  String? password;
  List<UserFriendlist>? friendList; // Add this line

  User({this.id, this.email, this.name, this.password, this.friendList});

  User.fromJson(Map<String, dynamic> map) {
    id = map['Id'];
    email = map['Email'];
    password = map['Password'];
    name = map['Name'];

    // Handle friendList
    if (map['FriendList'] != null) {
      friendList = (map['FriendList'] as List)
          .map((item) => UserFriendlist.fromJson(item))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Name'] = name;
    data['Password'] = password;
    data['Email'] = email;

    // Handle friendList
    if (friendList != null) {
      data['FriendList'] = friendList!.map((item) => item.toJson()).toList();
    }

    return data;
  }
}
