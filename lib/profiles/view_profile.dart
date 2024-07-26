import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  //for skills
  TextEditingController skills = TextEditingController();
  //for hobbies
  TextEditingController hobbies = TextEditingController();
  //Languages
  TextEditingController lang = TextEditingController();

  //images
  File? profile;
  File? cover;
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
    // _loadBasicInfo();
    _loadnumber();
    _loadworkexp();
    _loadeducation();
    _loadAccomplishment();
    _loadsocial();
    _loadskill();
    _loadshobbies();
    _loadlanguages();
  }

  void _loaduserDetail() async {
    UserDetail? detail = await auth.getloggedinuser();
    setState(() {
      userDetail = detail;
      //createing different method to handle images
    });
  }

  /// The function `_updateProfileImage` updates the profile image of a user in local storage and also
  /// updates the user's profile image in the app state.
  ///
  /// Args:
  ///   file (File): The `file` parameter in the `updateProfileImage` function is of type `File`, which
  /// represents a file on the device. In this context, it is likely used to update the profile image of
  /// a user. The function reads user details from a data loader, updates the profile image path in
  Future _updateProfileImage(File file) async {
    //this does this
    // Retrieves all user details using Dataloader,
    //finds the user to update, and replaces the profile image in the list of user details.
    // It then serializes and saves the updated list in SharedPreferences.

    // Updates a list of user details,
    // modifies the profile image of the matched user,
    //and saves the entire list back to SharedPreferences.

    //More complex due to fetching and updating the list of user details,
    //which may involve more processing and potential for errors.

    //Simpler and more focused approach,
    //updating only the profile image path for the logged-in user.

    //should use this method.

    final prefs = await SharedPreferences.getInstance();
    Dataloader dataloader = Dataloader();
    //Fetches a list of UserDetail objects, presumably from a local JSON file or another data source.
    List<UserDetail> userdetail = await dataloader.getuserdetail();
    //Searches for the UserDetail object in the list where the id matches the id of the current userDetail.
    UserDetail? tempUser =
        userdetail.firstWhere((element) => element.id == userDetail!.id);

    if (tempUser != null) {
      //firstly find the index of tempUser in userlst
      int indexFinder =
          userdetail.indexWhere((element) => element.id == userDetail!.id);

      //after finding the index of the tempUser(userDetail)
      // update the imagepath with the file path an turn the isnetworkurl to false
      tempUser.profileImage =
          ProfileImage(imagePath: file.path, isNetworkUrl: false);
      //removes the old userdetail
      userdetail.removeAt(indexFinder);
      //inserts the new user detail
      userdetail.insert(indexFinder, tempUser);
      //converts the updated List<UserDetail> to jsonString by encoding
      //and storing it to the shared preferences
      String profilejson = json.encode(userdetail);
      await prefs.setString(Dataloader.userdetailkey, profilejson);
    }

    if (userDetail != null) {
      //did this to make the profile in full screen persist
      //here the file path is saved at 2 keys on inside of the Dataloader.userdetailkey and other with profile key

      final userid = userDetail!.id;
      final profilekey = 'profile_$userid';
      await prefs.setString(profilekey, file.path);
      //the above code was to provide the image in ful screen
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
      final userid = userDetail!.id;
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

//no for now no need to do like the userprofile picture for now
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
    Dataloader dataLoader = Dataloader();
    List<UserDetail> userdetail = await dataLoader.getuserdetail();
    UserDetail? tempUser =
        userdetail.firstWhere((element) => element.id == userDetail!.id);

    if (tempUser != null) {
      int indexFinder =
          userdetail.indexWhere((element) => element.id == userDetail!.id);

      tempUser.basicInfo = BasicInfo(name: name, summary: summary);
      userdetail.removeAt(indexFinder);
      userdetail.insert(indexFinder, tempUser);

      String basicinfo = json.encode(userdetail);
      await prefs.setString(Dataloader.userdetailkey, basicinfo);
    }

    if (userDetail != null) {
      setState(() {
        userDetail!.basicInfo = BasicInfo(name: name, summary: summary);
      });
      await auth.saveUserDetail(userDetail!);
    }
  }

  // Future<void> _loadBasicInfo() async {
  //   final prefs = await SharedPreferences.getInstance();

  //   if (userDetail != null) {
  //     final userid = userDetail!.id;
  //     final namekey = 'name_$userid';
  //     final summarykey = 'summary_$userid';

  //     final uname = prefs.getString(namekey);
  //     final usummary = prefs.getString(summarykey);

  //     if (uname != null) {
  //       setState(() {
  //         newname = uname;
  //         userDetail!.basicInfo!.name = uname;
  //       });
  //       if (usummary != null) {
  //         setState(() {
  //           newsummary = usummary;
  //           userDetail!.basicInfo!.summary = usummary;
  //         });
  //       }
  //     }
  //   }
  // }

  // userdetail.basicInfo!.gender = gender;

  //     userdetail.basicInfo!.maritalStatus = maritalstatus;
  //     dob ??= userdetail.basicInfo!.dob;

  //     await auth.saveUserDetail(userdetail);

/*this method will only update the profile picture */
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
          child: StatefulBuilder(builder: (context, setState) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: _buildSectionTitle('Add Work Experience'),
                content: Form(
                  key: workformkey,
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      children: [
                        _texformfield(
                            job, 'Please provide your job title', 'Job Title'),
                        const SizedBox(
                          height: 15,
                        ),
                        _texformfield(jobsummary,
                            'Please provide your experience', 'Summary'),
                        const SizedBox(
                          height: 15,
                        ),
                        _texformfield(organization,
                            'Please provide your comapny name', 'Company name'),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: 60,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            trailing: const Icon(Icons.calendar_month_outlined),
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
                                  startdate =
                                      DateFormat('y-MM-dd').format(sdate!);
                                  if (edate != null &&
                                      edate!.isBefore(sdate!)) {
                                    edate = null;
                                  }
                                });
                              }
                            },
                          ),
                        ),
                        Container(
                          height: 60,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(edate == null
                                ? 'Select a date'
                                : 'Enddate ${DateFormat('y-MM-dd').format(edate!)}'),
                            trailing: const Icon(Icons.calendar_month_outlined),
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
                                  firstDate:
                                      sdate?.add(const Duration(days: 1)) ??
                                          DateTime.now(),
                                  lastDate: DateTime.now());
                              if (picker != null && picker != sdate) {
                                setState(() {
                                  edate = picker;
                                  enddate =
                                      DateFormat('y-MM-dd').format(edate!);
                                });
                              }
                            },
                          ),
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
                                  job.clear();
                                  jobsummary.clear();
                                  organization.clear();
                                  Navigator.pop(context);
                                }
                              }
                            },
                            child: const Text('Submit')),
                      ],
                    ),
                  ),
                ),
              );
            });
          }),
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
          child: StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: _buildSectionTitle('Add Education'),
              content: Form(
                key: eduformkey,
                child: Container(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    children: [
                      _texformfield(
                          edulevel, 'Please enter your gradelevel', 'Level'),
                      const SizedBox(
                        height: 15,
                      ),
                      _texformfield(edusummary,
                          'Please provide us with summary', 'Summary'),
                      const SizedBox(
                        height: 15,
                      ),
                      _texformfield(
                          eduorganization,
                          'Please Provide institution name',
                          'College/School name'),
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          trailing: const Icon(Icons.calendar_month_outlined),
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
                      ),
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          trailing: const Icon(Icons.calendar_month_outlined),
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
                                firstDate:
                                    edusdate?.add(const Duration(days: 1)) ??
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
                                edulevel.clear();
                                eduorganization.clear();
                                edusummary.clear();
                                //left
                                Navigator.pop(context);
                              }
                            }
                          },
                          child: const Text('Submit')),
                    ],
                  ),
                ),
              ),
            );
          }),
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
                    _texformfield(accomtitle,
                        'Please mention your Accoplishment', 'Accomplishment'),
                    const SizedBox(
                      height: 15,
                    ),
                    _texformfield(
                        accomdescrip,
                        'Provide details about of the Accomplishment',
                        'Description'),
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
      final mediakey = 'media_$userid';

      final mediajson = prefs.getString(mediakey);

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
            title: const Text('Add Social media'),
            content: Form(
              key: socialkey,
              child: Column(
                children: [
                  _texformfield(platform, 'Provide platform', 'Platform'),
                  const SizedBox(
                    height: 15,
                  ),
                  _texformfield(link, 'Provide link ', 'Link'),
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
                            platform.clear();
                            link.clear();
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

  Future<void> _updateskills(List<Skills> skill) async {
    final prefs = await SharedPreferences.getInstance();
    if (userDetail != null) {
      final userid = userDetail!.id;
      final skillkey = 'skill_$userid';
      final skilljson = skill.map((e) => e.toJson()).toList();

      await prefs.setString(skillkey, jsonEncode(skilljson));

      setState(() {
        userDetail!.skills = skill;
      });
      await auth.saveUserDetail(userDetail!);
    }
  }

  Future<void> _loadskill() async {
    final prefs = await SharedPreferences.getInstance();

    if (userDetail != null) {
      final userid = userDetail!.id;
      final skillkey = 'skill_$userid';
      final skilljson = prefs.getString(skillkey);

      if (skilljson != null) {
        final List jsonlist = jsonDecode(skilljson);
        final skillist = jsonlist.map((e) => Skills.fromJson(e)).toList();

        setState(() {
          userDetail!.skills = skillist;
        });
      }
    }
  }

  void _removeskill(Skills skill) async {
    if (userDetail != null) {
      final updatelist = List<Skills>.from(userDetail!.skills ?? []);
      updatelist.remove(skill);
      _updateskills(updatelist);
    }
  }

  Future<void> _updatehobbies(List<Hobbies> hobby) async {
    final prefs = await SharedPreferences.getInstance();
    if (userDetail != null) {
      final userid = userDetail!.id;
      final hobbykey = 'hobby_$userid';
      final hobbyjson = hobby.map((e) => e.toJson()).toList();

      await prefs.setString(hobbykey, jsonEncode(hobbyjson));

      setState(() {
        userDetail!.hobbies = hobby;
      });
      await auth.saveUserDetail(userDetail!);
    }
  }

  Future<void> _loadshobbies() async {
    final prefs = await SharedPreferences.getInstance();

    if (userDetail != null) {
      final userid = userDetail!.id;
      final hobbykey = 'hobby_$userid';
      final hobbyjson = prefs.getString(hobbykey);

      if (hobbyjson != null) {
        final List jsonlist = jsonDecode(hobbyjson);
        final hobbylist = jsonlist.map((e) => Hobbies.fromJson(e)).toList();

        setState(() {
          userDetail!.hobbies = hobbylist;
        });
      }
    }
  }

  void _removeshobbies(Hobbies hobby) async {
    if (userDetail != null) {
      final updatelist = List<Hobbies>.from(userDetail!.hobbies ?? []);
      updatelist.remove(hobby);
      _updatehobbies(updatelist);
    }
  }

  Future<void> _updateLanguages(List<Languages> lang) async {
    final prefs = await SharedPreferences.getInstance();
    if (userDetail != null) {
      final userid = userDetail!.id;
      final langkey = 'lang_$userid';
      final langjson = lang.map((e) => e.toJson()).toList();

      await prefs.setString(langkey, jsonEncode(langjson));

      setState(() {
        userDetail!.languages = lang;
      });
      await auth.saveUserDetail(userDetail!);
    }
  }

  Future<void> _loadlanguages() async {
    final prefs = await SharedPreferences.getInstance();

    if (userDetail != null) {
      final userid = userDetail!.id;
      final langkey = 'lang_$userid';
      final langjson = prefs.getString(langkey);

      if (langjson != null) {
        final List jsonlist = jsonDecode(langjson);
        final langlist = jsonlist.map((e) => Languages.fromJson(e)).toList();

        setState(() {
          userDetail!.languages = langlist;
        });
      }
    }
  }

  void _removelanguages(Languages lang) async {
    if (userDetail != null) {
      final updatelist = List<Languages>.from(userDetail!.languages ?? []);
      updatelist.remove(lang);
      _updateLanguages(updatelist);
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
      body: userDetail == null //checked whether any user is logged

          ? const Center(
              child: Text('No user logged in'),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 230,
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
                          left: 5,
                          bottom: 0,
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
                              child: (userDetail?.profileImage?.isNetworkUrl ??
                                      false)
                                  ? CircleAvatar(
                                      radius: 80,
                                      backgroundImage: NetworkImage(
                                          userDetail!.profileImage!.imagePath!))
                                  : CircleAvatar(
                                      radius: 80,
                                      backgroundImage: FileImage(File(
                                          userDetail?.profileImage?.imagePath ??
                                              '')),
                                    )

                              // CircleAvatar(
                              //   radius: 70,

                              //   //here i created a fun only beacuse it was giving error for type
                              //   // circlavatare's backgroundinage needs imageprovider
                              //   backgroundImage: _getprofileimage(),
                              // ),
                              ),
                        ),
                        Positioned(
                          right: 235,
                          top: 185,
                          child: GestureDetector(
                            onTap: () {
                              print('profile');
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return AlertDialog(
                                      title:
                                          const Text('Choose profile Picture'),
                                      actions: [
                                        TextButton(
                                            onPressed: () async {
                                              final picked =
                                                  await picker.pickImage(
                                                      source:
                                                          ImageSource.camera);

                                              if (picked != null) {
                                                /// The above Dart code is creating a `File` object using
                                                /// the `File` constructor and passing the `path` property
                                                /// of a variable named `picked` as an argument. This code
                                                /// is typically used to work with files in Dart, allowing
                                                /// you to perform operations such as reading, writing,
                                                /// and manipulating files.
                                                final file = File(picked.path);

                                                /// The above Dart code snippet is assigning the value of
                                                /// `picked.path` to the variable `path`.
                                                final path = picked.path;
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
                                  });
                                },
                              );
                            },
                            child: const CircleAvatar(
                              radius: 16,
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
                            top: 155,
                            child: GestureDetector(
                              onTap: () {
                                print('Choose cover');
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                      return AlertDialog(
                                        title:
                                            const Text('Choose cover Picture'),
                                        actions: [
                                          TextButton(
                                            onPressed: () async {
                                              final picked =
                                                  await picker.pickImage(
                                                      source:
                                                          ImageSource.camera);

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
                                            child: const Text(
                                                'Choose from Gallery'),
                                          ),
                                        ],
                                      );
                                    });
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
                                    title: const Text('Your Detail'),
                                    content: Form(
                                      key: basicinfokey,
                                      child: SizedBox(
                                        height: 200,
                                        child: Column(
                                          children: [
                                            _texformfield(
                                                updatename,
                                                'Please enter your name',
                                                'Your name'),
                                            const SizedBox(
                                              height: 15,
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
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
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
                                    ),
                                    actions: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                          updatename.clear();
                                          updatesumary.clear();
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
                                            setState(() {
                                              updatename.clear();
                                              updatesumary.clear();
                                            });
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
                                          return StatefulBuilder(
                                            builder: (context, setState) {
                                              return AlertDialog(
                                                title: _buildSectionTitle(
                                                    'Update your BasicInfo!'),
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
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  const BorderSide(
                                                                      color: Colors
                                                                          .white),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            filled: true,
                                                            fillColor:
                                                                const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    241,
                                                                    240,
                                                                    240),
                                                          ),
                                                          hint: const Text(
                                                              'Gender'),
                                                          value: newgender,
                                                          items: const [
                                                            DropdownMenuItem(
                                                              value: 'Male',
                                                              child:
                                                                  Text('Male'),
                                                            ),
                                                            DropdownMenuItem(
                                                              value: 'Female',
                                                              child: Text(
                                                                  'Female'),
                                                            )
                                                          ],
                                                          onChanged: (value) {
                                                            setState(() {
                                                              newgender = value;
                                                            });
                                                          },
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
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
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  const BorderSide(
                                                                      color: Colors
                                                                          .white),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            filled: true,
                                                            fillColor:
                                                                const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    241,
                                                                    240,
                                                                    240),
                                                          ),
                                                          hint: const Text(
                                                              'Marital Status'),
                                                          value:
                                                              newmaritalstatus,
                                                          items: const [
                                                            DropdownMenuItem(
                                                              value: 'Single',
                                                              child: Text(
                                                                  'Single'),
                                                            ),
                                                            DropdownMenuItem(
                                                              value: 'Married',
                                                              child: Text(
                                                                  'Married'),
                                                            ),
                                                            DropdownMenuItem(
                                                              value: 'Divorce',
                                                              child: Text(
                                                                  'Divorce'),
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
                                                          decoration:
                                                              BoxDecoration(
                                                            border:
                                                                Border.all(),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: ListTile(
                                                            trailing:
                                                                const Icon(Icons
                                                                    .calendar_month_outlined),
                                                            title: Text(dob ==
                                                                    null
                                                                ? "Select Date of Birth"
                                                                : 'DOB: ${DateFormat('y-MM-dd').format(dob!)}'),
                                                            onTap: () async {
                                                              DateTime? picked = await showDatePicker(
                                                                  context:
                                                                      context,
                                                                  firstDate:
                                                                      DateTime(
                                                                          1900),
                                                                  lastDate:
                                                                      DateTime
                                                                          .now());
                                                              if (picked !=
                                                                      null &&
                                                                  picked !=
                                                                      dob) {
                                                                setState(() {
                                                                  dob = picked;
                                                                  newdate = DateFormat(
                                                                          'y-MM-dd')
                                                                      .format(
                                                                          dob!);
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
                                                          const EdgeInsets.all(
                                                              10),
                                                      decoration: BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            10,
                                                          )),
                                                      child: const Text(
                                                        'Cancel',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      if (statuskey
                                                          .currentState!
                                                          .validate()) {
                                                        setState(() {
                                                          _updateStatus(
                                                              newmaritalstatus!,
                                                              newdate,
                                                              newgender!);
                                                        });

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
                                                          const EdgeInsets.all(
                                                              10),
                                                      decoration: BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            10,
                                                          )),
                                                      child: const Text(
                                                        'Save',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
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
                                  // key: Key(work.id.toString() ?? ''),
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
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Add Skills'),
                                            content: TextFormField(
                                              controller: skills,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(
                                                  RegExp(r'[A-za-z _]'),
                                                ),
                                              ],
                                              maxLength: 20,
                                              decoration: const InputDecoration(
                                                enabledBorder:
                                                    OutlineInputBorder(),
                                                focusedBorder:
                                                    OutlineInputBorder(),
                                                labelText: 'Skills',
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please provide skills';
                                                }
                                                return null;
                                              },
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text('Cancel')),
                                              TextButton(
                                                  onPressed: () {
                                                    if (skills
                                                        .text.isNotEmpty) {
                                                      final newskill = Skills(
                                                          title: skills.text);
                                                      final updatelist =
                                                          List<Skills>.from(
                                                              userDetail!
                                                                      .skills ??
                                                                  []);
                                                      updatelist.add(newskill);
                                                      _updateskills(updatelist);
                                                      setState(() {
                                                        skills.clear();
                                                      });
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  child: const Text('Submit'))
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
                              Wrap(
                                children: [
                                  ...userDetail!.skills!
                                      .map((e) => _buildSkills(e))
                                ],
                              ),
                              // const SizedBox(height: 16),

                              // _buildChips(userDetail!.skills!
                              //     .map((skill) => skill.title!)
                              //     .toList()),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildSectionTitle('Hobbies'),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Add Hobbies'),
                                            content: TextFormField(
                                              controller: hobbies,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(
                                                  RegExp(r'[A-za-z _]'),
                                                ),
                                              ],
                                              maxLength: 20,
                                              decoration: const InputDecoration(
                                                enabledBorder:
                                                    OutlineInputBorder(),
                                                focusedBorder:
                                                    OutlineInputBorder(),
                                                labelText: 'Hobbies',
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please provide your Hobbies';
                                                }
                                                return null;
                                              },
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text('Cancel')),
                                              TextButton(
                                                  onPressed: () {
                                                    if (hobbies
                                                        .text.isNotEmpty) {
                                                      final newhobby = Hobbies(
                                                          title: hobbies.text);
                                                      final updatelist = List<
                                                              Hobbies>.from(
                                                          userDetail!.hobbies ??
                                                              []);
                                                      updatelist.add(newhobby);
                                                      _updatehobbies(
                                                          updatelist);
                                                      hobbies.clear();
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  child: const Text('Submit'))
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
                              Wrap(
                                children: [
                                  ...userDetail!.hobbies!
                                      .map((e) => _buildHobbies(e))
                                ],
                              ),

                              // _buildChips(userDetail!.hobbies!
                              //     .map((hobby) => hobby.title!)
                              //     .toList()),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildSectionTitle('Languages'),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Add Languages'),
                                            content: TextFormField(
                                              controller: lang,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(
                                                  RegExp(r'[A-za-z _]'),
                                                ),
                                              ],
                                              maxLength: 20,
                                              decoration: const InputDecoration(
                                                enabledBorder:
                                                    OutlineInputBorder(),
                                                focusedBorder:
                                                    OutlineInputBorder(),
                                                labelText: 'Languages',
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please provide Languages you speak';
                                                }
                                                return null;
                                              },
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text('Cancel')),
                                              TextButton(
                                                  onPressed: () {
                                                    if (lang.text.isNotEmpty) {
                                                      final newlang = Languages(
                                                          title: lang.text);
                                                      final updatelist = List<
                                                              Languages>.from(
                                                          userDetail!
                                                                  .languages ??
                                                              []);
                                                      updatelist.add(newlang);
                                                      _updateLanguages(
                                                          updatelist);
                                                      lang.clear();
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  child: const Text('Submit'))
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
                              Wrap(
                                children: [
                                  ...userDetail!.languages!
                                      .map((e) => _buildLanguages(e))
                                ],
                              ),
                              // _buildChips(userDetail!.languages!
                              //     .map((lang) => lang.title!)
                              //     .toList()),
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

  // Widget _buildChips(
  //   List<String> items,
  // ) {
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

  Widget _buildSkills(Skills skill) {
    return Chip(
      backgroundColor: Colors.black,
      deleteIcon: const Icon(
        Icons.cancel,
        color: Colors.white,
        size: 15,
      ),
      deleteButtonTooltipMessage: 'Delete',
      label: Text(
        skill.title!,
        style: const TextStyle(color: Colors.white),
      ),
      onDeleted: () => _removeskill(skill),
    );
  }

  Widget _buildHobbies(Hobbies hobby) {
    return Chip(
      backgroundColor: Colors.black,
      deleteIcon: const Icon(
        Icons.cancel,
        color: Colors.white,
        size: 15,
      ),
      deleteButtonTooltipMessage: 'Delete',
      label: Text(
        hobby.title!,
        style: const TextStyle(color: Colors.white),
      ),
      onDeleted: () => _removeshobbies(hobby),
    );
  }

  Widget _buildLanguages(Languages lang) {
    return Chip(
      backgroundColor: Colors.black,
      deleteIcon: const Icon(
        Icons.cancel,
        color: Colors.white,
        size: 15,
      ),
      deleteButtonTooltipMessage: 'Delete',
      label: Text(
        lang.title!,
        style: const TextStyle(color: Colors.white),
      ),
      onDeleted: () => _removelanguages(lang),
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
      ),
    );
  }

  Widget _texformfield(TextEditingController control, String text, String label,
      [int? length]) {
    return TextFormField(
      controller: control,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.person),
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
      maxLength: length,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return text;
        }
        return null;
      },
    );
  }
}
