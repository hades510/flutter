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
    List<CCategory> coursescategory = await dataloader.loadcoursecategory();
    return {
      'coursescategory': coursescategory,
    };
  }
}

class AvailableScreen extends StatefulWidget {
  List<CCategory> coursecategory;
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
          return _builderccategory(widget.coursecategory[index]);
        },
      ),
    );
  }

  Widget _builderccategory(CCategory model) {
    return ListTile(
      onTap: () async {
        Courses? detail = await dataloader.loadcore(model.id!);
        Instructor? teach =await dataloader.loadins(model.id!);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetailScreen(
                courseCategory: model,
                detail: detail,
                teach: teach,
              ),
            ));
      },
      leading: Text('${model.id!}'),
      title: Text('${model.title}'),
    );
  }
}
