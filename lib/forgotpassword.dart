import 'package:flutter/material.dart';
import 'package:socialapp/authenthication/login_auth.dart';
import 'package:socialapp/dataloader.dart';
import 'package:socialapp/home.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final formkey = GlobalKey<FormState>();
  final TextEditingController pswemail = TextEditingController();
  final TextEditingController newpsw = TextEditingController();
  late Auth auth;

  @override
  void initState() {
    super.initState();
    auth = Auth(Dataloader());
  }

  void _forgotpsw() async {
    bool isSuccess = await auth.forgotpassword(pswemail.text, newpsw.text);
    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${pswemail.text}'s password is changed")));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const Home(),
          ),
          (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Give a verfied email address')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: formkey,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Icon(
                      Icons.fingerprint,
                      size: 50,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Text("Forgot password?",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("No worries,we'll send you the reset instruction"),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: pswemail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 25),
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
                        return 'Please provide logged email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                      controller: newpsw,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 25),
                        labelText: 'New password',
                        prefixIcon: const Icon(Icons.lock),
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
                          return 'Add password of new password creation';
                        } else {
                          return null;
                        }
                        // if (!RegExp(r'[a-zA-z0-9 _]').hasMatch(value)) {
                        //   return "Please enter a valid password";
                        // }
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (formkey.currentState!.validate()) {
                        _forgotpsw();
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //     const SnackBar(content: Text('Data Saved')));
                        // Navigator.of(context).pop();
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
                          'Proceed',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
