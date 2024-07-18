import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class UserDetailModel {
  int? id;
  BasicInfo? basicInfo;
  ProfileImage? profileImage;
  CoverImage? coverImage;
  List<WorkExperience>? workExperience;
  List<Skills>? skills;
  List<Hobbies>? hobbies;
  List<Languages>? languages;
  String? status;
  List<Education>? education;
  List<Accomplishments>? accomplishments;
  ContactInfo? contactInfo;

  UserDetailModel(
      {this.id,
      this.basicInfo,
      this.profileImage,
      this.coverImage,
      this.workExperience,
      this.skills,
      this.hobbies,
      this.languages,
      this.status,
      this.education,
      this.accomplishments,
      this.contactInfo});

  UserDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    basicInfo = json['BasicInfo'] != null
        ? BasicInfo.fromJson(json['BasicInfo'])
        : null;
    profileImage = json['ProfileImage'] != null
        ? ProfileImage.fromJson(json['ProfileImage'])
        : null;
    coverImage = json['CoverImage'] != null
        ? CoverImage.fromJson(json['CoverImage'])
        : null;
    if (json['WorkExperience'] != null) {
      workExperience = <WorkExperience>[];
      json['WorkExperience'].forEach((e) {
        workExperience!.add(WorkExperience.fromJson(e));
      });
    }
    if (json['Skills'] != null) {
      skills = <Skills>[];
      json['Skills'].forEach((e) {
        skills!.add(Skills.fromJson(e));
      });
    }
    if (json['Hobbies'] != null) {
      hobbies = <Hobbies>[];
      json['Hobbies'].forEach((e) {
        hobbies!.add(Hobbies.fromJson(e));
      });
    }
    if (json['Languages'] != null) {
      languages = <Languages>[];
      json['Languages'].forEach((e) {
        languages!.add(Languages.fromJson(e));
      });
    }
    status = json['Status'];
    if (json['Education'] != null) {
      education = <Education>[];
      json['Education'].forEach((e) {
        education!.add(Education.fromJson(e));
      });
    }
    if (json['Accomplishments'] != null) {
      accomplishments = <Accomplishments>[];
      json['Accomplishments'].forEach((e) {
        accomplishments!.add(Accomplishments.fromJson(e));
      });
    }
    contactInfo = json['ContactInfo'] != null
        ? ContactInfo.fromJson(json['ContactInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    if (basicInfo != null) {
      data['BasicInfo'] = basicInfo!.toJson();
    }
    if (profileImage != null) {
      data['ProfileImage'] = profileImage!.toJson();
    }
    if (coverImage != null) {
      data['CoverImage'] = coverImage!.toJson();
    }
    if (workExperience != null) {
      data['WorkExperience'] = workExperience!.map((e) => e.toJson()).toList();
    }
    if (skills != null) {
      data['Skills'] = skills!.map((e) => e.toJson()).toList();
    }
    if (hobbies != null) {
      data['Hobbies'] = hobbies!.map((e) => e.toJson()).toList();
    }
    if (languages != null) {
      data['Languages'] = languages!.map((e) => e.toJson()).toList();
    }
    data['Status'] = status;
    if (education != null) {
      data['Education'] = education!.map((e) => e.toJson()).toList();
    }
    if (accomplishments != null) {
      data['Accomplishments'] =
          accomplishments!.map((e) => e.toJson()).toList();
    }
    if (contactInfo != null) {
      data['ContactInfo'] = contactInfo!.toJson();
    }
    return data;
  }
}

class BasicInfo {
  String? name;
  String? summary;
  String? gender;
  String? dob;
  String? maritalStatus;

  BasicInfo(
      {this.name, this.summary, this.gender, this.dob, this.maritalStatus});

  BasicInfo.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    summary = json['Summary'];
    gender = json['Gender'];
    dob = json['Dob'];
    maritalStatus = json['Marital Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Name'] = name;
    data['Summary'] = summary;
    data['Gender'] = gender;
    data['Dob'] = dob;
    data['Marital Status'] = maritalStatus;
    return data;
  }
}

class ProfileImage {
  bool? isNetworkUrl;
  String? imagePath;

  ProfileImage({this.isNetworkUrl, this.imagePath});

