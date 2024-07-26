import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/testing/test_auth.dart';
import 'package:socialapp/testing/test_dataloader.dart';
import 'package:socialapp/testing/test_login.dart';
import 'package:socialapp/testing/test_newsfeed.dart';
import 'package:socialapp/testing/test_userdetail_model.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Auth auth;
  UserDetail? userDetail;
  File? _imageFile;
  String? updatename;
  TextEditingController namechange = TextEditingController();

  //work
  final workformkey = GlobalKey<FormState>();
  TextEditingController job = TextEditingController();
  TextEditingController organization = TextEditingController();
  TextEditingController jobsummary = TextEditingController();
  DateTime? sdate;
  DateTime? edate;
  String? startdate;
  String? enddate;

  //for skills
  TextEditingController skills = TextEditingController();

  @override
  void initState() {
    super.initState();
    auth = Auth(Dataloader());
    _loadUserDetail();
    _loadProfileImage();
    _loadWorkExperience();
    _loadskills();
  }

  void _loadUserDetail() async {
    UserDetail? detail = await auth.getloggedinuser();
    setState(() {
      userDetail = detail;
    });
  }

  Future<void> _updateProfileImage(File file) async {
    // Directly updates the profile image path for the logged-in user
    // using a unique key (profile_image_path_$userId) and saves it to SharedPreferences.
    
    // Updates only the profile image path for the logged-in user and saves it under a unique key,
    // focusing only on the profile image path.
    final prefs = await SharedPreferences.getInstance();

    if (userDetail != null) {
      final userId = userDetail!.id;
      final imagePathKey = 'profile_image_path_$userId';
      await prefs.setString(imagePathKey, file.path);

      setState(() {
        _imageFile = file;
      });

      userDetail!.profileImage = ProfileImage(imagePath: file.path);
      await auth.saveUserDetail(userDetail!);
    }
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();

    if (userDetail != null) {
      final userId = userDetail!.id;
      final imagePathKey = 'profile_image_path_$userId';
      final imagePath = prefs.getString(imagePathKey);

      if (imagePath != null) {
        setState(() {
          _imageFile = File(imagePath);
        });
      }
    }
  }

  Future<void> _updateworkexp(
      List<WorkExperience> updatedWorkExperience) async {
    final prefs = await SharedPreferences.getInstance();

    if (userDetail != null) {
      final userId = userDetail!.id;
      final workExperienceKey = 'work_experience_$userId';
      final workExperienceJson =
          updatedWorkExperience.map((e) => e.toJson()).toList();

      await prefs.setString(workExperienceKey, jsonEncode(workExperienceJson));

      setState(() {
        userDetail!.workExperience = updatedWorkExperience;
      });

      await auth.saveUserDetail(userDetail!);
    }
  }

  Future<void> _loadWorkExperience() async {
    final prefs = await SharedPreferences.getInstance();

    if (userDetail != null) {
      final userId = userDetail!.id;
      final workExperienceKey = 'work_experience_$userId';
      final workExperienceJson = prefs.getString(workExperienceKey);

      if (workExperienceJson != null) {
        final List<dynamic> jsonList = jsonDecode(workExperienceJson);
        final workExperienceList =
            jsonList.map((e) => WorkExperience.fromJson(e)).toList();

        setState(() {
          userDetail!.workExperience = workExperienceList;
        });
      }
    }
  }

  Future<void> _addworkexp() async {
    showDialog(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: _buildSectionTitle('Add Work Experience'),
            content: Form(
              key: workformkey,
              child: Container(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    TextFormField(
                      controller: job,
                      decoration: const InputDecoration(
                        labelText: 'Job Title',
                        enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                        errorBorder: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a job title' : null,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: jobsummary,
                      decoration: const InputDecoration(
                        labelText: 'Summary',
                        enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                        errorBorder: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a jobsummary' : null,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: organization,
                      decoration: const InputDecoration(
                        labelText: 'Organization',
                        enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                        errorBorder: OutlineInputBorder(),
                      ),
                      validator: (value) => value!.isEmpty
                          ? 'Please enter the organization name'
                          : null,
                    ),
                    ListTile(
                      title: Text(sdate == null
                          ? 'Select a date'
                          : 'Startdate $startdate'),
                      onTap: _selectstartdate,
                    ),
                    ListTile(
                      title: Text(edate == null
                          ? 'Select a date'
                          : 'Enddate ${DateFormat('y-MM-dd').format(edate!)}'),
                      onTap: _selectenddate,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (workformkey.currentState!.validate()) {
                            if (userDetail != null) {
                              final workexp = WorkExperience(
                                  jobTitle: job.text,
                                  startDate: startdate,
                                  endDate: enddate,
                                  organizationName: organization.text,
                                  summary: jobsummary.text);
                              final updatedList = List<WorkExperience>.from(
                                  userDetail!.workExperience ?? []);
                              updatedList.add(workexp);
                              _updateworkexp(updatedList);
                              //use setstate to clear the fields.
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: const Text('Submit')),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  /* ...userDetail!.skills!.map(
                    (skill) => _buildContainer(
                      ListTile(
                        title: Text(skill.title ?? ''),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _removeSkill(skill), */

  void _removeWorkExperience(WorkExperience work) {
    if (userDetail != null) {
      final updatedList =
          List<WorkExperience>.from(userDetail!.workExperience ?? []);
      updatedList.remove(work);
      _updateworkexp(updatedList);
    }
  }

  Future<void> _updateskills(List<Skills> skills) async {
    final prefs = await SharedPreferences.getInstance();

    if (userDetail != null) {
      final userid = userDetail!.id;
      final skillkey = 'skill_$userid';
      final skilljson = skills.map((e) => e.toJson()).toList();

      await prefs.setString(skillkey, jsonEncode(skilljson));

      setState(() {
        userDetail!.skills = skills;
      });
      await auth.saveUserDetail(userDetail!);
    }
  }

  Future<void> _loadskills() async {
    final prefs = await SharedPreferences.getInstance();

    if (userDetail != null) {
      final userid = userDetail!.id;
      final skillkey = 'skill_$userid';
      final skilljson = prefs.getString(skillkey);
      if (skilljson != null) {
        final List jsonlist = jsonDecode(skilljson);
        final skillslist = jsonlist.map((e) => Skills.fromJson(e)).toList();

        setState(() {
          userDetail!.skills = skillslist;
        });
      }
    }
  }

  void _removeskills(Skills skill) async {
    if (userDetail != null) {
      final updatedlist = List<Skills>.from(userDetail!.skills ?? []);
      updatedlist.remove(skill);
      _updateskills(updatedlist);
    }
  }

  Future<void> _selectstartdate() async {
    DateTime? picker = await showDatePicker(
        context: context, firstDate: DateTime(1990), lastDate: DateTime.now());
    if (picker != null && picker != sdate) {
      setState(
        () {
          sdate = picker;
          startdate = DateFormat('y-MM-dd').format(sdate!);
          if (edate != null && edate!.isBefore(sdate!)) {
            edate = null;
            enddate = null;
          }
        },
      );
    }
  }

  Future<void> _selectenddate() async {
    if (sdate == null) {
      return;
    }
    DateTime? picker = await showDatePicker(
        context: context,
        initialDate: edate ??
            (sdate != null
                ? sdate!.add(
                    const Duration(days: 1),
                  )
                : DateTime.now()),
        firstDate: sdate!.add(const Duration(days: 1)) ?? DateTime.now(),
        lastDate: DateTime.now());
    if (picker != null && picker != sdate) {
      setState(() {
        edate = picker;
        enddate = DateFormat('y-MM-dd').format(edate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Profile"),
          GestureDetector(
            onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Newsfeed(),
                )),
            child: const Icon(Icons.feed),
          )
        ],
      )),
      resizeToAvoidBottomInset: true, //ensures content resizing
      body: userDetail == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _imageFile != null
                        ? Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          )
                        : Image.network(
                            userDetail!.profileImage!.imagePath!,
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final picked =
                            await picker.pickImage(source: ImageSource.camera);
                        if (picked != null) {
                          final file = File(picked.path);
                          await _updateProfileImage(file);
                        }
                      },
                      child: const Text('Change Profile Image'),
                    ),
                    SizedBox(height: 16),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        await auth.logout();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ));
                      },
                      child: Text("Logout"),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _addworkexp,
                      child: Text('Add Work Experience'),
                    ),
                    ...userDetail!.workExperience!.map(
                      (work) => _buildContainer(
                        ListTile(
                          title: Text(work.jobTitle ?? ''),
                          subtitle: Text(work.organizationName ?? ''),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _removeWorkExperience(work),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionTitle('Skills'),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Add Skills'),
                                  content: TextFormField(
                                    controller: skills,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'[A-za-z _]'),
                                      ),
                                    ],
                                    maxLength: 20,
                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(),
                                      labelText: 'Skills',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please provide skills';
                                      }
                                    },
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('Cancel')),
                                    TextButton(
                                        onPressed: () {
                                          if (skills.text.isNotEmpty) {
                                            final newskill =
                                                Skills(title: skills.text);
                                            final updatelist =
                                                List<Skills>.from(
                                                    userDetail!.skills ?? []);
                                            updatelist.add(newskill);
                                            _updateskills(updatelist);
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: Text('Submit'))
                                  ],
                                );
                              },
                            );
                          },
                          child: const Icon(
                            Icons.edit_outlined,
                            size: 30,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        ...userDetail!.skills!.map((skil) => _buildskills(skil))
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildContainer(Widget child) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  // Widget _buildChips(List<String> items) {
  //   return Wrap(
  //     spacing: 8.0,
  //     runSpacing: 4.0,
  //     children: items.map((item) {
  //       return Chip(
  //         label: Text(
  //           item,
  //           style: const TextStyle(color: Colors.white),
  //         ),
  //         backgroundColor: Colors.black,
  //       );
  //     }).toList(),
  //   );
  // }

  Widget _buildskills(Skills skill) {
    return Wrap(
      direction: Axis.horizontal,
      spacing: 8,
      runSpacing: 4,
      children: [
        Chip(
          deleteIcon:const Icon(
            Icons.cancel,
            size: 15,
            color: Colors.white,
          ),
          backgroundColor: Colors.black,
          deleteButtonTooltipMessage: 'Delete',
          label:
              Text(skill.title!, style: const TextStyle(color: Colors.white)),
          onDeleted: () => _removeskills(skill),
        )
        //
      ],
    );
  }
}
