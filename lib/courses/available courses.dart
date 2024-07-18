import 'package:flutter/material.dart';
import 'package:socialapp/dataloader.dart';
import 'package:socialapp/models/course_categories.dart';
import 'package:socialapp/models/courses.dart';
import 'package:socialapp/models/instructor.dart';
import 'package:socialapp/courses/view_courses.dart';

class AvailableCourses extends StatefulWidget {
  const AvailableCourses({super.key});

  @override
  State<AvailableCourses> createState() => _AvailableCoursesState();
}

class _AvailableCoursesState extends State<AvailableCourses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Courses'),
      ),
      body: FutureBuilder(
        future: _fetchdata(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            return AvailableScreen(
                coursecategory: snapshot.data['coursescategory']);
          }
        },
      ),
    );
  }

  Future _fetchdata() async {
    Dataloader dataloader = Dataloader();
    List<CoursesCategory> coursescategory =
        await dataloader.getcoursecategory();
    List<Instructor> instructor = await dataloader.getInstructor();
    return {
      'coursescategory': coursescategory,
      'instructor': instructor,
    };
  }
}

class AvailableScreen extends StatefulWidget {
  List<CoursesCategory> coursecategory;
  AvailableScreen({super.key, required this.coursecategory});

  @override
  State<AvailableScreen> createState() => _AvailableScreenState();
}

class _AvailableScreenState extends State<AvailableScreen> {
  Dataloader dataloader = Dataloader();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.coursecategory.length,
        itemBuilder: (BuildContext context, int index) {
          return _builderccategory(widget.coursecategory[index], index);
        },
      ),
    );
  }

  Widget _builderccategory(CoursesCategory model, int index) {
    var images = [
      'https://c8.alamy.com/comp/2D72K34/program-code-vector-illustration-page-filled-outline-icon-2D72K34.jpg',
      'https://c8.alamy.com/comp/2AAJMBB/data-science-outline-icon-thin-line-style-from-big-data-icons-collection-pixel-perfect-simple-element-data-science-icon-for-web-design-apps-2AAJMBB.jpg',
      'https://static.vecteezy.com/system/resources/thumbnails/002/076/605/small/online-learning-icon-set-for-website-document-poster-design-printing-application-online-course-concept-icon-outline-style-vector.jpg',
      'https://img.freepik.com/free-vector/digital-learning-abstract-concept-vector-illustration-digital-distance-education-elearning-flipped-smart-classroom-training-courses-online-teaching-video-call-home-office-abstract-metaphor_335657-5860.jpg?size=338&ext=jpg&ga=GA1.1.1413502914.1720310400&semt=ais_user',
      'https://c8.alamy.com/comp/2D72K34/program-code-vector-illustration-page-filled-outline-icon-2D72K34.jpg',
      'https://c8.alamy.com/comp/2AAJMBB/data-science-outline-icon-thin-line-style-from-big-data-icons-collection-pixel-perfect-simple-element-data-science-icon-for-web-design-apps-2AAJMBB.jpg',
      'https://static.vecteezy.com/system/resources/thumbnails/002/076/605/small/online-learning-icon-set-for-website-document-poster-design-printing-application-online-course-concept-icon-outline-style-vector.jpg',
      'https://img.freepik.com/free-vector/digital-learning-abstract-concept-vector-illustration-digital-distance-education-elearning-flipped-smart-classroom-training-courses-online-teaching-video-call-home-office-abstract-metaphor_335657-5860.jpg?size=338&ext=jpg&ga=GA1.1.1413502914.1720310400&semt=ais_user',
      'https://c8.alamy.com/comp/2D72K34/program-code-vector-illustration-page-filled-outline-icon-2D72K34.jpg',
      'https://c8.alamy.com/comp/2AAJMBB/data-science-outline-icon-thin-line-style-from-big-data-icons-collection-pixel-perfect-simple-element-data-science-icon-for-web-design-apps-2AAJMBB.jpg',
      'https://static.vecteezy.com/system/resources/thumbnails/002/076/605/small/online-learning-icon-set-for-website-document-poster-design-printing-application-online-course-concept-icon-outline-style-vector.jpg',
      'https://img.freepik.com/free-vector/digital-learning-abstract-concept-vector-illustration-digital-distance-education-elearning-flipped-smart-classroom-training-courses-online-teaching-video-call-home-office-abstract-metaphor_335657-5860.jpg?size=338&ext=jpg&ga=GA1.1.1413502914.1720310400&semt=ais_user',
      'https://c8.alamy.com/comp/2D72K34/program-code-vector-illustration-page-filled-outline-icon-2D72K34.jpg',
      'https://c8.alamy.com/comp/2AAJMBB/data-science-outline-icon-thin-line-style-from-big-data-icons-collection-pixel-perfect-simple-element-data-science-icon-for-web-design-apps-2AAJMBB.jpg',
      'https://static.vecteezy.com/system/resources/thumbnails/002/076/605/small/online-learning-icon-set-for-website-document-poster-design-printing-application-online-course-concept-icon-outline-style-vector.jpg',
      'https://img.freepik.com/free-vector/digital-learning-abstract-concept-vector-illustration-digital-distance-education-elearning-flipped-smart-classroom-training-courses-online-teaching-video-call-home-office-abstract-metaphor_335657-5860.jpg?size=338&ext=jpg&ga=GA1.1.1413502914.1720310400&semt=ais_user',
      'https://c8.alamy.com/comp/2D72K34/program-code-vector-illustration-page-filled-outline-icon-2D72K34.jpg',
      'https://c8.alamy.com/comp/2AAJMBB/data-science-outline-icon-thin-line-style-from-big-data-icons-collection-pixel-perfect-simple-element-data-science-icon-for-web-design-apps-2AAJMBB.jpg',
      'https://static.vecteezy.com/system/resources/thumbnails/002/076/605/small/online-learning-icon-set-for-website-document-poster-design-printing-application-online-course-concept-icon-outline-style-vector.jpg',
      'https://img.freepik.com/free-vector/digital-learning-abstract-concept-vector-illustration-digital-distance-education-elearning-flipped-smart-classroom-training-courses-online-teaching-video-call-home-office-abstract-metaphor_335657-5860.jpg?size=338&ext=jpg&ga=GA1.1.1413502914.1720310400&semt=ais_user',
    ];
    return ListTile(
      onTap: () {
        
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetailPage(
                courseId: model.id!,
                instructorid: model.id!,
              ),
            ));
      },
      leading: CircleAvatar(backgroundImage: NetworkImage(images[index])),
      // Image.asset('assets/images/courses.png'),
      //     Text(
      //   '${model.id!}',
      //   style: const TextStyle(fontSize: 20),
      // ),
      title: Text('${model.title}'),
    );
  }
}
// onTap: () async {
      //   Courses? detail = await dataloader.loadcore(model.id!);
      //   Instructor? teach = await dataloader.loadins(model.id!);
      //   Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => CourseDetailScreen(
      //           courseCategory: model,
      //           detail: detail,
      //           teach: teach,
      //         ),
      //       ));
      // },