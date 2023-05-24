import 'package:plantripapp/models/post_model.dart';
import 'package:plantripapp/models/user_model.dart';

class FollowModel {
  final String? id;
  final String? idUser;
  final String? idUserTo;
  final int? counterFollow;
  final int? counterUnfollow;

  final int needRequest;
  final int flag;
  final int status;
  final String? dateCreated;
  final String? dateUpdated;
  final UserModel? user;
  final PostModel? post;
  //'id_user', 'id_user_to', 'counter_follow', 'counter_unfollow', 'need_request', 'flag', 'status', 'date_created', 'date_updated'

  FollowModel({
    this.id,
    this.idUser,
    this.idUserTo,
    this.counterFollow = 0,
    this.counterUnfollow = 0,
    this.needRequest = 0,
    this.flag = 1,
    this.status = 0,
    this.dateCreated,
    this.dateUpdated,
    this.user,
    this.post,
  });

  factory FollowModel.fromJson(dynamic map) {
    return FollowModel(
      id: map['id_follow'],
      idUser: map['id_user'],
      idUserTo: map['id_user_to'],
      counterFollow: int.parse(map['counter_follow'] ?? "0"),
      counterUnfollow: int.parse(map['counter_unfollow'] ?? "0"),
      needRequest: int.parse(map['need_request']),
      flag: int.parse(map['flag']),
      status: int.parse(map['status']),
      dateCreated: map['date_created'],
      dateUpdated: map['date_updated'],
      user: map['user'] != null ? UserModel.fromJson(map['user']) : null,
      post: map['post'] != null ? PostModel.fromMap(map['post']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id_follow": id,
      "id_user": idUser,
      "id_user_to": idUserTo,
      "counter_follow": "$counterFollow",
      "counter_unfollow": "$counterUnfollow",
      "need_request": "$needRequest",
      "flag": "$flag",
      "status": "$status",
      "date_created": dateCreated,
      "date_updated": dateUpdated,
      "user": user != null ? user!.toJson() : null,
      "post": post != null ? post!.toJson() : null,
    };
  }
}
