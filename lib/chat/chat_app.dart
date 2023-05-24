import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:extended_image/extended_image.dart';
import 'package:plantripapp/chat/models/message.dart';
import 'package:plantripapp/chat/models/userchat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:plantripapp/theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:plantripapp/chat/controller/chat_controller.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/chat/widgets/chat_bubble/bubble_type.dart';
import 'package:plantripapp/chat/widgets/chat_bubble/chat_bubble.dart';
import 'package:plantripapp/chat/widgets/chat_bubble/clippers/chat_bubble_clipper_5.dart';

class ChatApp extends StatefulWidget {
  final UserChat userChat;
  const ChatApp({Key? key, required this.userChat}) : super(key: key);

  @override
  ChatAppState createState() => ChatAppState();
}

class ChatAppState extends State<ChatApp> {
  final XController x = XController.to;
  final GlobalKey<DashChatState>? chatViewKey = GlobalKey<DashChatState>();

  final ChatUser user = ChatUser(
    name: XController.to.thisUser.value.fullname,
    uid: XController.to.userLogin.value.user!.uid,
    avatar: XController.to.photoUser.value,
  );

  final ChatUser otherUser = ChatUser(
    name: XController.to.itemChatScreen.value.peer!.nickname,
    uid: XController.to.itemChatScreen.value.peer!.id,
    avatar: XController.to.itemChatScreen.value.peer!.photoUrl,
  );

  List<ChatMessage> messages = [];
  List<ChatMessage> m = [];
  var i = 0;

  final String groupChatId = XController.to.itemChatScreen.value.groupChatId!;
  bool isFirstLoad = true;

  @override
  void initState() {
    super.initState();

    x.myPref.pOnChatScreen.val = "onChatScreen";

    Timer(const Duration(milliseconds: 1500), () {
      isFirstLoad = false;
      scrollToBottom();
    });

    debugPrint("groupChatId $groupChatId");
    //debugPrint("check userlogin ${x.userLogin.value.userChat.toJson()}");
    debugPrint("user.name ${user.toJson()}");
    debugPrint("otherUser ${otherUser.toJson()}");
  }

  @override
  void dispose() {
    x.closeMessage();
    super.dispose();
  }

