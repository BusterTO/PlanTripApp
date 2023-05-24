enum MessageType {
  text,
  image,
  sticker,
  listOfImages,
  video,
  animation,
  document,
}

class Message {
  final String? idFrom;
  final String? idTo;
  final String? content;
  final MessageType? type;
  final bool? isRead;
  final String? timestamp;
  final bool? isEncrypt;
  final String? groupChatId;

  Message({
    required this.idFrom,
    required this.idTo,
    required this.content,
    required this.type,
    required this.isRead,
    required this.timestamp,
    required this.isEncrypt,
    required this.groupChatId,
  });

  factory Message.fromJson(Map<String, dynamic>? parsedJson) {
    //String _content = parsedJson['content'] as String;
    //final String decrypt = HomeController.decrypted(_content);

    return Message(
      idFrom: parsedJson!['idFrom'] as String,
      idTo: parsedJson['idTo'] as String,
      content: parsedJson['content'] as String,
      type: MessageType.values[parsedJson['type'] as int],
      isRead: parsedJson['isRead'] ?? true,
      timestamp: parsedJson['timestamp'] as String,
      isEncrypt: parsedJson['isEncrypt'] ?? false,
      groupChatId: parsedJson['groupChatId'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idFrom': idFrom,
      'idTo': idTo,
      'content': content,
      'type': type!.index,
      'isRead': isRead,
      'timestamp': timestamp,
      'isEncrypt': isEncrypt,
      'groupChatId': groupChatId,
    };
  }
}
