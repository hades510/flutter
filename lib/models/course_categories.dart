class CoursesCategory {
  int? id;
  String? title;

  CoursesCategory({this.id, this.title});

  CoursesCategory.fromJson(Map<String, dynamic> map) {
    id = map['Id'];
    title = map['Title'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Title'] = title;
    return data;
  }
}
