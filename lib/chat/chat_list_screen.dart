import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantripapp/chat/models/ext_chat_message.dart';
import 'package:plantripapp/chat/models/userchat.dart';
import 'package:plantripapp/chat/widgets/message_row.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/theme.dart';
import 'package:plantripapp/widgets/input_container.dart';

class ChatListScreen extends StatelessWidget {
  ChatListScreen({Key? key}) : super(key: key) {
    listUsers.value = x.userLogin.value.userChats!;
    tempUsers.value = x.userLogin.value.userChats!;

    if (listUsers.isEmpty) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        listUsers.value = x.userLogin.value.userChats!;
        tempUsers.value = x.userLogin.value.userChats!;
      });
    }
  }

  final XController x = XController.to;
  final listUsers = <UserChat>[].obs;
  final tempUsers = <UserChat>[].obs;

  onSearch(String search) {
    listUsers.value = tempUsers
        .where((user) => user.nickname!.toLowerCase().contains(search))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      color: Get.theme.backgroundColor,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            padding: EdgeInsets.zero,
            width: Get.width,
            height: Get.height,
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: Get.mediaQuery.padding.top * 0.35,
                    left: paddingSize * 0.8,
                    right: paddingSize * 0.45,
                  ),
                  child: topHeader(),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: Get.mediaQuery.padding.top * 0.35,
                    left: paddingSize * 0.8,
                    right: paddingSize * 0.45,
                  ),
                  child: inputSearch(x.isDarkMode.value),
                ),
                spaceHeight10,
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: paddingSize * 0.8,
                      right: paddingSize * 0.45,
                    ),
                    child: Obx(
                      () => createBody(
                        x,
                        x.userLogin.value.userChatMessages!,
                        listUsers,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget createBody(final XController x, final List<ExtChatMessage> messages,
      final List<UserChat>? users) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          spaceHeight10,
          Obx(
            () => selectedMenu.value == 0
                ? listOfMessage(messages)
                : listOfPeople(x, users),
          ),
          spaceHeight50,
        ],
      ),
    );
  }

  Widget inputSearch(final bool isDark) {
    return SizedBox(
      child: InputContainer(
        backgroundColor: Get.theme.backgroundColor,
        child: TextField(
          onChanged: (value) => onSearch(value),
          decoration: inputForm(
            Get.theme.backgroundColor,
            25,
            const EdgeInsets.only(left: 0, right: 0, top: 12, bottom: 0),
          ).copyWith(
            hintText: 'Search',
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 10, right: 5),
              child: Icon(
                BootstrapIcons.search,
                color: Get.theme.primaryColor,
                size: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget listOfMessage(final List<ExtChatMessage> datas) {
    return SizedBox(
      child: datas.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset("assets/empty_data.png",
                        width: Get.width / 2),
                  ),
                  Text("not_found".tr,
                      textAlign: TextAlign.center, style: textBold),
                  Text(
                      "Please select one of Explore Users\r\n to starting to chat"
                          .tr,
                      textAlign: TextAlign.center,
                      style: textBold),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(left: 5, bottom: 100, top: 15),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: datas.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: index == datas.length - 1 ? 100 : 0),
                      child: MessageRow(
                        extChat: datas[index],
                      ),
                    ));
              },
            ),
    );
  }

  Widget customRow(
    String name,
    String message,
    String img,
    String datetime,
    String counter,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {},
              child: CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(img),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Get.theme.textTheme.caption!.copyWith(
                      letterSpacing: 0.6,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: Get.width / 1.9,
                    child: Text(
                      message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: Get.theme.textTheme.caption!.copyWith(
                        letterSpacing: 0.6,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Get.isDarkMode
                            ? Colors.grey[600]
                            : Colors.grey[400],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: SizedBox(),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    datetime,
                    style: Get.theme.textTheme.caption!.copyWith(
                      letterSpacing: 0.6,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color:
                          Get.theme.textTheme.caption!.color!.withOpacity(0.5),
                    ),
                  ),
                  spaceHeight5,
                  Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient:
                          XController.getGradientColor(true, Get.isDarkMode),
                    ),
                    child: Center(
                      child: Text(
                        counter,
                        style: Get.theme.textTheme.caption!.copyWith(
                          letterSpacing: 0.6,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            spaceWidth10,
          ],
        ),
        const SizedBox(height: 3),
        const Divider(),
      ],
    );
  }

  Widget listOfPeople(final XController x, final List<UserChat>? peoples) {
    return SizedBox(
      child: peoples!.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset("assets/empty_data.png",
                        width: Get.width / 2),
                  ),
                  Text("not_found".tr,
                      textAlign: TextAlign.center, style: textBold),
                  Text(
                      "Please invite your friend to install\r\n and  become to your Explorer Users"
                          .tr,
                      textAlign: TextAlign.center,
                      style: textBold),
                ],
              ),
            )
          : GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (_, index) => Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    x.gotoChatApp(peoples[index]);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: InkWell(
                            onTap: () {
                              String photoUrl = peoples[index].photoUrl ?? '';
                              if (photoUrl.isNotEmpty && photoUrl != '') {
                                Get.to(
                                  Scaffold(
                                    body: MyTheme.photoView(photoUrl),
                                  ),
                                  transition: Transition.zoom,
                                );
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Get.theme.primaryColorLight,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(3),
                              child: ClipOval(
                                child: ExtendedImage.network(
                                  peoples[index].photoUrl!,
                                  width: witdhIcon,
                                  height: witdhIcon,
                                  fit: BoxFit.cover,
                                  cache: true,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            peoples[index].nickname!,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              itemCount: peoples.length,
            ),
    );
  }

  final List<String> menus = ["Chat", "Explore"];
  final selectedMenu = 0.obs;

  Widget topHeader() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                BootstrapIcons.chevron_left,
                size: 25,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 0),
            child: Obx(
              () => Row(
                children: menus.map((e) {
                  final index = menus.indexOf(e);
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        selectedMenu.value = index;
                      },
                      child: Container(
                        padding: const EdgeInsets.only(right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e,
                              style: textTitle.copyWith(
                                  fontSize:
                                      selectedMenu.value == index ? 14 : 12,
                                  color: selectedMenu.value == index
                                      ? Get.theme.textTheme.bodyText1!.color!
                                      : Colors.grey),
                            ),
                            if (selectedMenu.value == index)
                              Container(
                                color: Get.theme.primaryColor,
                                width: 30,
                                height: 5,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
