class UserModel {
  int? id;
  String? name;
  String? email;
  String? password;

  UserModel({this.email, this.id, this.name, this.password});

  UserModel.fromJson(Map<String, dynamic> map) {
    id = map['Id'];
    name = map['Name'];
    email = map['Email'];
    password = map['Password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Name'] = name;
    data['Email'] = email;
    data['Password'] = password;
    return data;
  }
}
