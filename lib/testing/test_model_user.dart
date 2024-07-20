class User {
  int? id;
  String? name;
  String? email;
  String? password;
  User({this.id, this.email, this.name, this.password});

  User.fromJson(Map<String, dynamic> map) {
    id = map['Id'];
    email = map['Email'];
    password = map['Password'];
    name = map['Name'];
  }

  // get snapshot => null;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Name'] = name;
    data['Password'] = password;
    data['Email'] = email;

    return data;
  }
}
