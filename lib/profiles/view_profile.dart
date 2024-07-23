import 'dart:convert';
import 'dart:io';



import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:socialapp/authenthication/dddart.dart';
import 'package:socialapp/change_psw.dart';
import 'package:socialapp/dataloader.dart';
import 'package:socialapp/home.dart';
import 'package:socialapp/login.dart';
// import 'package:socialapp/models/user.dart';
import 'package:socialapp/models/user_detail.dart';
import 'package:socialapp/profiles/cover_full.dart';
import 'package:socialapp/profiles/profile_full.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../authenthication/login_auth.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile({super.key});
  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  late Auth auth;
  UserDetail? userDetail;
  final statuskey = GlobalKey<FormState>();
  final basicinfokey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();
  //for basic info update
  String? newname;
  String? newsummary;
//for input update
  String? newgender;
  String? newmaritalstatus;
  DateTime? dob;
  String? newdate;
  //for work exp
  final workformkey = GlobalKey<FormState>();
  TextEditingController job = TextEditingController();
  TextEditingController organization = TextEditingController();
  TextEditingController jobsummary = TextEditingController();
  DateTime? sdate;
  DateTime? edate;
  String? startdate;
  String? enddate;
  //for eduation
  final eduformkey = GlobalKey<FormState>();
  TextEditingController edulevel = TextEditingController();
  TextEditingController eduorganization = TextEditingController();
  TextEditingController edusummary = TextEditingController();
  DateTime? edusdate;
  DateTime? eduedate;
  String? edustartdate;
  String? eduenddate;
  //for accomplishment
  final accomformkey = GlobalKey<FormState>();
  TextEditingController accomtitle = TextEditingController();
  TextEditingController accomdescrip = TextEditingController();
  //for social media
  final socialkey = GlobalKey<FormState>();
  TextEditingController platform = TextEditingController();
  TextEditingController link = TextEditingController();
  //image
  File? profile;
  File? cover;
  Uint8List? coveriamge;
  TextEditingController updatename = TextEditingController();
  TextEditingController updatesumary = TextEditingController();
  TextEditingController mobilenumber = TextEditingController();

  @override
  void initState() {
    super.initState();
    auth = Auth(Dataloader());
    _loaduserDetail();
    _loadprofileImage();
    _loadcoverImage();
    _loadStatus();
    _loadBasicInfo();
    _loadnumber();
    _loadworkexp();
    _loadeducation();
    _loadAccomplishment();
    _loadsocial();
  }

  void _loaduserDetail() async {
    UserDetail? detail = await auth.getloggedinuser();
    setState(() {
      userDetail = detail;
      //createing different method to handle images
    });
  }

  Future _updateProfileImage(File file) async {
    final prefs = await SharedPreferences.getInstance();

    if (userDetail != null) {
      final userid = userDetail!.id; //getting the id to that sp.user
      final profilekey =
          'profile_$userid'; //created a unique key to set the image path
      prefs.setString(profilekey, file.path);

      setState(() {
        profile = file; //update the locaal state here
      });
      userDetail!.profileImage = ProfileImage(imagePath: file.path);
      await auth.saveUserDetail(userDetail!);
    }
  }

  Future<void> _loadprofileImage() async {
    //initialized
    final prefs = await SharedPreferences.getInstance();
    if (userDetail != null) {
      final userid = userDetail!.id; //get user id for updating specific profile
      //create a unique key to set the image path
      final profilekey = 'profile_$userid';
      final imagepath = prefs
          .getString(profilekey); //retriving image path (from updateprofile)

      if (imagepath != null) {
        setState(() {
          profile =
              File(imagepath); //updates the local state with the saved image
        });
      }
    }
  }

  Future<void> _updateCoverImage(File file) async {
    final prefs = await SharedPreferences.getInstance();
    if (userDetail != null) {
      final userid = userDetail!.id;
      final coverkey = 'cover_$userid';
      await prefs.setString(coverkey, file.path);

      setState(() {
        cover = file;
      });

      userDetail!.coverImage = CoverImage(imagepath: file.path);
      await auth.saveUserDetail(userDetail!);
    }
  }

  Future<void> _loadcoverImage() async {
    final prefs = await SharedPreferences.getInstance();
    if (userDetail != null) {
      final userid = userDetail!.id;
      final coverkey = 'cover_$userid';
      final imagepath = prefs.getString(coverkey);
      if (imagepath != null) {
        setState(() {
          cover = File(imagepath);
        });
      }
    }
  }

  Future<void> _updateBasicinfo(String name, [String? summary]) async {
    final prefs = await SharedPreferences.getInstance();
    if (userDetail != null) {
      final userid = userDetail!.id; //used for ccreating a unique key
      final namekey = 'name_$userid';
      final summarykey = 'summary_$userid';

      await prefs.setString(namekey, name);
      if (summary != null) {
        await prefs.setString(summarykey, summary);
      }
      setState(() {
        newname = name;
        userDetail!.basicInfo!.name = name;

        if (summary != null) {
          newsummary = summary;
          userDetail!.basicInfo!.summary = summary;
        }
      });
      await auth.saveUserDetail(userDetail!);
    }
  }

  Future<void> _loadBasicInfo() async {
    final prefs = await SharedPreferences.getInstance();

    if (userDetail != null) {
      final userid = userDetail!.id;
      final namekey = 'name_$userid';
      final summarykey = 'summary_$userid';

      final uname = prefs.getString(namekey);
      final usummary = prefs.getString(summarykey);

      if (uname != null) {
        setState(() {
          newname = uname;
          userDetail!.basicInfo!.name = uname;
        });
        if (usummary != null) {
          setState(() {
            newsummary = usummary;
            userDetail!.basicInfo!.summary = usummary;
          });
        }
      }
    }
  }

  //dob ??= userdetail.basicInfo!.dob;
  //  if (dob == null) {
  // dob = userDetail.basicInfo.dob;
  // }

  // userdetail.basicInfo!.gender = gender;

  //     userdetail.basicInfo!.maritalStatus = maritalstatus;
  //     dob ??= userdetail.basicInfo!.dob;

  //     await auth.saveUserDetail(userdetail);

  Future _updateStatus(String matrialstatus,
      [String? dob, String? gender]) async {
    final prefs = await SharedPreferences.getInstance();

    if (userDetail != null) {
      final userid = userDetail!.id;
      final maritalkey = 'marital_$userid';
      await prefs.setString(maritalkey, matrialstatus);

      setState(() {
        userDetail!.basicInfo!.maritalStatus = matrialstatus;
      });
      //only update if it is provided
      if (dob != null && dob.isNotEmpty) {
        final dobkey = 'dob_$userid';
        await prefs.setString(dobkey, dob);

        setState(() {
          userDetail!.basicInfo!.dob = dob;
        });
      }

      if (gender != null && gender.isNotEmpty) {
        final genderkey = 'gender_$userid';
        await prefs.setString(genderkey, gender);

        setState(() {
          userDetail!.basicInfo!.gender = gender;
        });
      }
      await auth.saveUserDetail(userDetail!);
    }
  }

  Future<void> _loadStatus() async {
    final prefs = await SharedPreferences.getInstance();

    if (userDetail != null) {
      final userid = userDetail!.id;
      final maritalkey = 'marital_$userid';

      final umarital = prefs.getString(maritalkey);
      if (umarital != null) {
        setState(() {
          userDetail!.basicInfo!.maritalStatus = umarital;
        });
      }
      final dobkey = 'dob_$userid';
      final udob = prefs.getString(dobkey);
      if (udob != null) {
        setState(() {
          userDetail!.basicInfo!.dob = udob;
        });
      }
      final genderkey = 'gender_$userid';
      final ugender = prefs.getString(genderkey);

      if (ugender != null) {
        setState(() {
          userDetail!.basicInfo!.gender = ugender;
        });
      }
    }
  }

  Future<void> _updatemobile(String mobile) async {
    final prefs = await SharedPreferences.getInstance();

    if (userDetail != null) {
      final userid = userDetail!.id;
      final key = 'mobile_$userid';
      await prefs.setString(key, mobile);

      setState(() {
        userDetail!.contactInfo!.mobileNo = mobile;
      });
      await auth.saveUserDetail(userDetail!);
    }
  }

  Future<void> _loadnumber() async {
    final prefs = await SharedPreferences.getInstance();

    if (userDetail != null) {
      final userid = userDetail!.id;
      final key = 'mobile_$userid';
      final umobile = prefs.getString(key);

      if (umobile != null) {
        setState(() {
          userDetail!.contactInfo!.mobileNo = umobile;
        });
      }
    }
  }

  Future<void> _updateworkexp(List<WorkExperience> exp) async {
    final prefs = await SharedPreferences.getInstance();

    if (userDetail != null) {
      final userid = userDetail!.id;
      final expkey = 'exp_$userid';
      final expjson = exp.map((e) => e.toJson()).toList();

      await prefs.setString(expkey, jsonEncode(expjson));

      setState(() {
        userDetail!.workExperience = exp;
      });

      await auth.saveUserDetail(userDetail!);
    }
  }

  Future<void> _loadworkexp() async {
    final prefs = await SharedPreferences.getInstance();

    if (userDetail != null) {
      final userid = userDetail!.id;
      final expkey = 'exp_$userid';

      final expjson = prefs.getString(expkey); //here it gets encoded data

      if (expjson != null) {
        final List jsonList = jsonDecode(expjson);
        final explist =
            jsonList.map((e) => WorkExperience.fromJson(e)).toList();

        setState(() {
          userDetail!.workExperience = explist;
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
                      onTap: () async {
                        DateTime? picker = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1990),
                            lastDate: DateTime.now());
                        if (picker != null && picker != sdate) {
                          setState(() {
                            sdate = picker;
                            startdate = DateFormat('y-MM-dd').format(sdate!);
                            if (edate != null && edate!.isBefore(sdate!)) {
                              edate = null;
                            }
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: Text(edate == null
                          ? 'Select a date'
                          : 'Enddate ${DateFormat('y-MM-dd').format(edate!)}'),
                      onTap: () async {
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
                            firstDate: sdate?.add(const Duration(days: 1)) ??
                                DateTime.now(),
                            lastDate: DateTime.now());
                        if (picker != null && picker != sdate) {
                          setState(() {
                            edate = picker;

                            enddate = DateFormat('y-MM-dd').format(edate!);
                          });
                        }
                      },
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

  void _removeworkexp(WorkExperience work) {
    if (userDetail != null) {
      final updatedList =
          List<WorkExperience>.from(userDetail!.workExperience ?? []);
      updatedList.remove(work);
      _updateworkexp(updatedList);
    }
  }

  Future<void> _updateeducation(List<Education> edu) async {
    final prefs = await SharedPreferences.getInstance();

    if (userDetail != null) {
      final userid = userDetail!.id;
      final edukey = 'edu_$userid';
      final edujson = edu.map((e) => e.toJson()).toList();

      await prefs.setString(edukey, jsonEncode(edujson));

      setState(() {
        userDetail!.education = edu;
      });

      await auth.saveUserDetail(userDetail!);
    }
  }

  Future<void> _loadeducation() async {
    final prefs = await SharedPreferences.getInstance();

    if (userDetail != null) {
      final userid = userDetail!.id;
      final edukey = 'edu_$userid';

      final edujson = prefs.getString(edukey);

      if (edujson != null) {
        final List jsonlist = jsonDecode(edujson);
        final edulist = jsonlist.map((e) => Education.fromJson(e)).toList();

        setState(() {
          userDetail!.education = edulist;
        });
      }
    }
  }

  Future<void> _addedu() async {
    showDialog(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: _buildSectionTitle('Add Education'),
            content: Form(
              key: eduformkey,
              child: Container(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    TextFormField(
                      controller: edulevel,
                      decoration: const InputDecoration(
                        labelText: 'Level',
                        enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                        errorBorder: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a Level' : null,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: edusummary,
                      decoration: const InputDecoration(
                        labelText: 'Summary',
                        enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                        errorBorder: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a Summary' : null,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: eduorganization,
                      decoration: const InputDecoration(
                        labelText: 'Organization',
                        enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                        errorBorder: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter Institution' : null,
                    ),
                    ListTile(
                      title: Text(edusdate == null
                          ? 'Select a date'
                          : 'Startdate ${DateFormat('y-MM-dd').format(edusdate!)}'),
                      onTap: () async {
                        DateTime? picker = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1990),
                            lastDate: DateTime.now());
                        if (picker != null && picker != edusdate) {
                          setState(() {
                            edusdate = picker;
                            edustartdate =
                                DateFormat('y-MM-dd').format(edusdate!);
                            if (eduedate != null &&
                                eduedate!.isBefore(edusdate!)) {
                              eduedate = null;
                            }
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: Text(eduedate == null
                          ? 'Select a date'
                          : 'Enddate ${DateFormat('y-MM-dd').format(eduedate!)}'),
                      onTap: () async {
                        if (edusdate == null) {
                          return;
                        }
                        DateTime? picker = await showDatePicker(
                            context: context,
                            initialDate: eduedate ??
                                (edusdate != null
                                    ? edusdate!.add(
                                        const Duration(days: 1),
                                      )
                                    : DateTime.now()),
                            firstDate: edusdate?.add(const Duration(days: 1)) ??
                                DateTime.now(),
                            lastDate: DateTime.now());
                        if (picker != null && picker != edusdate) {
                          setState(() {
                            eduedate = picker;

                            eduenddate =
                                DateFormat('y-MM-dd').format(eduedate!);
                          });
                        }
                      },
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (eduformkey.currentState!.validate()) {
                            if (userDetail != null) {
                              final eduform = Education(
                                level: edulevel.text,
                                organizationName: eduorganization.text,
                                summary: edusummary.text,
                                startDate: edustartdate,
                                endDate: eduenddate,
                              );
                              final updatedList = List<Education>.from(
                                  userDetail!.education ?? []);
                              updatedList.add(eduform);
                              _updateeducation(updatedList);
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

  void _removeedu(Education education) {
    if (userDetail != null) {
      final updatedList = List<Education>.from(userDetail!.education ?? []);
      updatedList.remove(education);
      _updateeducation(updatedList);
    }
  }

  Future<void> _updateAccomplishment(List<Accomplishments> accom) async {
    final prefs = await SharedPreferences.getInstance();

    if (userDetail != null) {
      final userid = userDetail!.id;
      final accomkey = 'accom_$userid';
      final accomjson = accom.map((e) => e.toJson()).toList();

      await prefs.setString(accomkey, jsonEncode(accomjson));

      setState(() {
        userDetail!.accomplishments = accom;
      });

      await auth.saveUserDetail(userDetail!);
    }
  }

  Future<void> _loadAccomplishment() async {
    final prefs = await SharedPreferences.getInstance();

    if (userDetail != null) {
      final userid = userDetail!.id;
      final accomkey = 'accom_$userid';

      final accomjson = prefs.getString(accomkey);

      if (accomjson != null) {
        final List jsonlist = jsonDecode(accomjson);
        final accomlist =
            jsonlist.map((e) => Accomplishments.fromJson(e)).toList();

        setState(() {
          userDetail!.accomplishments = accomlist;
        });
      }
    }
  }

  Future<void> _addaccom() async {
    showDialog(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: _buildSectionTitle('Add Accomplishment'),
            content: Form(
              key: accomformkey,
              child: Container(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    TextFormField(
                      controller: accomtitle,
                      decoration: const InputDecoration(
                        labelText: ' Title',
                        enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                        errorBorder: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a title' : null,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: accomdescrip,
                      decoration: const InputDecoration(
                        labelText: ' Description',
                        enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                        errorBorder: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter description' : null,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (accomformkey.currentState!.validate()) {
                            if (userDetail != null) {
                              final accomform = Accomplishments(
                                title: accomtitle.text,
                                description: accomdescrip.text,
                              );
                              final updatelist = List<Accomplishments>.from(
                                  userDetail!.accomplishments ?? []);
                              updatelist.add(accomform);
                              _updateAccomplishment(updatelist);
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: const Text('Submit'))
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _removeaccom(Accomplishments accomplishments) {
    if (userDetail != null) {
      final updatedList =
          List<Accomplishments>.from(userDetail!.accomplishments ?? []);
      updatedList.remove(accomplishments);
      _updateAccomplishment(updatedList);
    }
  }

  Future<void> _updatesocial(List<SocialMedia> media) async {
    final prefs = await SharedPreferences.getInstance();

    if (userDetail != null) {
      final userid = userDetail!.id;
      final mediakey = 'media_$userid';
      final mediajson = media.map((e) => e.toJson()).toList();

      await prefs.setString(mediakey, jsonEncode(mediajson));

      setState(() {
        userDetail!.contactInfo!.socialMedia = media;
      });

      await auth.saveUserDetail(userDetail!);
    }
  }

  Future<void> _loadsocial() async {
    final prefs = await SharedPreferences.getInstance();

    if (userDetail != null) {
      final userid = userDetail!.id;
      final key = 'social_$userid';

      final mediajson = prefs.getString(key);

      if (mediajson != null) {
        final List jsonlist = jsonDecode(mediajson);
        final medialist = jsonlist.map((e) => SocialMedia.fromJson(e)).toList();

        setState(() {
          userDetail!.contactInfo!.socialMedia = medialist;
        });
      }
    }
  }

  Future<void> _addsocial() async {
    showDialog(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text('Add Social media'),
            content: Form(
              key: socialkey,
              child: Column(
                children: [
                  TextFormField(
                    controller: platform,
                    decoration: const InputDecoration(
                      labelText: 'Platform',
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      errorBorder: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please provide platform' : null,
                  ),
                  TextFormField(
                    controller: link,
                    decoration: const InputDecoration(
                      labelText: 'Link',
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      errorBorder: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.isEmpty
                        ? 'Please provide link to Social Media'
                        : null,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (socialkey.currentState!.validate()) {
                          if (userDetail != null) {
                            final socialmedia = SocialMedia(
                              title: platform.text,
                              url: link.text,
                            );
                            final updatelist = List<SocialMedia>.from(
                                userDetail!.contactInfo!.socialMedia ?? []);
                            updatelist.add(socialmedia);
                            _updatesocial(updatelist);
                            Navigator.pop(context);
                          }
                        }
                      },
                      child: const Text('Submit'))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _removedocial(SocialMedia media) {
    if (userDetail != null) {
      final updatelist =
          List<SocialMedia>.from(userDetail!.contactInfo!.socialMedia ?? []);
      updatelist.remove(media);
      _updatesocial(updatelist);
    }
  }

  Future<void> _updateskills() async {}

  //created this imageprovider fn cause ternary operator in background image did't work
  //kept show error The argument type 'Object' can't be assigned to the parameter type 'ImageProvider<Object>?'
  ImageProvider<Object>? _getprofileimage() {
    if (profile != null) {
      //here FileImage was used instead of Image.file beacuse FileImage use imageprovider that takes imagepath to load the image
      return FileImage(profile!);
    } else if (userDetail != null && userDetail!.profileImage != null) {
      if (userDetail!.profileImage!.isNetworkUrl!) {
        return NetworkImage(userDetail!.profileImage!.imagePath!);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('User Profile'),
            userDetail == null
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: const Icon(Icons.login)
                    // const Text(
                    //   'Login',
                    //   style: TextStyle(color: Colors.black),
                    // ),
                    )
                : ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePsw(),
                          ));
                    },
                    child: Image.asset('assets/images/reload.png',
                        height: 25, width: 25),
                    // const Text(
                    //   'Change Password',
                    //   style: TextStyle(color: Colors.black),
                    // ),
                  ),
          ],
        ),
      ),
      body: userDetail == null
          ? const Center(
              child: Text('No user logged in'),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 275,
                    child: Stack(
                      /// The above code is setting the `clipBehavior` property of an object to `Clip.none`. This
                      /// means that clipping behavior is disabled for the object, allowing it to be drawn outside
                      /// its bounds.
                      clipBehavior: Clip.none,

                      //enabled the overlapping effect to the profilepicture
                      children: [
                        SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () {
                              print('open pcitrue');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullCoverPic(
                                    imagepath: cover!,
                                  ), //here i passed the userdetail used to display the current logged profile detail
                                ),
                              );
                            },
                            child:
                                //here i have used Image.file instead fo FileImage because it can directly display the image without imageprovider
                                cover != null
                                    ? Image.file(
                                        cover!,
                                        fit: BoxFit.fill,
                                      )
                                    : userDetail!.coverImage!.isNetworkUrl!
                                        ? Image.network(
                                            userDetail!.coverImage!.imagepath!,
                                            fit: BoxFit.cover,
                                          )
                                        : const SizedBox(),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          bottom: 2,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullProfilePic(
                                      imagefile: profile!,
                                    ),
                                  ));
                            },
                            child: CircleAvatar(
                              radius: 70,

                              //here i created a fun only beacuse it was giving error for type
                              // circlavatare's backgroundinage needs imageprovider
                              backgroundImage: _getprofileimage(),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 220,
                          top: 185,
                          child: GestureDetector(
                            onTap: () {
                              print('profile');
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Choose profile Picture'),
                                    actions: [
                                      TextButton(
                                          onPressed: () async {
                                            final picked =
                                                await picker.pickImage(
                                                    source: ImageSource.camera);

                                            if (picked != null) {
                                              final file = File(picked.path);
                                              await _updateProfileImage(
                                                  file); //update profile
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: const Text('Take Picture')),
                                      TextButton(
                                          onPressed: () async {
                                            final picked =
                                                await picker.pickImage(
                                                    source:
                                                        ImageSource.gallery);

                                            if (picked != null) {
                                              final file = File(picked.path);
                                              await _updateProfileImage(file);
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: const Text(
                                              'Choose from Gallery ')),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const CircleAvatar(
                              backgroundColor: Colors.black,
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            right: 16,
                            top: 150,
                            child: GestureDetector(
                              onTap: () {
                                print('Choose cover');
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Choose cover Picture'),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            final picked =
                                                await picker.pickImage(
                                                    source: ImageSource.camera);

                                            if (picked != null) {
                                              final file = File(picked.path);
                                              await _updateCoverImage(file);
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: const Text('Take Picture'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            final picked =
                                                await picker.pickImage(
                                                    source:
                                                        ImageSource.gallery);

                                            if (picked != null) {
                                              final file = File(picked.path);
                                              await _updateCoverImage(file);
                                              Navigator.pop(context);
                                            }
                                          },
                                          child:
                                              const Text('Choose from Gallery'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const CircleAvatar(
                                  backgroundColor: Colors.black,
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                  )),
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userDetail!.basicInfo?.name ?? '',
                                  style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold),
                                ),
                                // Text('${userDetail!.id}'),
                                const SizedBox(height: 8),
                                Text(
                                  userDetail!.basicInfo?.summary ?? '',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[700]),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Your name'),
                                    content: Form(
                                      key: basicinfokey,
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            // onChanged: (value) {
                                            //   updatename.text = value;
                                            // },
                                            controller: updatename,
                                            decoration: InputDecoration(
                                              labelText: 'Your name',
                                              prefixIcon:
                                                  const Icon(Icons.person),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              filled: true,
                                              fillColor: const Color.fromARGB(
                                                  255, 241, 240, 240),
                                            ),
                                            maxLength: 40,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter Your name';
                                              }
                                              return null;
                                            },
                                          ),
                                          TextFormField(
                                            // onChanged: (value) {
                                            //   updatesumary.text = value;
                                            // },
                                            controller: updatesumary,
                                            decoration: InputDecoration(
                                              labelText: 'Your summary',
                                              prefixIcon:
                                                  const Icon(Icons.person),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              filled: true,
                                              fillColor: const Color.fromARGB(
                                                  255, 241, 240, 240),
                                            ),
                                            maxLength: 40,
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10,
                                              )),
                                          child: const Text(
                                            'Cancel',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (basicinfokey.currentState!
                                              .validate()) {
                                            _updateBasicinfo(updatename.text,
                                                updatesumary.text);
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text('Name changed'),
                                              ),
                                            );
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10,
                                              )),
                                          child: const Text(
                                            'Save',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: const Icon(Icons.edit_outlined),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await auth.logout();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        duration: Duration(seconds: 1),
                                        content: Text('Logged out')));
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Home(),
                                    ));
                              },
                              child: const Icon(Icons.logout),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildSectionTitle('Basic Information'),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Update your BasicInfo !'),
                                            content: Form(
                                              key: statuskey,
                                              child: SizedBox(
                                                height: 250,
                                                child: Column(
                                                  children: [
                                                    DropdownButtonFormField(
                                                      decoration:
                                                          InputDecoration(
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .white),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .white),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        filled: true,
                                                        fillColor: const Color
                                                            .fromARGB(
                                                            255, 241, 240, 240),
                                                      ),
                                                      hint:
                                                          const Text('Gender'),
                                                      value: newgender,
                                                      items: const [
                                                        DropdownMenuItem(
                                                          value: 'Male',
                                                          child: Text('Male'),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: 'Female',
                                                          child: Text('Female'),
                                                        )
                                                      ],
                                                      onChanged: (value) {
                                                        setState(() {
                                                          newgender = value;
                                                        });
                                                      },
                                                    ),
                                                    const SizedBox(height: 10),
                                                    DropdownButtonFormField(
                                                      decoration:
                                                          InputDecoration(
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .white),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .white),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        filled: true,
                                                        fillColor: const Color
                                                            .fromARGB(
                                                            255, 241, 240, 240),
                                                      ),
                                                      hint: const Text(
                                                          'Marital Status'),
                                                      value: newmaritalstatus,
                                                      items: const [
                                                        DropdownMenuItem(
                                                          value: 'Single',
                                                          child: Text('Single'),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: 'Married',
                                                          child:
                                                              Text('Married'),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: 'Divorce',
                                                          child:
                                                              Text('Divorce'),
                                                        ),
                                                      ],
                                                      onChanged: (value) {
                                                        setState(() {
                                                          newmaritalstatus =
                                                              value;
                                                        });
                                                      },
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Please enter your status';
                                                        }
                                                      },
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      height: 60,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: ListTile(
                                                        trailing: const Icon(Icons
                                                            .calendar_month_outlined),
                                                        title: Text(dob == null
                                                            ? "Select Date of Birth"
                                                            : 'DOB: ${DateFormat('y-MM-dd').format(dob!)}'),
                                                        onTap: () async {
                                                          DateTime? picked =
                                                              await showDatePicker(
                                                                  context:
                                                                      context,
                                                                  firstDate:
                                                                      DateTime(
                                                                          1900),
                                                                  lastDate:
                                                                      DateTime
                                                                          .now());
                                                          if (picked != null &&
                                                              picked != dob) {
                                                            setState(() {
                                                              dob = picked;
                                                              newdate = DateFormat(
                                                                      'y-MM-dd')
                                                                  .format(dob!);
                                                            });
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            actions: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        10,
                                                      )),
                                                  child: const Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  if (statuskey.currentState!
                                                      .validate()) {
                                                    _updateStatus(
                                                        newmaritalstatus!,
                                                        newdate,
                                                        newgender!);
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'Basic info updated'),
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        10,
                                                      )),
                                                  child: const Text(
                                                    'Save',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
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
                              const SizedBox(
                                height: 20,
                              ),
                              _buildInfoRow('Gender',
                                  userDetail!.basicInfo?.gender ?? ''),
                              _buildInfoRow('Date of Birth',
                                  userDetail!.basicInfo?.dob ?? ''),
                              _buildInfoRow('Marital Status',
                                  userDetail!.basicInfo?.maritalStatus ?? ''),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildcontainer(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildSectionTitle("Work Experience"),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _addworkexp();
                                      });
                                    },
                                    child: const Icon(
                                      Icons.add,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              ),
                              ...userDetail!
                                  .workExperience! //here spread operator is used to insert all the elements to another collection
                                  .map(
                                (work) => Dismissible(
                                  key: Key(work.jobTitle ?? ''),
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (direction) =>
                                      _removeworkexp(work),
                                  confirmDismiss:
                                      (DismissDirection direction) async {
                                    return await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Confirm"),
                                          content: const Text(
                                              "Are you sure you wish to delete this item?"),
                                          actions: <Widget>[
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(true),
                                                child: const Text("DELETE")),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                              child: const Text("CANCEL"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  background: Container(
                                    padding: const EdgeInsets.only(right: 20),
                                    alignment: Alignment.centerRight,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.black,
                                    ),
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: _buildWorkExperience(work),
                                ),
                              ), //_buildWorkExperience(work)
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildcontainer(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildSectionTitle('Skills'),
                                  const Icon(
                                    Icons.edit_outlined,
                                    size: 30,
                                  )
                                ],
                              ),
                              _buildChips(userDetail!.skills!
                                  .map((skill) => skill.title!)
                                  .toList()),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildSectionTitle('Hobbies'),
                                  const Icon(
                                    Icons.edit_outlined,
                                    size: 30,
                                  )
                                ],
                              ),
                              _buildChips(userDetail!.hobbies!
                                  .map((hobby) => hobby.title!)
                                  .toList()),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildSectionTitle('Languages'),
                                  const Icon(Icons.edit_outlined, size: 30)
                                ],
                              ),
                              _buildChips(userDetail!.languages!
                                  .map((lang) => lang.title!)
                                  .toList()),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildcontainer(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildSectionTitle('Education'),
                                  GestureDetector(
                                    onTap: _addedu,
                                    child: const Icon(
                                      Icons.add,
                                      size: 30,
                                    ),
                                  )
                                ],
                              ),
                              ...userDetail!.education!.map(
                                (education) => Dismissible(
                                  key: Key(education.level ?? ''),
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (direction) =>
                                      _removeedu(education),
                                  confirmDismiss:
                                      (DismissDirection direction) async {
                                    return await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Confirm"),
                                          content: const Text(
                                              "Are you sure you wish to delete this item?"),
                                          actions: <Widget>[
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(true),
                                                child: const Text("DELETE")),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                              child: const Text("CANCEL"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  background: Container(
                                    padding: const EdgeInsets.only(right: 20),
                                    alignment: Alignment.centerRight,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.black,
                                    ),
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: _buildEducation(education),
                                ),
                                //  _buildEducation(education),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildcontainer(Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildSectionTitle('Accomplishments'),
                                GestureDetector(
                                  onTap: _addaccom,
                                  child: const Icon(
                                    Icons.add,
                                    size: 30,
                                  ),
                                )
                              ],
                            ),
                            ...userDetail!.accomplishments!.map(
                              (acc) => Dismissible(
                                key: Key(acc.title ?? ''),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) => _removeaccom(acc),
                                confirmDismiss:
                                    (DismissDirection direction) async {
                                  return await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Confirm"),
                                        content: const Text(
                                            "Are you sure you wish to delete this item?"),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: const Text("DELETE")),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: const Text("CANCEL"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                background: Container(
                                  padding: const EdgeInsets.only(right: 20),
                                  alignment: Alignment.centerRight,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.black,
                                  ),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                child: _buildAccomplishment(acc),
                              ),
                              // _buildAccomplishment(acc),
                            ),
                          ],
                        )),
                        const SizedBox(height: 16),
                        _buildcontainer(Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildSectionTitle('Contact Information'),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title:
                                              const Text('Your mobile number'),
                                          content: TextField(
                                            onChanged: (value) {
                                              mobilenumber.text = value;
                                            },
                                            controller: mobilenumber,
                                            decoration: InputDecoration(
                                              labelText: 'Your mobile number',
                                              prefixIcon:
                                                  const Icon(Icons.phone),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              filled: true,
                                              fillColor: const Color.fromARGB(
                                                  255, 241, 240, 240),
                                            ),
                                            maxLength: 10,
                                            keyboardType: TextInputType.number,
                                          ),
                                          actions: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      10,
                                                    )),
                                                child: const Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                _updatemobile(
                                                    mobilenumber.text);
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'Mobile number changed'),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      10,
                                                    )),
                                                child: const Text(
                                                  'Save',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Mobile No.',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[700]),
                                ),
                                Text(
                                  userDetail!.contactInfo?.mobileNo ?? '',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[700]),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            // _buildInfoRow(
                            //     'Mobile No', userDetail.contactInfo?.mobileNo ?? ''),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildSectionTitle('Social Media'),
                                GestureDetector(
                                  onTap: _addsocial,
                                  child: const Icon(
                                    Icons.add,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                            ...userDetail!.contactInfo!.socialMedia!.map(
                                (social) => Dismissible(
                                      key: Key(social.title ?? ''),
                                      direction: DismissDirection.endToStart,
                                      onDismissed: (direction) =>
                                          _removedocial(social),
                                      confirmDismiss:
                                          (DismissDirection direction) async {
                                        return await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text("Confirm"),
                                              content: const Text(
                                                  "Are you sure you wish to delete this item?"),
                                              actions: <Widget>[
                                                TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(true),
                                                    child:
                                                        const Text("DELETE")),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(false),
                                                  child: const Text("CANCEL"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      background: Container(
                                        alignment: Alignment.centerRight,
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: _buildSocialMedia(social),
                                    )
                                // _buildSocialMedia(social),
                                ),
                          ],
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // Future<UserDetail> _fetchUserData() async {
  Widget _buildcontainer(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(10)),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkExperience(WorkExperience work) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              work.jobTitle!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              '${work.organizationName} (${work.startDate} - ${work.endDate})',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            Text(
              work.summary!,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChips(List<String> items) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: items.map((item) {
        return Chip(
          label: Text(
            item,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
        );
      }).toList(),
    );
  }

  Widget _buildEducation(Education education) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              education.level!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              '${education.organizationName} (${education.startDate} - ${education.endDate})',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            Text(
              education.summary!,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccomplishment(Accomplishments accomplishment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              accomplishment.title!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              accomplishment.description!,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMedia(SocialMedia social) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // _buildSectionTitle("Social Media"),
              GestureDetector(
                onTap: () async {
                  final Uri url = Uri.parse(social.url!);

                  await launchUrl(url);
                },
                child: Text(
                  social.title!,
                  style: const TextStyle(color: Colors.blue, fontSize: 16),
                ),
              )
            ],
          ),
        ));
  }
}
