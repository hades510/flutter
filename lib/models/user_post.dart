class UserPost {
  int? postId;
  int? userId;
  int? createdAt;
  String? title;
  String? description;
  List<Postedphoto>? image;
  List<PostLikedBy>? postLikedBy;
  // int? likeCount;

  //to manage like and dislike of each post
  bool? isliked;
  bool? isDisliked;

  UserPost({
    this.postId,
    this.userId,
    this.createdAt,
    this.title,
    this.description,
    this.image,
    this.postLikedBy,
    this.isDisliked,
    this.isliked,
    // this.likeCount
  });

  UserPost.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    title = json['title'];
    description = json['description'];
    if (json['Postedphoto'] != null) {
      image = <Postedphoto>[];
      json['Postedphoto'].forEach((v) {
        image!.add(Postedphoto.fromJson(v));
      });
    }
    if (json['Post_liked_by'] != null) {
      postLikedBy = <PostLikedBy>[];
      json['Post_liked_by'].forEach((v) {
        postLikedBy!.add(PostLikedBy.fromJson(v));
      });
    }
    isDisliked = json['isDisliked'];
    isliked = json['isliked'];
    // likeCount = json['likeCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['post_id'] = postId;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['title'] = title;
    data['description'] = description;
    if (image != null) {
      data['Postedphoto'] = image!.map((v) => v.toJson()).toList();
    }
    if (postLikedBy != null) {
      data['Post_liked_by'] = postLikedBy!.map((v) => v.toJson()).toList();
    }
    data['isDisliked'] = isDisliked;
    data['isliked'] = isliked;
    // data['likeCount'] = likeCount;

    return data;
  }
}

class Postedphoto {
  int? id;
  String? url;
  //to manage like and dislike state of each image
  bool? isLiked;
  bool? isDisliked;
  int? likeCount;

  Postedphoto({
    this.id,
    this.url,
    this.isDisliked,
    this.isLiked,
    this.likeCount,
  });

  Postedphoto.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    url = json['Url'];
    isDisliked = json['isDisliked'];
    isLiked = json['isliked'];
    likeCount = json['likeCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Url'] = url;
    data['isDisliked'] = isDisliked;
    data['isliked'] = isLiked;
    data['likeCount'] = likeCount;

    return data;
  }
}

class PostLikedBy {
  int? userId;
  String? dateTime;

  PostLikedBy({this.userId, this.dateTime});

  PostLikedBy.fromJson(Map<String, dynamic> json) {
    userId = json['User_id'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['User_id'] = userId;
    data['dateTime'] = dateTime;
    return data;
  }
}
