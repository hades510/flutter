import 'dart:typed_data';

import 'package:flutter/material.dart';

class UserDetail {
  int? id;
  BasicInfo? basicInfo;
  ProfileImage? profileImage;
  ProfileImage? coverImage;
  List<WorkExperience>? workExperience;
  List<Skills>? skills;
  List<Hobbies>? hobbies;
  List<Languages>? languages;
  String? status;
  List<Education>? education;
  List<Accomplishments>? accomplishments;
  ContactInfo? contactInfo;

  UserDetail(
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

  UserDetail.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    basicInfo = json['BasicInfo'] != null
        ? BasicInfo.fromJson(json['BasicInfo'])
        : null;
    profileImage = json['ProfileImage'] != null
        ? ProfileImage.fromJson(json['ProfileImage'])
        : null;
    coverImage = json['CoverImage'] != null
        ? ProfileImage.fromJson(json['CoverImage'])
        : null;
    if (json['WorkExperience'] != null) {
      workExperience = <WorkExperience>[];
      json['WorkExperience'].forEach((v) {
        workExperience!.add(WorkExperience.fromJson(v));
      });
    }
    if (json['Skills'] != null) {
      skills = <Skills>[];
      json['Skills'].forEach((v) {
        skills!.add(Skills.fromJson(v));
      });
    }
    if (json['Hobbies'] != null) {
      hobbies = <Hobbies>[];
      json['Hobbies'].forEach((v) {
        hobbies!.add(Hobbies.fromJson(v));
      });
    }
    if (json['Languages'] != null) {
      languages = <Languages>[];
      json['Languages'].forEach((v) {
        languages!.add(Languages.fromJson(v));
      });
    }
    status = json['Status'];
    if (json['Education'] != null) {
      education = <Education>[];
      json['Education'].forEach((v) {
        education!.add(Education.fromJson(v));
      });
    }
    if (json['Accomplishments'] != null) {
      accomplishments = <Accomplishments>[];
      json['Accomplishments'].forEach((v) {
        accomplishments!.add(Accomplishments.fromJson(v));
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
      data['WorkExperience'] =
          workExperience!.map((v) => v.toJson()).toList();
    }
    if (skills != null) {
      data['Skills'] = skills!.map((v) => v.toJson()).toList();
    }
    if (hobbies != null) {
      data['Hobbies'] = hobbies!.map((v) => v.toJson()).toList();
    }
    if (languages != null) {
      data['Languages'] = languages!.map((v) => v.toJson()).toList();
    }
    data['Status'] = status;
    if (education != null) {
      data['Education'] = education!.map((v) => v.toJson()).toList();
    }
    if (accomplishments != null) {
      data['Accomplishments'] =
          accomplishments!.map((v) => v.toJson()).toList();
    }
    if (contactInfo != null) {
      data['ContactInfo'] = contactInfo!.toJson();
    }
    return data;
  }
  // ImageProvider getprofileimage() {
  //   Uint8List bytes = base
  // }
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
      json['Social Media'].forEach((v) {
        socialMedia!.add(SocialMedia.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Mobile No'] = mobileNo;
    if (socialMedia != null) {
      data['Social Media'] = socialMedia!.map((v) => v.toJson()).toList();
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
