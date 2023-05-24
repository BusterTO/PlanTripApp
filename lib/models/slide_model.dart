import 'dart:convert';

List<SlideModel> slideModelFromJson(String str) =>
    List<SlideModel>.from(jsonDecode(str).map((x) => SlideModel.fromMap(x)));

String slideModelToJson(List<SlideModel> data) =>
    jsonEncode(List<dynamic>.from(data.map((x) => x.toJson())));

class SlideModel {
  final String? id;
  final String? title;
  final String? description;
  final String? image;
  final String? video;
  final String? link;
  final int? flag;
  final int? status;

  SlideModel(
      {this.id,
      this.title,
      this.description,
      this.image,
      this.video,
      this.link,
      this.flag = 1,
      this.status = 1});

  // title, description, image, total_interest, total_post, total_like, total_trivia, flag,
  //status, date_created, date_updated

  factory SlideModel.fromMap(Map<String, dynamic> map) {
    return SlideModel(
        id: map['id_category'],
        title: map['title'],
        description: map['description'],
        image: map['image'],
        video: map['video'],
        link: map['link'],
        flag: int.parse(map['flag'] ?? "1"),
        status: int.parse(map['status'] ?? "1"));
  }

  Map<String, dynamic> toJson() {
    return {
      "id_category": id,
      "title": title,
      "description": description,
      "image": image,
      "video": video,
      "link": "$link",
      "flag": "$flag",
      "status": "$status"
    };
  }
}
