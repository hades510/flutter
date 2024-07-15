// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/widgets.dart';

// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:socialapp/dataloader.dart';
// import 'package:socialapp/datastorage.dart';
// import 'package:socialapp/models/user.dart';
// import 'package:socialapp/models/user_detail.dart';

// class Profile extends StatelessWidget {
//   final User user;
//   final UserDetail userDetail;
//   Profile({super.key, required this.user, required this.userDetail});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Title'),
//       ),
//       body: FutureBuilder(
//         future: _fetchUserData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text('${snapshot.error}'),
//             );
//           } else {
//             return _buildprofile(snapshot.data!);
//           }
//         },
//       ),
//     );
//   }

//   Future<UserDetail> _fetchUserData() async {
//     Dataloader dataLoader = Dataloader();

//     return await dataLoader.loaddetail(user.id!);
//   }

//   Widget _buildprofile(UserDetail userDetail) {
//     return Stack(
//       // fit: StackFit.expand,
//       children: [
//         SizedBox(
//             height: 180,
//             width: double.infinity,
//             child: Image.asset(
//               'assets/images/test.jpg',
//               fit: BoxFit.fitWidth,
//             )),
//         Align(
//           alignment: const Alignment(.95, -.58),
//           child: CircleAvatar(
//               backgroundColor: Colors.blueGrey,
//               child:
//                   IconButton(onPressed: () {}, icon: Icon(Icons.add_a_photo))),
//         ),
//         const Align(
//           alignment: Alignment(-0.95, -.68),
//           child: CircleAvatar(
//             radius: 70,
//             backgroundImage: AssetImage('assets/images/test.jpg'),
//           ),
//         ),
//         Align(
//           alignment: Alignment(-.4, -.42),
//           child: CircleAvatar(
//             radius: 20,
//             backgroundColor: Colors.blueGrey,
//             child: IconButton(
//               onPressed: () {},
//               icon: Icon(Icons.add_a_photo),
//             ),
//           ),
//         ),
//         Positioned(
//           top: 220,
//           bottom: 0,
//           right: 0,
//           left: 20,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "${user.name}",
//                 style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//                 overflow: TextOverflow.visible,
//               ),
//               Text("${user.email}")
//             ],
//           ),
//         )

//         // Positioned(
//         //   top: 0,
//         //   bottom: 0,
//         //   right: 0,
//         //   left: 0,
//         //   child: Column(
//         //     children: [
//         //       Container(
//         //           color: Colors.black,
//         //           width: double.infinity,
//         //           height: 200,
//         //           child: Image.asset(
//         //             'assets/images/test.jpg',
//         //             fit: BoxFit.fill,
//         //           )
//         //           // child: Image.network(userDetail.coverImage!.imagepath!),
//         //           ),
//         //       Image.network(userDetail.profileImage!.imagePath!),
//         //       CircleAvatar(backgroundImage: AssetImage('assets/images/test.jpg')
//         //           // NetworkImage(userDetail.profileImage!.imagePath!),
//         //           ),

//         //       Text('Name: ${user.name}'),
//         //       Text("Name: ${userDetail.basicInfo!.name}"),
//         //       for (var lang in userDetail.languages!) Text(' - ${lang.title}'),
//         //       for (WorkExperience work in userDetail.workExperience!)
//         //         Text(' ${work.jobTitle} \n -${work.organizationName}')

