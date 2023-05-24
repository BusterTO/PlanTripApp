import 'dart:convert';

import 'package:dash_chat/dash_chat.dart';

class ExtChatMessage {
  ExtChatMessage({this.lastMessage, this.unRead = 0, this.groupChatId});
  final ChatMessage? lastMessage;
  final int? unRead;
  final String? groupChatId;

  static ChatMessage fromRawJson(String str) =>
      ChatMessage.fromJson(json.decode(str) as Map<String, dynamic>);

  String toRawJson() => json.encode(toJson());

  static ExtChatMessage fromJson(dynamic json) {
    //print(json);
    return ExtChatMessage(
      lastMessage: ChatMessage.fromJson(json['lastMessage']),
      unRead: json["unRead"] as int,
      groupChatId: json["groupChatId"] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        "lastMessage": lastMessage!.toJson(),
        "unRead": unRead,
        "groupChatId": groupChatId,
      };
}
