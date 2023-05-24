import 'package:plantripapp/models/comment_model.dart';
import 'package:plantripapp/models/user_model.dart';

class CityCategoryModel {
  final String? id;
  final String? idCity;
  final String? nmCity;
  final String? idCategory;
  final String? nmCategory;

  final String? title;
  final String? description;
  final String? image1;
  final String? image2;
  final String? image3;
  final String? link;
  final double? rating;
  final int? totalRating;
  final String? location;
  final String? latitude;
  final int? flag;
  final int? status;

  final String? idUser;
  final UserModel? user;
  final List<CommentModel>? comments;

  final String? createdAt;
  final String? updateAt;

  CityCategoryModel(
      {this.id,
      this.idCity,
      this.nmCity,
      this.idCategory,
      this.nmCategory,
      this.title,
      this.description,
      this.idUser,
      this.user,
      this.comments,
      this.image1,
      this.image2,
      this.image3,
      this.link,
      this.rating,
      this.totalRating,
      this.location,
      this.latitude,
      this.flag = 1,
      this.status = 1,
      this.createdAt,
      this.updateAt});

  //'id_city', 'id_category', 'id_user', 'title', 'description', 'image1', 'image2', 'image3',
  //'link', 'rating', 'total_rating', 'location', 'latitude', 'flag', 'status'

  factory CityCategoryModel.fromMap(Map<String, dynamic> map) {
    return CityCategoryModel(
      id: map['id_city_category'],
      idCategory: map['id_category'],
      nmCategory: map['nm_category'],
      idCity: map['id_city'],
      nmCity: map['nm_city'],
      title: map['title'],
      description: map['description'],
      idUser: map['id_user'],
      user: map['user'] != null ? UserModel.fromJson(map['user']) : null,
      comments: map['comments'] != null
          ? map['comments'].map<CommentModel>((json) {
              return CommentModel.fromMap(json);
            }).toList()
          : [],
      image1: map['image1'],
      image2: map['image2'],
      image3: map['image3'],
      link: map['link'],
      rating: double.parse(map['rating'] ?? "0.0"),
      totalRating: int.parse(map['total_rating'] ?? "0"),
      latitude: map['latitude'],
      location: map['location'],
      flag: int.parse(map['flag'] ?? "1"),
      status: int.parse(map['status'] ?? "1"),
      createdAt: map['date_created'],
      updateAt: map['date_updated'],
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> datacomments = [];
    if (comments != null) {
      datacomments =
          comments!.map<Map<String, dynamic>>((CommentModel comment) {
        return comment.toJson();
      }).toList();
    }

    return {
      "id_city_category": id,
      "id_city": idCity,
      "nm_city": nmCity,
      "id_category": idCategory,
      "nm_category": nmCategory,
      "title": title,
      "description": description,
      "image1": image1,
      "image2": image2,
      "image3": image3,
      "link": link,
      "id_user": "$idUser",
      "user": user != null ? user!.toJson() : null,
      "comments": datacomments,
      "rating": "$rating",
      "total_rating": "$totalRating",
      "latitude": "$latitude",
      "location": "$location",
      "date_created": "$createdAt",
      "date_updated": "$updateAt",
      "flag": "$flag",
      "status": "$status"
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

    return images;
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
}
