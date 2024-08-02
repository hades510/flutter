import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:socialapp/authenthication/dddart.dart';
import 'package:socialapp/authenthication/login_auth.dart';
import 'package:socialapp/dataloader.dart';
// import 'package:socialapp/datastorage.dart';
// import 'package:socialapp/feeds/newsfeed.dart';
import 'package:socialapp/forgotpassword.dart';
import 'package:socialapp/home.dart';
// import 'package:socialapp/models/user.dart';
// import 'package:socialapp/models/user_detail.dart';
import 'package:socialapp/signup.dart';
// import 'package:socialapp/view_profile.dart';

class LoginPage extends StatefulWidget {
  // final Function()? ontap; //this toggles between sign up and login
  const LoginPage({
    super.key,
    //  required this.ontap
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController password = TextEditingController();
  final TextEditingController email = TextEditingController();
  bool obscure = false;
  bool isChecked = false;
  late Auth auth;

  // Future<User?> auth(String email, String password) async {
  //   DataStorage provider = DataStorage();
  //   Dataloader dataloader = Dataloader();
  //   List<User> userlist = await dataloader.loaduser();
  //   for (var user in userlist) {
  //     if (user.email == email && user.password == password) {
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       await prefs.setInt('Id', user.id!);
  //       return user;
  //     }
  //   }
  //   return null;
  // }
  @override
  void initState() {
    super.initState();
    auth = Auth(Dataloader()); //initialized to update the logged usr
  }

  void _login() async {
    bool isSuccess = await auth.login(email.text, password.text);

    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 1),
          content: Text("Logged In"),
        ),
      );
      // Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const Home(),
          ),
          (route) => false);
      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => const Home()
      //         // ViewProfile(
      //         //   auth: auth,
      //         // ),
      //         ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email and password')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // wraps the region below the app bar
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Form(
            key: formKey,
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height,
                    maxWidth: MediaQuery.of(context).size.width,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10)),
                            child: const Icon(
                              Icons.login,
                              size: 50,
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                        // const Text('Welcome Back'),
                        // const SizedBox(
                        //   height: 30,
                        // ),

                        TextFormField(
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 25),
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email_outlined),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 241, 240, 240),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your email";
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return "Enter a valid email";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          controller: password,
                          obscureText: !obscure,
                          // maxLength: 40,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 25),
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscure = !obscure;
                                  });
                                },
                                icon: obscure
                                    ? const Icon(Icons.visibility_off)
                                    : const Icon(Icons.visibility)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 241, 240, 240),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your password";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              _login();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Home()));
                                },
                                child: const Text(
                                  "Dont't want to login",
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue),
                                )),
                            const SizedBox(
                              width: 90,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPassword(),
                                    ));
                              },
                              child: const Text(
                                ' Forgot Password?',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Not a User? '),
                            const SizedBox(
                              width: 4,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Signup(),
                                    ));
                              },
                              // widget.ontap,
                              child: const Text(
                                'Register now!',
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        )

                        // go to register(sign up)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
