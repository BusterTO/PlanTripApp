import 'dart:convert';

List<CategoryModel> categoryModelFromJson(final String? str) =>
    List<CategoryModel>.from(
        jsonDecode(str!).map((x) => CategoryModel.fromMap(x)));

String categoryModelToJson(List<CategoryModel> data) =>
    jsonEncode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryModel {
  final String? id;
  final String? title;
  final String? description;
  final String? image;
  final int? totalPost;
  final int? flag;
  final int? status;

  CategoryModel(
      {this.id,
      this.title,
      this.description,
      this.image,
      this.totalPost = 0,
      this.flag = 1,
      this.status = 1});

  factory CategoryModel.fromMap(dynamic map) {
    return CategoryModel(
        id: map['id_category'],
        title: map['title'],
        description: map['description'],
        image: map['image'],
        totalPost: int.parse(map['total_post'] ?? "0"),
        flag: int.parse(map['flag'] ?? "1"),
        status: int.parse(map['status'] ?? "1"));
  }

  Map<String, dynamic> toJson() {
    return {
      "id_category": id,
      "title": title,
      "description": description,
      "image": image,
      "total_post": "$totalPost",
      "flag": "$flag",
      "status": "$status"
    };
  }
}
