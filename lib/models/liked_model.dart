import 'package:plantripapp/models/post_model.dart';

class LikedModel {
  final String? id;
  final String? idUser;
  final String? idPost;
  final String? idCityCategory;

  final PostModel? post;

  final int isLiked;
  final int flag;
  final int status;
  final String? dateCreated;
  final String? dateUpdated;

  LikedModel(
      {this.id,
      this.idUser,
      this.idPost,
      this.idCityCategory,
      this.isLiked = 0,
      this.post,
      this.flag = 1,
      this.status = 0,
      this.dateCreated,
      this.dateUpdated});

  factory LikedModel.fromJson(dynamic map) {
    return LikedModel(
      id: map['id_liked'],
      idUser: map['id_user'],
      idPost: map['id_post'],
      post: map['post'] != null ? PostModel.fromMap(map['post']) : null,
      idCityCategory: map['id_city_category'],
      isLiked: int.parse(map['is_liked'] ?? "0"),
      flag: int.parse(map['flag']),
      status: int.parse(map['status']),
      dateCreated: map['date_created'],
      dateUpdated: map['date_updated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id_follow": id,
      "id_user": idUser,
      "id_post": idPost,
      "post": post != null ? post!.toJson() : null,
      "id_city_category": "$idCityCategory",
      "isLiked": "$isLiked",
      "flag": "$flag",
      "status": "$status",
      "date_created": dateCreated,
      "date_updated": dateUpdated
    };
  }
}
