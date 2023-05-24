import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plantripapp/models/comment_model.dart';
import 'package:plantripapp/models/user_model.dart';
import 'package:plantripapp/pages/result_search_page.dart';
import 'package:plantripapp/theme.dart';

List<PostModel> postModelFromJson(String str) =>
    List<PostModel>.from(jsonDecode(str).map((x) => PostModel.fromMap(x)));

String postModelToJson(List<PostModel> data) =>
    jsonEncode(List<dynamic>.from(data.map((x) => x.toJson())));

class PostModel {
  final String? id;
  final String? title;
  final String? desc;

  final String? idUser;
  final String? idCategory;
  final String? nmCategory;
  final String? idCity;
  final String? nmCity;
  final UserModel? user;

  final List<UserModel>? otherUsers;
  final List<CommentModel>? comments;

  final String? image1;
  final String? image2;
  final String? image3;
  final String? image4;
  final String? video1;
  final String? audio1;

  final String? file;
  final double? sizeFile;

  final String? tag;
  final int? liked;

  final String? latitude;
  final String? location;

  final int? totalLike;
  final int? totalRating;
  final int? totalShare;

  final int? totalComment;
  final int? totalView;
  final int? totalReport;
  final int? totalUser;

  final double? rating;
  final double? distance;
  final String? createAt;
  final String? updateAt;
  final int? flag;
  final int? status;

  PostModel(
      {this.id,
      this.title,
      this.desc,
      this.user,
      this.otherUsers,
      this.comments,
      this.latitude,
      this.location,
      this.idUser,
      this.idCategory,
      this.nmCategory,
      this.idCity,
      this.nmCity,
      this.image1,
      this.image2,
      this.image3,
      this.image4,
      this.video1,
      this.audio1,
      this.tag,
      this.liked,
      this.totalLike = 0,
      this.totalRating = 0,
      this.totalShare = 0,
      this.totalComment = 0,
      this.totalReport = 0,
      this.totalView = 0,
      this.totalUser = 0,
      this.rating = 0.0,
      this.distance = 0.0,
      this.sizeFile = 0.0,
      this.file,
      this.createAt,
      this.updateAt,
      this.flag = 1,
      this.status = 1});

  factory PostModel.fromMap(dynamic map) {
    return PostModel(
        id: map['id_post'],
        title: map['title'],
        desc: map['description'],
        user: map['user'] != null ? UserModel.fromJson(map['user']) : null,
        otherUsers: map['other_users'] != null
            ? map['other_users'].map<UserModel>((json) {
                return UserModel.fromJson(json);
              }).toList()
            : [],
        comments: map['comments'] != null
            ? map['comments'].map<CommentModel>((json) {
                return CommentModel.fromMap(json);
              }).toList()
            : [],
        image1: map['image1'],
        image2: map['image2'],
        image3: map['image3'],
        image4: map['image4'],
        video1: map['video1'],
        audio1: map['audio1'],
        tag: map['tag'],
        idUser: map['id_user'],
        idCategory: map['id_category'],
        nmCategory: map['nm_category'],
        idCity: map['id_city'],
        nmCity: map['nm_city'],
        latitude: map['latitude'],
        location: map['location'],
        liked: int.parse(map['is_liked'] ?? "0"),
        totalLike: int.parse(map['total_like'] ?? "0"),
        totalRating: int.parse(map['total_rating'] ?? "0"),
        totalShare: int.parse(map['total_share'] ?? "0"),
        totalComment: int.parse(map['total_comment'] ?? "0"),
        totalView: int.parse(map['total_view'] ?? "0"),
        totalReport: int.parse(map['total_report'] ?? "0"),
        totalUser: int.parse(map['total_user'] ?? "0"),
        rating: double.parse(map['rating'] ?? "0.0"),
        distance: map['distance'] != null && map['distance'] > 0
            ? map['distance']
            : 0.0,
        sizeFile: double.parse(map['size_file'] ?? "0.0"),
        file: map['data_file'] ?? "",
        createAt: map['date_created'],
        updateAt: map['date_updated'],
        flag: int.parse(map['flag'] ?? "1"),
        status: int.parse(map['status'] ?? "1"));
  }

  /*setLiked(final int _liked) {
    liked = _liked;
  }*/

