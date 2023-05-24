class CardModel {
  final String? id;
  final String? name;
  final String? no;
  final String? provider;

  final String? cvv;
  final String? exp;
  final int? status;

  CardModel(
      {this.id,
      this.name,
      this.no,
      this.cvv,
      this.provider,
      this.exp,
      this.status = 1});

  factory CardModel.fromMap(Map<String, dynamic> map) {
    return CardModel(
        id: map['id'],
        name: map['name'],
        no: map['no'],
        cvv: map['cvv'],
        provider: map['provider'],
        exp: map['exp'],
        status: int.parse(map['status'] ?? "1"));
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "no": "$no",
      "cvv": "$cvv",
      "name": "$name",
      "provider": "$provider",
      "exp": "$exp",
      "status": "$status"
    };
  }
}
