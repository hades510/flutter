// // import 'package:flutter/material.dart';
// // import 'package:socialapp/models/courses.dart';
// // // Import the detail! classes

// // class CourseDetailScreen extends StatelessWidget {
// //   final Courses course;

// //   CourseDetailScreen({required this.course});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //           title: Text(course.title!),
// //           ),
// //       body: SingleChildScrollView(
// //         child: Padding(
// //           padding: const EdgeInsets.all(16.0),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: <Widget>[
// //               Image.asset(course.image!),
// //               SizedBox(height: 16.0),
// //               Text(
// //                 course.title!,
// //                 style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
// //               ),
// //               SizedBox(height: 8.0),
// //               Text(
// //                 course.subtitle!,
// //                 style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
// //               ),
// //               SizedBox(height: 8.0),
// //               Text(
// //                 course.description!,
// //                 style: TextStyle(fontSize: 16.0),
// //               ),
// //               SizedBox(height: 16.0),
// //               Text(
// //                 'Overview',
// //                 style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
// //               ),
// //               SizedBox(height: 8.0),
// //               Text(course.overview!),
// //               SizedBox(height: 16.0),
// //               Text(
// //                 'Syllabus',
// //                 style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
// //               ),
// //               ...course.syllabus!.map((syllabus) {
// //                 return ListTile(
// //                   title: Text(syllabus.title!),
// //                   subtitle: Text(syllabus.summary!),
// //                   trailing: Text('${syllabus.hoursToCompleted} hrs'),
// //                 );
// //               }).toList(),
// //               SizedBox(height: 16.0),
// //               Text(
// //                 'FAQ',
// //                 style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
// //               ),
// //               ...course.fAQ!.map((faq) {
// //                 return ListTile(
// //                   title: Text(faq.title!),
// //                   subtitle: Text(faq.description!),
// //                 );
// //               }).toList(),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:socialapp/dataloader.dart';
// // import 'package:socialapp/models/course_categories.dart';
// import 'package:socialapp/models/courses.dart';
// import 'package:socialapp/models/instructor.dart';

// import 'models/course_categories.dart';

// class CourseDetailScreen extends StatefulWidget {
//   const CourseDetailScreen({
//     super.key,
//   });

//   @override
//   State<CourseDetailScreen> createState() => _CourseDetailScreenState();
// }

// class _CourseDetailScreenState extends State<CourseDetailScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Availabe Courses'),
//       ),
//       body:

//        FutureBuilder(
//         future: _fetchcoursedata(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (snapshot.hasError) {
//             return Text('${snapshot.error}');
//           } else {
//             return Detailscreen(
//               coursedetail: snapshot.data!['coursedetail'],
//               teacher: snapshot.data!['instructor'],
//               category: snapshot.data!['category'],
//             );
//           }
//         },
//       ),
//     );
//   }

//   Future _fetchcoursedata() async {
//     Dataloader dataloader = Dataloader();
//     List<Courses> coursedetail = await dataloader.loadcourses();
//     List<Instructor> instructor = await dataloader.loadinstructor();
//     List<CCategory> category = await dataloader.loadcoursecategory();
//     return {
//       'coursedetail': coursedetail,
//       'instructor': instructor,
//       'category': category
//     };
//   }
// }

// class Detailscreen extends StatefulWidget {
//   List<Courses> coursedetail;
//   List<Instructor> teacher;
//   List<CCategory> category;
//   Detailscreen(
//       {super.key,
//       required this.coursedetail,
//       required this.teacher,
//       required this.category});

//   @override
//   State<Detailscreen> createState() => _DetailscreenState();
// }

// class _DetailscreenState extends State<Detailscreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView.builder(
//         itemCount: widget.coursedetail.length,
//         itemBuilder: (context, index) {
//           return _builder(widget.coursedetail[index]);
//         },
//       ),
//     );
//   }

//   Instructor getid(int id) {
//     return widget.teacher.firstWhere((element) => element.id == id);
//   }

//   CCategory getcourseid(int id) {
//     return widget.category.firstWhere((element) => element.id == id);
//   }