  void systemMessage() {
    Timer(const Duration(milliseconds: 300), () {
      if (i < 6) {
        setState(() {
          messages = [...messages, m[i]];
        });
        i++;
      }
      Timer(const Duration(milliseconds: 300), () {
        chatViewKey!.currentState!.scrollController.animateTo(
          chatViewKey!.currentState!.scrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      });
    });
  }

  void onSend(ChatMessage? message) async {
    //debugPrint(message);
    if (message == null) return;

    message.customProperties = {
      "updatedAt": DateTime.now().millisecondsSinceEpoch,
      "peer": x.userLogin.value.userChat!.toJson(),
      'groupChatId': groupChatId,
      "isSticker": false,
      "isRead": false,
      "isImage": false,
      "isEncrypt": false,
      "isVideo": false,
      "isDocument": false,
      "isContact": false,
    };
    //debugPrint(message.toJson());

    var documentReference = x.chatController.firestore
        .collection(ChatController.tAGMESSAGECHAT)
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    await x.chatController.firestore.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        message.toJson(),
      );
    });

    notifToUserPeer(message);

    //scrolltoBottom
    scrollToBottom();
  }

  scrollToBottom() {
    //debugPrint("scrollToBottom running... ");
    Timer(const Duration(milliseconds: 450), () {
      if (chatViewKey != null && chatViewKey!.currentState != null) {
        chatViewKey!.currentState!.scrollController.animateTo(
          chatViewKey!.currentState!.scrollController.position.maxScrollExtent +
              50,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 150),
        );
      }
    });
  }

  notifToUserPeer(ChatMessage chatMessage) {
    x.initChatController();

    // send notif to user
    UserChat? userChat = x.itemChatScreen.value.peer;
    final bool isImage = chatMessage.image != null;
    var msgChat = '${chatMessage.text}';
    if (isImage) {
      msgChat = 'Photo';
    }

    bool isSticker = false;
    if (chatMessage.customProperties!['isSticker'] != null) {
      isSticker = chatMessage.customProperties!['isSticker'];
    }

    debugPrint("check isSticker $isSticker");

    var dataPush = {
      'payload': {
        'keyname': 'message_send',
        'image': isImage ? chatMessage.image : '',
        'peer': jsonEncode(x.userLogin.value.userChat!.toJson()),
      },
      'title': 'New message ${x.thisUser.value.fullname}',
      'body': '$msgChat -$appName',
      'id_member': x.userLogin.value.userChat!.id,
      'id_member_to': userChat!.id,
      'image': isImage ? chatMessage.image : '',
      'token': userChat.token,
      'peer': jsonEncode(x.userLogin.value.userChat!.toJson()),
      'groupChatId': groupChatId,
    };

    //debugPrint(jsonEncode(dataPush));

    x.sendNotifToRecipient(dataPush);
  }

  final TextEditingController _replyController = TextEditingController();
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    //final XController x = XController.to;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Get.theme.backgroundColor,
            Get.theme.backgroundColor.withOpacity(.6),
          ],
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.1,
          automaticallyImplyLeading: false,
          backgroundColor: Get.theme.backgroundColor,
          iconTheme: IconThemeData(color: Get.theme.primaryColor),
          title: Obx(
            () => createTopIcon(x.itemChatScreen.value.peer),
          ),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () {
                CoolAlert.show(
                    context: Get.context!,
                    backgroundColor: Get.theme.canvasColor,
                    type: CoolAlertType.confirm,
                    text: 'Do you want delete all chats?',
                    confirmBtnText: 'Yes',
                    cancelBtnText: 'No',
                    confirmBtnColor: Colors.green,
                    onConfirmBtnTap: () async {
                      Get.back();
                      EasyLoading.show(status: 'Loading...');
                      await Future.delayed(const Duration(milliseconds: 1200));
                      //x.saveFBToken(null);

                      await Future.delayed(const Duration(milliseconds: 1000),
                          () async {
                        await x.chatController
                            .deleteMessageByGroupIdChat(x, groupChatId);

                        EasyLoading.showSuccess('deletemessagesuccess'.tr);
                        sendNotifAfterDelete();

                        await Future.delayed(const Duration(milliseconds: 1200),
                            () {
                          x.asyncHome();
                          EasyLoading.dismiss();
                          Get.back();
                        });
                      });
                    });
              },
              icon: Icon(BootstrapIcons.x,
                  size: 32, color: Get.theme.primaryColor),
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: x.chatController.firestore
                .collection(ChatController.tAGMESSAGECHAT)
                .doc(groupChatId)
                .collection(groupChatId)
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Get.theme.colorScheme.secondary,
                    ),
                  ),
                );
              } else {
                List<DocumentSnapshot<Map<String, dynamic>>> items =
                    snapshot.data!.docs;

                var messages = items.map((i) {
                  //debugPrint("check message i");

                  ChatMessage itemChat = ChatMessage.fromJson(i.data()!);
                  // push MarkAsRead

                  bool checkIsRead = itemChat.customProperties!['isRead'];

                  if (!checkIsRead &&
                      itemChat.user.uid != x.userLogin.value.user!.uid) {
                    debugPrint("markAsRead running... ${itemChat.id}");

                    final dynamic properties = itemChat.customProperties;

                    i.reference.update({
                      'customProperties': {
                        "updatedAt": DateTime.now().millisecondsSinceEpoch,
                        "isSticker": properties['isSticker'],
                        "isRead": true,
                        "isEncrypt": properties['isEncrypt'],
                        "isVideo": properties['isVideo'],
                        "isDocument": properties['isDocument'],
                        "isContact": properties['isContact'],
                        "isImage": properties['isImage'],
                        "peer": properties['peer'],
                        'groupChatId': groupChatId,
                      }
                    });
                  }

                  if (!isFirstLoad) scrollToBottom();
                  return itemChat;
                }).toList();

                return DashChat(
                  key: chatViewKey,
                  parsePatterns: <MatchText>[
                    MatchText(
                      type: ParsedType.EMAIL,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                      ),
                      onTap: (String value) {},
                    ),
                    MatchText(
                        pattern: r"\B#+([\w]+)\b",
                        style: const TextStyle(
                          color: Colors.pink,
                          fontSize: 16,
                        ),
                        onTap: (String value) {}),
                  ],
                  messageBuilder: (ChatMessage chat) {
                    MessageType type = MessageType.text;
                    bool isImage = false;
                    if (chat.image != null) {
                      type = MessageType.image;
                      isImage = true;
                    }
                    bool isMe = chat.user.uid == x.userLogin.value.user!.uid;

                    return buildBubble(chat, isMe, type, isImage, false);
                  },
                  inverted: false,
                  onSend: onSend,
                  sendOnEnter: true,
                  textInputAction: TextInputAction.send,
                  user: user,
                  textCapitalization: TextCapitalization.sentences,
                  inputDecoration: const InputDecoration.collapsed(
                    hintText: "Type message...",
                    hintStyle: textSmallGrey,
                  ),
                  dateFormat: DateFormat('yyyy-MMM-dd'),
                  timeFormat: DateFormat('KK:mm a'), // 'HH:mm
                  messages: messages,
                  showUserAvatar: false,
                  showAvatarForEveryMessage: false,
                  scrollToBottom: true,
                  avatarBuilder: (ChatUser user) {
                    return const SizedBox.shrink();
                  },
                  inputMaxLines: 5,
                  messageContainerPadding: const EdgeInsets.only(
                    left: 0.0,
                    right: 5.0,
                    bottom: 0,
                  ),
                  inputToolbarPadding: const EdgeInsets.only(
                    left: 10.0,
                    right: 5.0,
                    top: 5,
                    bottom: 5,
                  ),
                  alwaysShowSend: true,
                  textController: _replyController,
                  inputTextStyle:
                      const TextStyle(fontSize: 14.0, color: Colors.black87),
                  inputToolbarMargin: const EdgeInsets.only(
                    left: 5.0,
                    right: 5.0,
                  ),
                  inputContainerStyle: BoxDecoration(
                    borderRadius: BorderRadius.circular(35.0),
                    color: Colors.white,
                  ),
                  onQuickReply: (Reply reply) {
                    setState(() {
                      messages.add(ChatMessage(
                          text: reply.value,
                          createdAt: DateTime.now(),
                          user: user));

                      messages = [...messages];
                    });

                    Timer(const Duration(milliseconds: 300), () {
                      chatViewKey!.currentState!.scrollController.animateTo(
                        chatViewKey!.currentState!.scrollController.position
                            .maxScrollExtent,
                        curve: Curves.easeOut,
                        duration: const Duration(milliseconds: 300),
                      );

                      if (i == 0) {
                        systemMessage();
                        Timer(const Duration(milliseconds: 600), () {
                          systemMessage();
                        });
                      } else {
                        systemMessage();
                      }
                    });
                  },
                  onLoadEarlier: () {
                    debugPrint("loading...");
                    //EasyLoading.showToast('Loading...');
                  },
                  shouldShowLoadEarlier: false,
                  shouldStartMessagesFromTop: false,
                  showTraillingBeforeSend: true,
                  sendButtonBuilder: ((_) {
                    return IconButton(
                        splashColor: Colors.red,
                        icon: Icon(BootstrapIcons.send,
                            size: 20, color: Get.theme.primaryColor),
                        onPressed: () async {
                          String text = _replyController.text;

                          if (text.isNotEmpty) {
                            ChatMessage message = ChatMessage(
                              text: text.trim(),
                              user: user,
                              createdAt: DateTime.now(),
                            );

                            await Future.delayed(Duration.zero, () {
                              onSend(message);
                            });

                            _replyController.text = "";
                          }
                        });
                  }),
                  trailing: <Widget>[
                    IconButton(
                      splashColor: Colors.red,
                      icon: Icon(BootstrapIcons.image,
                          size: 20, color: Get.theme.primaryColor),
                      onPressed: () async {
                        File? result;
                        final XFile? pickedFile = await picker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 90,
                          maxHeight: 512,
                          maxWidth: 512,
                        );
                        if (pickedFile != null) {
                          result = File(pickedFile.path);
                        }

                        if (result != null) {
                          final Reference storageRef = x
                              .chatController.fireStorage
                              .ref()
                              .child(MyTheme.basename(result.path));

                          UploadTask uploadTask = storageRef.putFile(
                            result,
                          );

                          TaskSnapshot download = await uploadTask;
                          String url = await download.ref.getDownloadURL();

                          ChatMessage message =
                              ChatMessage(text: "", user: user, image: url);
                          message.customProperties = {
                            "updatedAt": DateTime.now().millisecondsSinceEpoch,
                            "isSticker": false,
                            "isRead": false,
                            "isImage": true,
                            "isEncrypt": false,
                            "isVideo": false,
                            "isDocument": false,
                            "isContact": false,
                            "peer": x.userLogin.value.userChat!.toJson(),
                            'groupChatId': groupChatId,
                          };

                          var documentReference = x.chatController.firestore
                              .collection(ChatController.tAGMESSAGECHAT)
                              .doc(groupChatId)
                              .collection(groupChatId)
                              .doc(DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString());

                          await x.chatController.firestore
                              .runTransaction((transaction) async {
                            transaction.set(
                              documentReference,
                              message.toJson(),
                            );
                          });

                          //notifi to user
                          notifToUserPeer(message);
                        }
                      },
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }

  Widget createTopIcon(final UserChat? getUser) {
    UserChat userPeer = x.itemChatScreen.value.peer ?? widget.userChat;
    int diff = 10000;
    try {
      DateTime dateUpdate = DateTime.fromMillisecondsSinceEpoch(
        int.parse(userPeer.updatedAt!),
      );

      diff = DateTime.now().difference(dateUpdate.toLocal()).inMinutes;
    } catch (e) {
      debugPrint("");
    }

    return SizedBox(
      width: Get.width - 50,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Get.back();
            },
            child: const Icon(BootstrapIcons.chevron_left, size: 20),
          ),
          buildIconUserTop(userPeer.photoUrl),
          SizedBox(
            width: Get.width / 1.9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      userPeer.nickname ?? "...",
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Get.theme.textTheme.bodyText1!.color!,
                      ),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 5, top: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                            color: diff < 10
                                ? Colors.lightGreenAccent
                                : Colors.red,
                            width: 5,
                            height: 5),
                      ),
                    )
                  ],
                ),
                Text(
                  userPeer.email ?? "...",
                  maxLines: 1,
                  style: textSmallGrey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildIconUserTop(String? peerAvatar) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(3),
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Get.theme.colorScheme.secondary,
            offset: const Offset(0, 2),
            blurRadius: 5,
          )
        ],
      ),
      child: (peerAvatar != null && peerAvatar != '')
          ? CircleAvatar(
              backgroundColor: Get.theme.primaryColor.withOpacity(.7),
              radius: 32,
              backgroundImage: NetworkImage(peerAvatar),
            )
          : CircleAvatar(
              backgroundColor: Get.theme.primaryColor.withOpacity(.7),
              radius: 32,
              backgroundImage: const AssetImage("assets/def_profile.png"),
            ),
    );
  }

  //wigdet create message
  Widget buildBubble(ChatMessage chat, bool isMe, MessageType type,
      bool isImage, bool isSticker) {
    bool isRead = false;
    if (chat.customProperties != null &&
        chat.customProperties!['isRead'] != null) {
      isRead = chat.customProperties!['isRead'];
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: ChatBubble(
        clipper: ChatBubbleClipper5(
            type: isMe ? BubbleType.sendBubble : BubbleType.receiverBubble),
        alignment: isMe ? Alignment.topRight : Alignment.topLeft,
        margin: EdgeInsets.only(
            top: isMe
                ? 3
                : isImage
                    ? 10
                    : 5,
            right: isMe ? 0 : 5,
            left: isMe ? 0 : 5),
        backGroundColor:
            isMe ? Get.theme.backgroundColor : Get.theme.canvasColor,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: isImage ? Get.width * 0.6 : Get.width * 0.7,
          ),
          padding: EdgeInsets.only(
              right: isMe
                  ? isImage
                      ? 0
                      : 3
                  : 0,
              left: isMe
                  ? 0
                  : isImage
                      ? 0
                      : 5),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              buildChildByType(chat, type),
              Container(
                margin: EdgeInsets.only(
                  top: 3,
                  left: isMe
                      ? 0
                      : isImage
                          ? 0
                          : 0,
                  right: 0,
                ),
                child: Row(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isMe)
                      Container(
                        margin: const EdgeInsets.only(right: 5),
                        child: Icon(
                          isRead ? Icons.done_all : Icons.done,
                          color: isRead ? Colors.green[600] : Colors.red,
                          size: 14,
                        ),
                      ),
                    Text(
                      // 'dd MMM KK:mm a' 'HH:mm'
                      DateFormat('KK:mm a').format(
                        chat.createdAt.toLocal(),
                      ),
                      style: TextStyle(
                        fontSize: 11.0,
                        color: Get.isDarkMode
                            ? Get.theme.primaryColorLight
                            : Get.theme.primaryColor,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildChildByType(ChatMessage chat, MessageType type) {
    switch (type) {
      case MessageType.text:
        return Text(
          "${chat.text}",
        );

      case MessageType.image:
        return SizedBox(
          width: Get.width,
          height: Get.height / 6.5,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: buildImageWithLoading(chat.image!),
          ),
        );
      default:
    }

    return const SizedBox(child: Text("Unknown..."));
  }

  Widget buildImageWithLoading(String imageUrl) {
    return InkWell(
      onTap: () => Get.to(
        MyTheme.photoView(imageUrl),
        transition: Transition.fadeIn,
      ),
      child: ExtendedImage.network(imageUrl, fit: BoxFit.cover),
    );
  }

  sendNotifAfterDelete() {
    UserChat? userChat = x.itemChatScreen.value.peer;

    var dataPush = {
      'keyname': 'message_broadcast',
      'payload': {
        'keyname': 'message_broadcast',
      },
      'title': '',
      'body': '',
      'id_member': x.userLogin.value.userChat!.id,
      'id_member_to': userChat!.id,
      'image': '',
      'token': userChat.token,
      'peer': null,
      'groupChatId': groupChatId,
    };

    debugPrint(jsonEncode(dataPush));

    x.sendNotifToRecipient(dataPush);
  }
}
