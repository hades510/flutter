class UserFriendlist {
  int? userListId;
  int? userId;
  int? friendId;
  int? requestedBy;
  String? createdAt;
  bool? hasNewRequest;
  bool? hasNewRequestAccepted;
  bool? hasRemoved;

  UserFriendlist(
      {this.userListId,
      this.userId,
      this.friendId,
      this.requestedBy,
      this.createdAt,
      this.hasNewRequest,
      this.hasNewRequestAccepted,
      this.hasRemoved});

  UserFriendlist.fromJson(Map<String, dynamic> json) {
    userListId = json['user_list_id'];
    userId = json['user_id'];
    friendId = json['friend_id'];
    requestedBy = json['requested_by'];
    createdAt = json['created_at'];
    hasNewRequest = json['has_new_request'];
    hasNewRequestAccepted = json['has_new_request_accepted'];
    hasRemoved = json['has_removed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_list_id'] = userListId;
    data['user_id'] = userId;
    data['friend_id'] = friendId;
    data['requested_by'] = requestedBy;
    data['created_at'] = createdAt;
    data['has_new_request'] = hasNewRequest;
    data['has_new_request_accepted'] = hasNewRequestAccepted;
    data['has_removed'] = hasRemoved;
    return data;
  }
}