  ProfileImage.fromJson(Map<String, dynamic> json) {
    isNetworkUrl = json['Is_network_url'];
    imagePath = json['image_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Is_network_url'] = isNetworkUrl;
    data['image_path'] = imagePath;
    return data;
  }

  ImageProvider getprofileimage() {
    if (imagePath != null) {
      Uint8List bytes = base64Decode(imagePath!);
      return MemoryImage(bytes);
    } else {
      return const AssetImage('assets/images/test.jpg');
    }
  }
}

class CoverImage {
  bool? isNetworkUrl;
  String? imagepath;
  CoverImage({this.imagepath, this.isNetworkUrl});

  CoverImage.fromJson(Map<String, dynamic> json) {
    isNetworkUrl = json['Is_network_url'];
    imagepath = json['image_path'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Is_network_url'] = isNetworkUrl;
    data['image_path'] = imagepath;
    return data;
  }

  // ImageProvider getcoverImage() {
  //   if (imagepath != null) {
  //     Uint8List bytes = base64Decode(imagepath!);
  //     return MemoryImage(bytes);
  //   } else {
  //     return const AssetImage('assets/images/test.jpg');
  //   }
  // }
}

class WorkExperience {
  int? id;
  String? jobTitle;
  String? summary;
  String? organizationName;
  String? startDate;
  String? endDate;

  WorkExperience(
      {this.id,
      this.jobTitle,
      this.summary,
      this.organizationName,
      this.startDate,
      this.endDate});

  WorkExperience.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    jobTitle = json['Job_title'];
    summary = json['Summary'];
    organizationName = json['Organization Name'];
    startDate = json['Start Date'];
    endDate = json['End date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Job_title'] = jobTitle;
    data['Summary'] = summary;
    data['Organization Name'] = organizationName;
    data['Start Date'] = startDate;
    data['End date'] = endDate;
    return data;
  }
}

class Skills {
  int? id;
  String? title;

  Skills({this.id, this.title});

  Skills.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    title = json['Title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Title'] = title;
    return data;
  }
}

class Languages {
  int? id;
  String? title;
  Languages({this.id, this.title});

  Languages.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    title = json['Title'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Title'] = title;
    return data;
  }
}

class Hobbies {
  int? id;
  String? title;
  Hobbies.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    title = json['Title'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Title'] = title;
    return data;
  }
}

class Education {
  int? id;
  String? level;
  String? summary;
  String? organizationName;
  String? startDate;
  String? endDate;

  Education(
      {this.id,
      this.level,
      this.summary,
      this.organizationName,
      this.startDate,
      this.endDate});

  Education.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    level = json['level'];
    summary = json['Summary'];
    organizationName = json['Organization Name'];
    startDate = json['Start Date'];
    endDate = json['End date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['level'] = level;
    data['Summary'] = summary;
    data['Organization Name'] = organizationName;
    data['Start Date'] = startDate;
    data['End date'] = endDate;
    return data;
  }
}

class Accomplishments {
  int? id;
  String? title;
  String? description;
  String? date;

  Accomplishments({this.id, this.title, this.description, this.date});

  Accomplishments.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    title = json['Title'];
    description = json['Description'];
    date = json['Date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Title'] = title;
    data['Description'] = description;
    data['Date'] = date;
    return data;
  }
}

class ContactInfo {
  String? mobileNo;
  List<SocialMedia>? socialMedia;

  ContactInfo({this.mobileNo, this.socialMedia});

  ContactInfo.fromJson(Map<String, dynamic> json) {
    mobileNo = json['Mobile No'];
    if (json['Social Media'] != null) {
      socialMedia = <SocialMedia>[];
      json['Social Media'].forEach((e) {
        socialMedia!.add(SocialMedia.fromJson(e));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Mobile No'] = mobileNo;
    if (socialMedia != null) {
      data['Social Media'] = socialMedia!.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class SocialMedia {
  int? id;
  String? title;
  String? url;
  String? type;

  SocialMedia({this.id, this.title, this.url, this.type});

  SocialMedia.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    title = json['Title'];
    url = json['Url'];
    type = json['Type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Title'] = title;
    data['Url'] = url;
    data['Type'] = type;
    return data;
  }
}
