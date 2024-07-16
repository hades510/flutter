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
        instructor!.add(Instructor.fromJson(v));
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
        syllabus!.add(Syllabus.fromJson(v));
      });
    }
    if (json['FAQ'] != null) {
      fAQ = <FAQ>[];
      json['FAQ'].forEach((v) {
        fAQ!.add(FAQ.fromJson(v));
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
    totalContent = json['Total_content'];
    hoursToCompleted = json['Hours_to_completed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Title'] = title;
    data['Summary'] = summary;
    data['Total_content'] = totalContent;
    data['Hours_to_completed'] = hoursToCompleted;
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
