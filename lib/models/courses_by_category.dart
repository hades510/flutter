class CoursesCategory {
  int? courseById;
  int? courseId;
  int? categoriesId;
  String? createdAt;

  CoursesCategory(
      {this.courseById, this.courseId, this.categoriesId, this.createdAt});

  CoursesCategory.fromJson(Map<String, dynamic> json) {
    courseById = json['Course_by_id'];
    courseId = json['Course_id'];
    categoriesId = json['Categories_id'];
    createdAt = json['Created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Course_by_id'] = courseById;
    data['Course_id'] = courseId;
    data['Categories_id'] = categoriesId;
    data['Created_at'] = createdAt;
    return data;
  }
}
