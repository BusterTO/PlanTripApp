import 'dart:convert';

import 'package:plantripapp/chat/models/message.dart';

class ExtMessage {
  ExtMessage({this.lastMessage, this.unRead = 0, this.groupChatId});
  final Message? lastMessage;
  final int? unRead;
  final String? groupChatId;

  static ExtMessage fromRawJson(String str) =>
      ExtMessage.fromJson(json.decode(str) as Map<String, dynamic>);

  String toRawJson() => json.encode(toJson());

  static ExtMessage fromJson(dynamic json) {
    //print(json);
    return ExtMessage(
      lastMessage: Message.fromJson(json['lastMessage']),
      unRead: json["unRead"] as int,
      groupChatId: json["groupChatId"] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        "lastMessage": lastMessage!.toMap(),
        "unRead": unRead,
        "groupChatId": groupChatId,
      };
}
