import 'package:plantripapp/models/user_model.dart';
import 'package:plantripapp/theme.dart';

class CommentModel {
  final String? id;
  final String? idPost;
  final String? idCityCategory;
  final String? idUser;
  final String? title;
  final String? comment;
  final String? latitude;
  final int? timestamp;
  final int flag;
  final double rating;
  final int status;
  final String? dateCreated;
  final String? dateUpdated;
  final UserModel? user;

  //'id_post', 'id_user', 'title', 'comment', 'latitude', 'rating', 'flag', 'status', 'date_created', 'date_updated'

  CommentModel({
    this.id,
    this.idPost,
    this.idCityCategory,
    this.idUser,
    this.title,
    this.comment,
    this.latitude,
    this.timestamp,
    this.dateCreated,
    this.dateUpdated,
    this.user,
    this.rating = 0,
    this.flag = 1,
    this.status = 1,
  });

  factory CommentModel.fromMap(dynamic map) {
    return CommentModel(
      id: map['id_comment'],
      idPost: map['id_post'],
      idCityCategory: map['id_city_category'],
      comment: map['comment'],
      title: map['title'],
      latitude: map['latitude'],
      dateCreated: map['date_created'],
      dateUpdated: map['date_updated'],
      timestamp: MyTheme.timeStamp(map['date_updated']),
      idUser: map['id_user'],
      user: map['user'] != null ? UserModel.fromJson(map['user']) : null,
      rating: double.parse(map['rating'] ?? "0"),
      flag: int.parse(map['flag'] ?? "0"),
      status: int.parse(map['status'] ?? "0"),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id_comment": id,
      "id_post": idPost,
      "id_city_category": idCityCategory,
      "comment": comment,
      "timestamp": "$dateUpdated",
      "date_created": "$dateCreated",
      "date_updated": "$dateUpdated",
      "user": user != null ? user!.toJson() : null,
      "latitude": "$latitude",
      "title": "$title",
      "rating": "$rating",
      "flag": "$flag",
      "status": "$status",
      "id_user": idUser
    };
  }

  double getRating() {
    return double.parse(rating.toStringAsFixed(2));
  }
}
