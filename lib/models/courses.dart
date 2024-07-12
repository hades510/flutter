
import 'package:socialapp/models/instructor.dart';

class Courses {
  int? id;
  String? title;
  String? subtitle;
  String? description;
  String? overview;
  List<Instructor>? instructor;
  String? image;
  double? price;
  List<String>? skills;
  bool? isTopCourse;
  bool? isRecentlyViewedCourse;
  List<Syllabus>? syllabus;
  List<FAQ>? fAQ;

  Courses(
      {this.id,
      this.title,
      this.subtitle,
      this.description,
      this.overview,
      this.instructor,
      this.image,
      this.price,
      this.skills,
      this.isTopCourse,
      this.isRecentlyViewedCourse,
      this.syllabus,
      this.fAQ});

  Courses.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    title = json['Title'];
    subtitle = json['Subtitle'];
    description = json['Description'];
    overview = json['Overview'];
    if (json['Instructor'] != null) {
      instructor = <Instructor>[];
      json['Instructor'].forEach((v) {
        instructor!.add(new Instructor.fromJson(v));
      });
    }
    image = json['Image'];
    price = json['Price'];
    skills = json['Skills'].cast<String>();
    isTopCourse = json['Is_top_course'];
    isRecentlyViewedCourse = json['Is_recently_viewed_course'];
    if (json['Syllabus'] != null) {
      syllabus = <Syllabus>[];
      json['Syllabus'].forEach((v) {
        syllabus!.add(new Syllabus.fromJson(v));
      });
    }
    if (json['FAQ'] != null) {
      fAQ = <FAQ>[];
      json['FAQ'].forEach((v) {
        fAQ!.add(new FAQ.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Title'] = title;
    data['Subtitle'] = subtitle;
    data['Description'] = description;
    data['Overview'] = overview;
    if (instructor != null) {
      data['Instructor'] = instructor!.map((v) => v.toJson()).toList();
    }
    data['Image'] = image;
    data['Price'] = price;
    data['Skills'] = skills;
    data['Is_top_course'] = isTopCourse;
    data['Is_recently_viewed_course'] = isRecentlyViewedCourse;
    if (syllabus != null) {
      data['Syllabus'] = syllabus!.map((v) => v.toJson()).toList();
    }
    if (fAQ != null) {
      data['FAQ'] = fAQ!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class Instructor {
//   int? instructorId;

//   Instructor({this.instructorId});

//   Instructor.fromJson(Map<String, dynamic> json) {
//     instructorId = json['instructor_id'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['instructor_id'] = instructorId;
//     return data;
//   }
// }

class Syllabus {
  int? id;
  String? title;
  String? summary;
  int? totalContent;
  double? hoursToCompleted;

  Syllabus(
      {this.id,
      this.title,
      this.summary,
      this.totalContent,
      this.hoursToCompleted});

  Syllabus.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    title = json['Title'];
    summary = json['Summary'];
    totalContent = json['Total content'];
    hoursToCompleted = json['Hours to completed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Title'] = title;
    data['Summary'] = summary;
    data['Total content'] = totalContent;
    data['Hours to completed'] = hoursToCompleted;
    return data;
  }
}

class FAQ {
  int? id;
  String? title;
  String? subtitle;
  String? description;

  FAQ({this.id, this.title, this.subtitle, this.description});

  FAQ.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    title = json['Title'];
    subtitle = json['Subtitle'];
    description = json['Description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Title'] = title;
    data['Subtitle'] = subtitle;
    data['Description'] = description;
    return data;
  }
}
