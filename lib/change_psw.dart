import 'package:flutter/material.dart';
import 'package:socialapp/dataloader.dart';
import 'package:socialapp/models/user_detail.dart';

import 'models/user.dart';

class ChangePsw extends StatefulWidget {
  const ChangePsw({super.key});

  @override
  State<ChangePsw> createState() => _ChangePswState();
}

class _ChangePswState extends State<ChangePsw> {
  final formkey = GlobalKey<FormState>();
  final TextEditingController oldpsw = TextEditingController();
  final TextEditingController newpsw = TextEditingController();
  final TextEditingController confirmpsw = TextEditingController();
  bool obscureold = false;
  bool obscurenew = false;
  bool obscureconfirm = false;
  Dataloader dataloader = Dataloader();

  @override
  void initState() {
    super.initState();
    dataloader.loadalluserdatas();
  }

  @override
  void dispose() {
    oldpsw.dispose();
    newpsw.dispose();
    confirmpsw.dispose();
    super.dispose();
  }

  Future changepassword() async {
    List<User> users = await dataloader.getuser();
    List<UserDetail> userDetails = await dataloader.getuserdetail();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Form(
            key: formkey,
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
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(10)),
                          child: Image.asset(
                            'assets/images/reload.png',
                            height: 50,
                            width: 50,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Change Password',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                            controller: oldpsw,
                            obscureText: !obscureold,
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 25),
                              labelText: 'Old Password',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscureold = !obscureold;
                                  });
                                },
                                icon: obscureold
                                    ? const Icon(Icons.visibility_off)
                                    : const Icon(Icons.visibility),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 241, 240, 240),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your old password';
                              } else {
                                return null;
                              }
                            }),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                            controller: newpsw,
                            obscureText: !obscurenew,
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 25),
                              labelText: 'New Password',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscurenew = !obscurenew;
                                  });
                                },
                                icon: obscurenew
                                    ? const Icon(Icons.visibility_off)
                                    : const Icon(Icons.visibility),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 241, 240, 240),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your new password';
                              } else {
                                return null;
                              }
                            }),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          controller: confirmpsw,
                          obscureText: !obscureconfirm,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 25),
                            labelText: 'Confirm Password',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscureconfirm = !obscureconfirm;
                                });
                              },
                              icon: obscureconfirm
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility),
                            ),
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
                              return 'Please confirm the password';
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
                            if (formkey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Ook')));
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
                                'Submit',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )),
      )),
    );
  }
}
