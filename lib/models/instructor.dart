class Instructor {
  int? id;
  String? name;
  String? image;
  List? field;
  double? workExperience;
  String? summary;

  Instructor(
      {this.id,
      this.name,
      this.image,
      this.field,
      this.workExperience,
      this.summary});

  Instructor.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    image = json['Image'];
    field = json['Field'];
    workExperience = json['Work_experience'];
    summary = json['Summary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Name'] = name;
    data['Image'] = image;
    data['Field'] = field;
    data['Work_experience'] = workExperience;
    data['Summary'] = summary;
    return data;
  }
}