//   Widget _builder(Courses detail!) {
//     Instructor teach = getid(detail!.id!);
//     CCategory category = getcourseid(detail!.id!);
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Container(
//         decoration: BoxDecoration(
//             border: Border.all(), borderRadius: BorderRadius.circular(25)),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Card(
//                 child: Image.network(
//                   detail!.image!,
//                   cacheHeight: 400,
//                   width: 200,
//                 ),
//               ),
//               const SizedBox(
//                 height: 16.0,
//               ),
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   border: Border.all(),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       detail!.title!,
//                       style: const TextStyle(
//                           fontSize: 24.0,
//                           fontWeight: FontWeight.bold,
//                           decoration: TextDecoration.underline,
//                           decorationThickness: 2),
//                     ),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     Text(
//                       detail!.subtitle!,
//                       style: const TextStyle(
//                           fontSize: 18, fontWeight: FontWeight.w600),
//                     ),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     Text(
//                       detail!.description!,
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                     const SizedBox(
//                       height: 16,
//                     ),
//                     const Text(
//                       'OverView',
//                       style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           decoration: TextDecoration.underline,
//                           decorationThickness: 2),
//                     ),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     Text(detail!.overview!),
//                     const SizedBox(
//                       height: 16,
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 height: 16,
//               ),
//               const Text(
//                 'Syllabus',
//                 style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     decoration: TextDecoration.underline,
//                     decorationThickness: 2),
//               ),
//               ...detail!.syllabus!.map((e) {
//                 return ListTile(
//                   title: Text(e.title!),
//                   subtitle: Text(e.summary!),
//                   trailing: Text('${e.hoursToCompleted} hrs'),
//                 );
//               }),
//               const SizedBox(
//                 height: 16,
//               ),
//               const Text(
//                 'FAQ',
//                 style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     decoration: TextDecoration.underline,
//                     decorationThickness: 2),
//               ),
//               ...detail!.fAQ!.map((e) {
//                 return ListTile(
//                   title: Text(e.title!),
//                   subtitle: Text(e.description!),
//                 );
//               }),
//               const SizedBox(
//                 height: 20,
//               ),
//               const Text(
//                 'Instructor',
//                 style: TextStyle(fontSize: 25),
//               ),
//               Text(teach.name!)
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:socialapp/models/course_categories.dart';
// import 'package:socialapp/models/instructor.dart';

// import '../models/courses.dart';

// class CourseDetailScreen extends StatelessWidget {
//   final CoursesCategory courseCategory;
//   final Courses? detail;
//   final Instructor? teach;

//   const CourseDetailScreen(
//       {super.key,
//       required this.courseCategory,
//       required this.detail,
//       required this.teach});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(courseCategory.title ?? 'Course Details'),
//         ),
//         body:
//         SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Container(
//               decoration: BoxDecoration(
//                   border: Border.all(),
//                   borderRadius: BorderRadius.circular(25)),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Card(
//                       child: Image.network(
//                         detail!.image!,
//                         cacheHeight: 400,
//                         width: 200,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 16.0,
//                     ),
//                     Container(
//                       padding: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         border: Border.all(),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             detail!.title!,
//                             style: const TextStyle(
//                                 fontSize: 24.0,
//                                 fontWeight: FontWeight.bold,
//                                 decoration: TextDecoration.underline,
//                                 decorationThickness: 2),
//                           ),
//                           const SizedBox(
//                             height: 8,
//                           ),
//                           Text(
//                             detail!.subtitle!,
//                             style: const TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.w600),
//                           ),
//                           const SizedBox(
//                             height: 8,
//                           ),
//                           Text(
//                             detail!.description!,
//                             style: const TextStyle(fontSize: 16),
//                           ),
//                           const SizedBox(
//                             height: 16,
//                           ),
//                           const Text(
//                             'OverView',
//                             style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                                 decoration: TextDecoration.underline,
//                                 decorationThickness: 2),
//                           ),
//                           const SizedBox(
//                             height: 8,
//                           ),
//                           Text(detail!.overview!),
//                           const SizedBox(
//                             height: 16,
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 16,
//                     ),
//                     const Text(
//                       'Syllabus',
//                       style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           decoration: TextDecoration.underline,
//                           decorationThickness: 2),
//                     ),
//                     ...detail!.syllabus!.map((e) {
//                       return ListTile(
//                         title: Text(e.title!),
//                         subtitle: Text(e.summary!),
//                         trailing: Text('${e.hoursToCompleted} hrs'),
//                       );
//                     }),
//                     const SizedBox(
//                       height: 16,
//                     ),
//                     const Text(
//                       'FAQ',
//                       style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           decoration: TextDecoration.underline,
//                           decorationThickness: 2),
//                     ),
//                     ...detail!.fAQ!.map((e) {
//                       return ListTile(
//                         title: Text(e.title!),
//                         subtitle: Text(e.description!),
//                       );
//                     }),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     const Text(
//                       'Instructor',
//                       style: TextStyle(fontSize: 25),
//                     ),
//                     ListTile(
//                       leading: CircleAvatar(
//                         backgroundImage: NetworkImage(teach!.image!),
//                       ),
//                       title: Text(teach!.name!),
//                       subtitle: Text('${teach!.field}'),
//                       trailing: Text('${teach!.workExperience} Years'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         );
//   }
// }
import 'package:flutter/material.dart';
import 'package:socialapp/models/courses.dart';
import 'package:socialapp/dataloader.dart';
import 'package:socialapp/models/instructor.dart';

class CourseDetailPage extends StatelessWidget {
  final int courseId;
  final int instructorid;

  const CourseDetailPage(
      {super.key, required this.courseId, required this.instructorid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Details'),
      ),
      body: FutureBuilder(
        future: _fetchCourseDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: RichText(
                    text: const TextSpan(
                        style: TextStyle(fontSize: 30, color: Colors.black),
                        children: [
                  TextSpan(text: 'Courses '),
                  TextSpan(text: 'Comming Soon', style: TextStyle(fontSize: 10))
                ])));
            // return Text('${snapshot.error}');// to show error
          } else {
            final detail = snapshot.data;
            // final teach = snapshot.data as Instructor;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(25)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          child: Image.network(
                            detail.image!,
                            cacheHeight: 400,
                            width: 200,
                          ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                detail!.title!,
                                style: const TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 2),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                detail!.subtitle!,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                detail!.description!,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              const Text(
                                'OverView',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 2),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(detail!.overview!),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          'Syllabus',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationThickness: 2),
                        ),
                        ...detail!.syllabus!.map((e) {
                          return ListTile(
                            title: Text(e.title!),
                            subtitle: Text(e.summary!),
                            trailing: Text('${e.hoursToCompleted} hrs'),
                          );
                        }),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          'FAQ',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationThickness: 2),
                        ),
                        ...detail!.fAQ!.map((e) {
                          return ListTile(
                            title: Text(e.title!),
                            subtitle: Text(e.description!),
                          );
                        }),
                        const SizedBox(
                          height: 20,
                        ),
                        // const Text(
                        //   'Instructor',
                        //   style: TextStyle(fontSize: 25),
                        // ),
                        // ListTile(
                        //   leading: CircleAvatar(
                        //     backgroundImage: NetworkImage(teach!.image!),
                        //   ),
                        //   title: Text(teach!.name!),
                        //   subtitle: Text('${teach.field}'),
                        //   trailing: Text('${teach.workExperience} Years'),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future _fetchCourseDetails() async {
    Dataloader dataloader = Dataloader();
    List<Courses> courses = await dataloader.getCourse();
    List<Instructor> instructor = await dataloader.getInstructor();
    return courses.firstWhere((course) => course.id == courseId);
  }
}

// class CoursedetailScreen extends StatefulWidget {
//   List<Instructor> instructor;
//   List<Courses> courses;
//   CoursedetailScreen(
//       {super.key, required this.courses, required this.instructor});

//   @override
//   State<CoursedetailScreen> createState() => _CoursedetailScreenState();
// }

// class _CoursedetailScreenState extends State<CoursedetailScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _builddetailCourse(widget.courses as Courses),
//     );
//   }

//   Widget _builddetailCourse(Courses model) {
//     return Container();
//   }
// }
