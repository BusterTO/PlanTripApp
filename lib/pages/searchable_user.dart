import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/models/user_model.dart';
import 'package:plantripapp/pages/other_profile_page.dart';
import 'package:plantripapp/theme.dart';
import 'package:plantripapp/widgets/icon_follow.dart';

class SearchableList extends StatefulWidget {
  final List<UserModel> otherUsers;
  const SearchableList({Key? key, required this.otherUsers}) : super(key: key);

  @override
  SearchableListState createState() => SearchableListState();
}

class SearchableListState extends State<SearchableList> {
  List<UserModel> _foundedUsers = [];
  List<UserModel> dummyUsers = [];
  List<UserModel> actualUsers = [];
  final XController x = XController.to;

  @override
  void initState() {
    List<UserModel> tempUsers = widget.otherUsers;
    for (var element in tempUsers) {
      if (element.id! != x.thisUser.value.id) {
        actualUsers.add(element);
      }
    }

    super.initState();

    dummyUsers = actualUsers;

    setState(() {
      _foundedUsers = dummyUsers;
    });
  }

  onSearch(String search) {
    setState(() {
      _foundedUsers = dummyUsers
          .where((user) => user.fullname!.toLowerCase().contains(search))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Get.theme.backgroundColor,
        systemOverlayStyle: Get.isDarkMode
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: InkWell(
            child: Icon(
              BootstrapIcons.chevron_left,
              size: 22,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
            onTap: () {
              Get.back();
            },
          ),
        ),
        title: Container(
          height: 38,
          margin: const EdgeInsets.only(right: 15),
          child: TextField(
            onChanged: (value) => onSearch(value),
            decoration: InputDecoration(
              filled: true,
              fillColor: Get.theme.scaffoldBackgroundColor,
              contentPadding: const EdgeInsets.all(0),
              prefixIcon: const Icon(BootstrapIcons.search, size: 18),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none),
              hintStyle: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
              hintText: "Search",
            ),
          ),
        ),
      ),
      body: Container(
        child: _foundedUsers.isNotEmpty
            ? ListView.builder(
                itemCount: _foundedUsers.length,
                itemBuilder: (context, index) {
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        if (_foundedUsers[index].id != x.thisUser.value.id) {
                          Get.to(OtherProfilePage(user: _foundedUsers[index]));
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            right: 20, left: 15, top: index == 0 ? 10 : 0),
                        child: userComponent(user: _foundedUsers[index]),
                      ),
                    ),
                  );
                })
            : const Center(
                child: Text(
                "No users found",
                style: textBig,
              )),
      ),
    );
  }

  userComponent({required UserModel user}) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 0),
      padding: const EdgeInsets.only(top: 0, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Get.theme.primaryColorLight,
                child: CircleAvatar(
                  radius: 25,
                  child: ClipOval(
                    child: ExtendedImage.network(
                      user.image!,
                      cache: true,
                      fit: BoxFit.cover,
                      width: 80,
                      height: 80,
                    ),
                  ),
                ),
              ),
              spaceWidth10,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.fullname!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 13)),
                  Text("@${user.username}",
                      style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                ],
              )
            ],
          ),
          IconFollow(user: user, x: x),
        ],
      ),
    );
  }
}

/*
AnimatedContainer(
              height: 35,
              width: 100,
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                  color: user.isFollowedByMe!
                      ? Get.theme.primaryColor
                      : Get.theme.backgroundColor,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: user.isFollowedByMe!
                        ? Colors.transparent
                        : Colors.grey.shade700,
                  )),
              child: Center(
                child: Text(
                  user.isFollowedByMe! ? 'Unfollow' : 'Follow',
                  style: TextStyle(
                    color: user.isFollowedByMe!
                        ? Colors.white
                        : Get.isDarkMode
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
              ),
            )
 */
