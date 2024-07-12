import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/dataloader.dart';
import 'package:socialapp/datastorage.dart';
import 'package:socialapp/models/user.dart';
import 'package:socialapp/models/user_detail.dart';

class Auth {
  Dataloader dataloader = Dataloader();
  Future<Map<String, dynamic>?> login(String email, String password) async {
    List<User> users = await dataloader.loaduser();
    // List<UserDetail> userdetails = await dataloader.loaddetail();
    User? authenUser;
    UserDetail? detail;

    for (User user in users) {
      if (user.email == email && user.password == password) {
        authenUser = user;
        detail = await dataloader.loaddetail(user.id!);
        break;
      }
    }
    if (authenUser != null && detail != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('Id', authenUser.id!);

      return {'user': authenUser, 'userdetail': detail};
    }
    return null;
  }
}
