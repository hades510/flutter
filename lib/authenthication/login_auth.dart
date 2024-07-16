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

    /// This part of the code is a loop that iterates over a list of `User` objects stored in the
    /// `users` list. For each `User` object in the list, it checks if the `email` and `password`
    /// provided match the current user's email and password. If a match is found, it assigns the
    /// current `User` object to the `authenUser` variable, which means this user is authenticated.
    for (User user in users) {//for in loop
      if (user.email == email && user.password == password) {
        authenUser = user;//here the user has the scope for this for loop only so,all the data of user is send to authenUser shose scope is greater.
       
        detail = await dataloader.loaddetail(user.id!);//loades the user's id which was stored with the clicked email and password
        break;
      }
    }
   /// This part of the code is checking if both `authenUser` and `detail` are not null. If they are
   /// both not null, it means that a user has been successfully authenticated and their details have
   /// been loaded.
    if (authenUser != null && detail != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('Id', authenUser.id!);//User id is stored in 'Id key for later use

      return {'user': authenUser, 'userdetail': detail};//after setting the details of authenUser and detail is stored inside the following keys
    }
    return null;
  }
}
