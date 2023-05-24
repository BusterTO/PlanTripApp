class CityModel {
  final String? id;
  final String? title;
  final String? description;
  final String? image;
  final String? placesId;
  final String? countryCd;
  final String? country;
  final String? latitude;
  final int? flag;
  final int? status;

  final String? createdAt;
  final String? updateAt;

  CityModel(
      {this.id,
      this.title,
      this.description,
      this.image,
      this.placesId,
      this.countryCd,
      this.country,
      this.latitude,
      this.flag = 1,
      this.status = 1,
      this.createdAt,
      this.updateAt});

  // title, description, image, total_interest, total_post, total_like, total_trivia, flag,
  //status, date_created, date_updated

  factory CityModel.fromMap(Map<String, dynamic> map) {
    return CityModel(
      id: map['id_city'],
      title: map['title'],
      description: map['description'],
      image: map['image'],
      placesId: map['places_id'],
      countryCd: map['country_cd'],
      country: map['country'],
      latitude: map['latitude'],
      flag: int.parse(map['flag'] ?? "1"),
      status: int.parse(map['status'] ?? "1"),
      createdAt: map['date_created'],
      updateAt: map['date_updated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id_city": id,
      "title": title,
      "description": description,
      "image": image,
      "places_id": placesId,
      "country_cd": "$countryCd",
      "country": "$country",
      "latitude": "$latitude",
      "date_created": "$createdAt",
      "date_updated": "$updateAt",
      "flag": "$flag",
      "status": "$status"
    };
  }
}
