class CCategory {
  int? id;
  String? title;

  CCategory({this.id, this.title});

  CCategory.fromJson(Map<String, dynamic> map) {
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
