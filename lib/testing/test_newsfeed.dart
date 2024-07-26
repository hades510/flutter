import 'package:flutter/material.dart';
import 'package:socialapp/testing/test_album.dart';
import 'package:socialapp/testing/test_auth.dart';
import 'package:socialapp/testing/test_dataloader.dart';
import 'package:socialapp/testing/test_login.dart';
import 'package:socialapp/testing/test_model_user.dart';
import 'package:socialapp/testing/test_profile.dart';
import 'package:socialapp/testing/test_userdetail_model.dart';
import 'package:socialapp/testing/test_userpost.dart';

class Newsfeed extends StatefulWidget {
  const Newsfeed({
    super.key,
  });

  @override
  State<Newsfeed> createState() => _HomeState();
}

class _HomeState extends State<Newsfeed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _fetchuserpost(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else {
            return Newscreen(
              post: snapshot.data!['posts'], //(fetched the data tin this key)
              user: snapshot.data!['users'],
              userdetail: snapshot.data!['userdetails'],
            );
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _fetchuserpost() async {
    Dataloader dataloader = Dataloader();

    List<UserPost> posts = await dataloader.getuserpost(); //loaded the data and
    List<UserDetail> userdetail = await dataloader.getuserdetail();
    List<User> user = await dataloader.getuser();

    return {
      'users': user, //(passed the data to this keys)
      'userdetails': userdetail,
      'posts': posts,
    };
  }
}

class Newscreen extends StatefulWidget {
  List<UserPost> post;
  List<User> user;
  List<UserDetail> userdetail;
  Newscreen({
    super.key,
    required this.post,
    required this.user,
    required this.userdetail,
  });

  @override
  State<Newscreen> createState() => _NewscreenState();
}

class _NewscreenState extends State<Newscreen> {
  UserDetail? userDetail;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('NewsFeed'),
            userDetail == null
                ? GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        )),
                    child: const Icon(Icons.login))
                : GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(),
                        )),
                    child: const Icon(Icons.person))
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: widget.post.length,
          itemBuilder: (context, index) {
            return _builderpostscreen(widget.post[index]);
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
        ),
      ),
    );
  }

  User getuserid(int userid) {
    return widget.user
        .firstWhere((element) => element.id == userid); //don't know why
  }

  UserDetail getid(int id) {
    return widget.userdetail.firstWhere((element) => element.id == id);
  }

  Widget _builderpostscreen(UserPost model) {
    User users = getuserid(model.userId!);
    UserDetail userDetail = getid(model.userId!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(userDetail.profileImage!.imagePath!),
          ),
          title: Text(users.name!),
          subtitle: Text(users.email!),
        ),
        // const SizedBox(
        //   height: 8,
        // ),
        Text(model.title!),
        Text(model.description!),
        Card(
          elevation: 5,
          child: _builderimage(
            model.image!,
            userDetail,
            users,
          ),
        ),

        Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                // enableFeedback: true,
                tooltip: 'Like',
                onPressed: () {
                  setState(() {
                    model.isliked = !model.isliked;
                    if (model.isliked) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text('Liked the post')));
                    }
                  });
                },
                icon: model.isliked
                    ? const Icon(Icons.thumb_up_alt)
                    : const Icon(Icons.thumb_up_alt_outlined),
              ),
              IconButton(
                tooltip: 'Dislike',
                onPressed: () {
                  setState(() {
                    model.isDisliked = !model.isDisliked;
                    if (model.isDisliked) {
                      model.isliked = false;
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text('Disliked the post')));
                    }
                  });
                },
                icon: model.isDisliked
                    ? const Icon(Icons.thumb_down_alt)
                    : const Icon(Icons.thumb_down_alt_outlined),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _builderimage(List<Postedphoto> image, UserDetail detail, User user) {
    int remainimages =
        image.length - 3; //remaining after 3 images foe the stack
    if (image.length == 1) {
      return Image.network(
        image[0].url!,
        // width: double.infinity,
      );
    } else if (image.length == 3) {
      return Column(
        children: [
          //this is if there is 3 photo
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            children: [
              Image.network(
                image[0].url!,
              ),
              Image.network(
                image[1].url!,
              ),
            ],
          ),
          const SizedBox(
            height: 1,
          ),
          Image.network(
            image[2].url!,
          )
        ],
      );
    }
//if there are more than 3 photos
    return GridView.builder(
      shrinkWrap: true, //allows widget to adjust it's size with content
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          // childAspectRatio: 1,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2),

      itemCount: image.length > 3 ? 4 : image.length,
      //if the image lenth is more than 3 the value is set to 4 , but if less then the vakue is set to image.length
      itemBuilder: (context, index) {
        if (index == 3 && remainimages > 0) {
          //this condition makes the +X for image display
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullImageScreen(
                      images: image,
                      detail: detail,
                      user: user,
                    ),
                  ));
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  image[index].url!,
                  fit: BoxFit.cover,
                ),
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Text(
                      '+$remainimages',
                      style: const TextStyle(color: Colors.grey, fontSize: 25),
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return Image.network(
            image[index].url!,
            fit: BoxFit.cover,
          );
        }
      },
    );
    // );
  }
}
