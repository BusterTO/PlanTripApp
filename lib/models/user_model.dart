enum UserState { online, offline, unknown }

class UserModel {
  final String? id;
  final String? fullname;
  final String? username;
  final String? phone;
  final String? email;
  final String? image;
  final String? about;
  final String? tokenFcm;

  final String? latitude;
  final String? gender;
  final String? location;
  final String? country;
  final String? password;

  final int totalPost;
  final int totalLike;
  final int totalShare;
  final int totalComment;
  final int totalFollower;
  final int totalFollowing;

  final UserState state;
  final int status;
  final String? dateCreated;
  final String? timestamp;
  final int idInstall;
  final String? uidFcm;
  bool? isFollowedByMe;

  UserModel({
    this.id,
    this.fullname,
    this.username,
    this.phone,
    this.email,
    this.image,
    this.about,
    this.tokenFcm,
    this.latitude,
    this.gender,
    this.location,
    this.country,
    this.password,
    this.status = 0,
    this.state = UserState.offline,
    this.timestamp,
    this.dateCreated,
    this.idInstall = 0,
    this.uidFcm,
    this.totalPost = 0,
    this.totalLike = 0,
    this.totalShare = 0,
    this.totalComment = 0,
    this.totalFollower = 0,
    this.totalFollowing = 0,
    this.isFollowedByMe = false,
  });

  factory UserModel.fromJson(dynamic map) {
    return UserModel(
      id: map['id_user'],
      fullname: map['fullname'],
      username: map['username'],
      phone: map['phone'],
      email: map['email'],
      image: map['image'],
      about: map['about'],
      tokenFcm: map['token_fcm'],
      status: int.parse(map['status'] ?? "0"),
      gender: "${map['gender'] ?? ''}",
      latitude: "${map['latitude'] ?? ''}",
      location: map['location'],
      country: map['country'],
      password: map['password_real'],
      state:
          int.parse(map['status']) == 1 ? UserState.online : UserState.offline,
      timestamp: map['timestamp'],
      dateCreated: map['date_created'],
      idInstall: int.parse(map['id_install'] ?? "0"),
      uidFcm: map['uid_fcm'],
      totalPost: int.parse(map['total_post'] ?? "0"),
      totalLike: int.parse(map['total_like'] ?? "0"),
      totalComment: int.parse(map['total_comment'] ?? "0"),
      totalShare: int.parse(map['total_share'] ?? "0"),
      totalFollower: int.parse(map['total_follower'] ?? "0"),
      totalFollowing: int.parse(map['total_following'] ?? "0"),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id_user": id,
      "fullname": fullname,
      "username": username,
      "phone": phone,
      "email": email,
      "image": image,
      "about": about,
      "token_fcm": tokenFcm,
      "location": location,
      "latitude": latitude,
      "gender": gender,
      "country": country,
      "password_real": password,
      "status": "$status",
      "timestamp": "$timestamp",
      "date_created": dateCreated,
      "id_install": "$idInstall",
      "uid_fcm": uidFcm,
      "total_post": "$totalPost",
      "total_like": "$totalLike",
      "total_comment": "$totalComment",
      "total_share": "$totalShare",
      "total_follower": "$totalFollower",
      "total_following": "$totalFollowing",
    };
  }
}
