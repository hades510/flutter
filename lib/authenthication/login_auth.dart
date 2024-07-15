import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/dataloader.dart';
import 'package:socialapp/datastorage.dart';
import 'package:socialapp/models/user.dart';
import 'package:socialapp/models/user_detail.dart';

class Auth {
  Dataloader dataloader = Dataloader();// for loading the parsed data
  Future login(String email, String password) async {
    List<User> users = await dataloader.loaduser();//loaded the parsed user data
    // List<UserDetail> userdetails = await dataloader.loaddetail();
    User? authenUser;//user class object
    UserDetail? detail;//userdetail class object

    for (User user in users) {//for in loop
      if (user.email == email && user.password == password) {
        authenUser = user;//here the user has the scope for this for loop only so,all the data of user is send to authenUser shose scope is greater.
        detail = await dataloader.loaddetail(user.id!);//loades the user's id which was stored with the clicked email and password
        break;
      }
    }
    if (authenUser != null && detail != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('Id', authenUser.id!);//User id is stored in 'Id key for later use

      return {'user': authenUser, 'userdetail': detail};//after setting the details of authenUser and detail is stored inside the following keys
    }
    return null;
  }
}
