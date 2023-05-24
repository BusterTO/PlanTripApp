import 'package:plantripapp/models/city_category_model.dart';
import 'package:plantripapp/models/post_model.dart';
import 'package:plantripapp/models/user_model.dart';

class NotifModel {
  final String? id;
  final String? title;
  final String? description;
  final String? idPost;
  final String? idUser;

  final UserModel? user;
  final PostModel? post;
  final CityCategoryModel? cityCateg;

  final String? idCityCategory;
  final String? image;

  final int? flag;
  final int? status;
  final String? dateCreated;
  final String? dateUpdated;

  NotifModel(
      {this.id,
      this.title,
      this.description,
      this.idUser,
      this.idCityCategory,
      this.image,
      this.user,
      this.post,
      this.cityCateg,
      this.idPost,
      this.dateCreated,
      this.dateUpdated,
      this.flag = 1,
      this.status = 1});

  //id_notif, title_notif, desc_notif, id_user, id_city_category, id_post, image, date_created	, date_updated, flag, status

  factory NotifModel.fromMap(dynamic map) {
    return NotifModel(
        id: map['id_notif'],
        title: map['title_notif'],
        description: map['desc_notif'],
        idUser: map['id_user'],
        image: map['image'],
        idPost: map['id_post'],
        idCityCategory: map['id_city_category'],
        user: map['user'] != null ? UserModel.fromJson(map['user']) : null,
        post: map['post'] != null ? PostModel.fromMap(map['post']) : null,
        cityCateg: map['city_category'] != null
            ? CityCategoryModel.fromMap(map['city_category'])
            : null,
        dateCreated: map['date_created'],
        dateUpdated: map['date_updated'],
        flag: int.parse(map['flag'] ?? "1"),
        status: int.parse(map['status'] ?? "1"));
  }

  Map<String, dynamic> toJson() {
    return {
      "id_notif": "$id",
      "title_notif": "$title",
      "desc_notif": "$description",
      "id_city_category": "$idCityCategory",
      "image": "$image",
      "date_created": dateCreated,
      "date_updated": dateUpdated,
      "user": user != null ? user!.toJson() : null,
      "post": post != null ? post!.toJson() : null,
      "city_category": cityCateg != null ? cityCateg!.toJson() : null,
      "id_user": "$idUser",
      "id_post": "$idPost",
      "flag": "$flag",
      "status": "$status"
    };
  }
}