//         //       //this how you display
//         //       // Column(
//         //       //   crossAxisAlignment: CrossAxisAlignment.start,
//         //       //   children: userDetail.workExperience!
//         //       //       .map((experience) => Text(
//         //       //           '- ${experience.organizationName}, ${experience.jobTitle}'))
//         //       //       .toList(),
//         //       // ),
//         //     ],
//         //   ),
//         // ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:socialapp/dataloader.dart';
import 'package:socialapp/models/user.dart';
import 'package:socialapp/models/user_detail.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  final User user;
  final UserDetail userDetail;

  const Profile({super.key, required this.user, required this.userDetail});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: FutureBuilder(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          } else {
            return _buildProfile(snapshot.data!);
          }
        },
      ),
    );
  }

  Future<UserDetail> _fetchUserData() async {
    Dataloader dataLoader = Dataloader();
    return await dataLoader.loaddetail(widget.user.id!);
  }

  Widget _buildProfile(UserDetail userDetail) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip
                .none, //enables the overlapping effect to the profilepicture
            children: [
              SizedBox(
                height: 200,
                width: double.infinity,
                child: Image.network(
                  userDetail.coverImage!.imagepath!,
                  fit: BoxFit.cover,
                ),
                // Image.asset('assets/images/test.jpg', fit: BoxFit.cover),
              ),
              Positioned(
                left: 16,
                bottom: -50,
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage:
                      NetworkImage(userDetail.profileImage!.imagePath!),
                  // AssetImage('assets/images/test.jpg'),
                ),
              ),
              Positioned(
                right: 230,
                top: 190,
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.camera_alt_outlined,
                        color: Colors.white),
                  ),
                ),
              ),
              Positioned(
                right: 16,
                top: 150,
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.camera_alt_outlined,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userDetail.basicInfo?.name ?? '',
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  userDetail.basicInfo?.summary ?? '',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                const SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Basic Information'),
                      _buildInfoRow(
                          'Gender', userDetail.basicInfo?.gender ?? ''),
                      _buildInfoRow(
                          'Date of Birth', userDetail.basicInfo?.dob ?? ''),
                      _buildInfoRow('Marital Status',
                          userDetail.basicInfo?.maritalStatus ?? ''),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildcontainer(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle("Work Experience"),
                      ...userDetail
                          .workExperience! //here spread operator is used to insert all the elements to another collection
                          .map((work) => _buildWorkExperience(work))
                          .toList(),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildcontainer(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Skills'),
                      _buildChips(userDetail.skills!
                          .map((skill) => skill.title!)
                          .toList()),
                      const SizedBox(height: 16),
                      _buildSectionTitle('Hobbies'),
                      _buildChips(userDetail.hobbies!
                          .map((hobby) => hobby.title!)
                          .toList()),
                      const SizedBox(height: 16),
                      _buildSectionTitle('Languages'),
                      _buildChips(userDetail.languages!
                          .map((lang) => lang.title!)
                          .toList()),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildcontainer(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Education'),
                      ...userDetail.education!
                          .map((education) => _buildEducation(education))
                          .toList(),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildcontainer(Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Accomplishments'),
                    ...userDetail.accomplishments!
                        .map((acc) => _buildAccomplishment(acc))
                        .toList(),
                  ],
                )),
                const SizedBox(height: 16),
                _buildcontainer(Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Contact Information'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mobile No.',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                        Text(
                          userDetail.contactInfo?.mobileNo ?? '',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700]),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    // _buildInfoRow(
                    //     'Mobile No', userDetail.contactInfo?.mobileNo ?? ''),
                    _buildSectionTitle('Social Media'),
                    ...userDetail.contactInfo!.socialMedia!
                        .map((social) => _buildSocialMedia(social))
                        .toList(),
                  ],
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildcontainer(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(10)),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkExperience(WorkExperience work) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            work.jobTitle!,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            '${work.organizationName} (${work.startDate} - ${work.endDate})',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          Text(
            work.summary!,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ],
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

  Widget _buildEducation(Education education) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            education.level!,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            '${education.organizationName} (${education.startDate} - ${education.endDate})',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          Text(
            education.summary!,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildAccomplishment(Accomplishments accomplishment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            accomplishment.title!,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            accomplishment.description!,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMedia(SocialMedia social) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          children: [
            // _buildSectionTitle("Social Media"),
            GestureDetector(
              onTap: () async {
                final Uri url = Uri.parse(social.url!);
                print(url);

                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
              child: Text(
                social.title!,
                style: const TextStyle(color: Colors.blue, fontSize: 16),
              ),
            )
          ],
        )
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        // Text(
        //   social.title!,
        //   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        // ),
        //     GestureDetector(
        //       onTap: () async {
        //         final Uri url =
        //             Uri.parse(social.url!); //converted the string into uri form
        //         if (await canLaunchUrl(url)) {
        //           //checks whether the url can be handled of not!
        //           //this can
        //           await launchUrl(url); //launches the url in browwser
        //         } else {
        //           throw "Could not launch the $url";
        //         }
        //       },
        //       child: Text(
        //         social.title!,
        //         style: const TextStyle(fontSize: 16, color: Colors.blue),
        //       ),
        //     ),
        //   ],
        // ),
        );
  }
}
