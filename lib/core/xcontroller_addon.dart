import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantripapp/chat/models/ext_chat_message.dart';
import 'package:plantripapp/chat/models/ext_message.dart';
import 'package:plantripapp/chat/models/userchat.dart';
import 'package:plantripapp/models/category_model.dart';
import 'package:plantripapp/models/city_category_model.dart';
import 'package:plantripapp/models/city_model.dart';
import 'package:plantripapp/models/follow_model.dart';
import 'package:plantripapp/models/liked_model.dart';
import 'package:plantripapp/models/myplan_model.dart';
import 'package:plantripapp/models/notif_model.dart';
import 'package:plantripapp/models/post_model.dart';
import 'package:plantripapp/models/slide_model.dart';
import 'package:plantripapp/models/user_model.dart';
import 'package:plantripapp/theme.dart';

enum AppState { loading, done }

class ItemReponse {
  ItemReponse(
      {this.posts,
      this.categories,
      this.sliders,
      this.cities,
      this.articles,
      this.all,
      this.liked,
      this.users,
      this.notifs,
      this.totalUsers = 0,
      this.followings,
      this.followers});
  List<PostModel>? posts;
  List<PostModel>? articles;
  List<PostModel>? all;
  List<PostModel>? nearbys;
  dynamic result;
  List<CategoryModel>? categories;
  List<CityCategoryModel>? cityCategories;
  List<SlideModel>? sliders;
  List<CityModel>? cities;
  List<MyPlanModel>? myplans;
  List<CityCategoryModel>? travels;
  List<CityCategoryModel>? hotels;
  List<LikedModel>? liked;
  List<UserModel>? users;
  List<NotifModel>? notifs;
  int totalUsers;
  List<FollowModel>? followings;
  List<FollowModel>? followers;
}

//chat utility
enum ChatState { loading, done }

class ItemChatUser {
  ItemChatUser();
  User? user;
  UserChat? peer;
  String? groupChatId;
}

class UserLogin {
  UserLogin();
  UserChat? userChat;
  List<UserChat>? userChats = [];
  List<ExtMessage>? userMessages = [];
  List<ExtChatMessage>? userChatMessages = [];

  User? user;
  bool? isLogin;
  int status = 0;
}
//chat utility

class ItemPost {
  ItemPost({this.appState = AppState.loading});
  dynamic result;
  String? title;
  String? id;
  String? idUser;
  List<PostModel> posts = [];
  String pagingLimit = pageLimit;
  AppState appState = AppState.loading;
}

class ItemListUser {
  ItemListUser({this.appState = AppState.loading});
  dynamic result;
  List<UserModel> posts = [];
  String pagingLimit = pageLimit;
  AppState appState = AppState.loading;
}