  Map<String, dynamic> toJson() {
    //other user
    List<Map<String, dynamic>> dataotherUsers = [];
    if (otherUsers != null) {
      dataotherUsers = otherUsers!.map<Map<String, dynamic>>((UserModel user) {
        return user.toJson();
      }).toList();
    }

    List<Map<String, dynamic>> datacomments = [];
    if (comments != null) {
      datacomments =
          comments!.map<Map<String, dynamic>>((CommentModel comment) {
        return comment.toJson();
      }).toList();
    }

    return {
      "id_post": id,
      "title": title,
      "description": desc,
      "image1": image1,
      "image2": image2,
      "image3": image3,
      "image4": image4,
      "latitude": latitude,
      "location": location,
      "id_category": "$idCategory",
      "nm_category": "$nmCategory",
      "id_city": "$idCity",
      "nm_city": "$nmCity",
      "id_user": "$idUser",
      "liked": "$liked",
      "date_created": createAt,
      "date_updated": updateAt,
      "status": "$status",
      "flag": "$flag",
      "rating": "$rating",
      "distance": distance,
      "data_file": "$file",
      "size_file": "$sizeFile",
      "total_share": "$totalShare",
      "total_like": "$totalLike",
      "total_comment": "$totalComment",
      "total_user": "$totalUser",
      "total_rating": "$totalRating",
      "total_view": "$totalView",
      "total_report": "$totalReport",
      "user": user != null ? user!.toJson() : null,
      "other_users": dataotherUsers,
      "comments": datacomments
    };
  }

  List<String> listImages() {
    List<String> images = [];

    if (image1 != null && image1!.isNotEmpty) {
      images.add(image1!);
    }
    if (image2 != null && image2!.isNotEmpty) {
      images.add(image2!);
    }
    if (image3 != null && image3!.isNotEmpty) {
      images.add(image3!);
    }
    if (image4 != null && image4!.isNotEmpty) {
      images.add(image4!);
    }

    return images;
  }

  List<dynamic> listObjectImages() {
    List<dynamic> images = [];

    if (image1 != null && image1!.isNotEmpty) {
      images.add({"image": image1});
    }
    if (image2 != null && image2!.isNotEmpty) {
      images.add({"image": image2});
    }
    if (image3 != null && image3!.isNotEmpty) {
      images.add({"image": image3});
    }
    if (image4 != null && image4!.isNotEmpty) {
      images.add({"image": image4});
    }

    return images;
  }

  String getHashtagNew() {
    String res = "";

    if (tag != null && tag!.isNotEmpty) {
      var splits = tag!.split(",");
      for (var element in splits.reversed) {
        res = "#${element.trim().toLowerCase()} $res";
      }
    }

    return res;
  }

  String getDefaultImage() => "assets/back_preview.jpg";

  String getDistance() {
    try {
      if (distance == 0) {
        return "";
      } else {
        return "  (${NumberFormat.compact().format(distance!)} Km)";
      }
    } catch (e) {
      return " (0 Km)";
    }
  }

  String getSizeFile() {
    try {
      if (sizeFile == 0) {
        return "";
      } else {
        return "$sizeFile Mb";
      }
    } catch (e) {
      return "";
    }
  }

  List<CommentModel> topThreeComments() {
    List<CommentModel> comms = [];

    if (comments != null && comments!.isNotEmpty) {
      for (var i = 0; i < comments!.length; i++) {
        if (i == 3) break;
        comms.add(comments![i]);
      }
    }

    return comms;
  }

  double getRating() {
    return double.parse(rating!.toStringAsFixed(2));
  }

  Widget richTextHashtag() {
    List<TextSpan> textSpans = <TextSpan>[];

    if (tag != null && tag!.isNotEmpty) {
      var splits = tag!.split(",");
      for (var element in splits.reversed) {
        String text = "#${element.trim().toLowerCase()} ";
        textSpans.add(TextSpan(
            text: text,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.to(ResultSearchPage(query: element.trim().toLowerCase()),
                    transition: Transition.cupertino);
              }));
      }
    }

    return RichText(
      text: TextSpan(
        style: textNormal.copyWith(
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode
              ? Get.theme.primaryColorLight
              : Get.theme.primaryColor,
          fontFamily: fontFamily,
        ),
        children: textSpans,
      ),
    );
  }
}
