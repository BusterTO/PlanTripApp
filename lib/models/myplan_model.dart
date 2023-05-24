import 'package:flutter/material.dart';
import 'package:plantripapp/models/post_model.dart';
import 'package:plantripapp/models/user_model.dart';

class MyPlanModel {
  final String? id;
  final String? title;
  final String? description;
  final String? image;
  final String? idUser;

  final int? totalItem;

  final UserModel? user;
  final List<PostModel>? posts;

  final int? flag;
  final int? status;
  final String? dateCreated;
  final String? dateUpdated;
  bool? isSelected;

  // id_user, title, description, image, id_post, id_city_category, is_article,
  // total_item, flag, status, date_created, date_updated

  MyPlanModel(
      {this.id,
      this.title,
      this.description,
      this.idUser,
      this.image,
      this.totalItem,
      this.user,
      this.posts,
      this.dateCreated,
      this.dateUpdated,
      this.flag = 1,
      this.status = 1,
      this.isSelected = false});

  factory MyPlanModel.fromMap(dynamic map) {
    return MyPlanModel(
        id: map['id_plan'],
        title: map['title'],
        description: map['description'],
        idUser: map['id_user'],
        image: map['image'],
        totalItem: int.parse(map['total_item'] ?? "0"),
        user: map['user'] != null ? UserModel.fromJson(map['user']) : null,
        posts: map['posts'] != null
            ? map['posts'].map<PostModel>((json) {
                return PostModel.fromMap(json);
              }).toList()
            : [],
        dateCreated: map['date_created'],
        dateUpdated: map['date_updated'],
        flag: int.parse(map['flag'] ?? "1"),
        status: int.parse(map['status'] ?? "1"));
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> dataposts = [];
    if (posts != null) {
      dataposts = posts!.map<Map<String, dynamic>>((PostModel post) {
        return post.toJson();
      }).toList();
    }

    return {
      "id_plan": id,
      "title": "$title",
      "description": "$description",
      "image": "$image",
      "total_item": "$totalItem",
      "date_created": dateCreated,
      "date_updated": dateUpdated,
      "user": user != null ? user!.toJson() : null,
      "posts": dataposts,
      "id_user": "$idUser",
      "flag": "$flag",
      "status": "$status"
    };
  }

  List<PostModel> listPlaces() {
    List<PostModel> places = [];

    try {
      places = posts!.where((element) => element.flag == 1).toList();
    } catch (e) {
      debugPrint("");
    }

    return places;
  }

  List<PostModel> listArticles() {
    List<PostModel> articles = [];

    try {
      articles = posts!.where((element) => element.flag == 2).toList();
    } catch (e) {
      debugPrint("");
    }

    return articles;
  }
}
