import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:plantripapp/chat/chat_list_screen.dart';
import 'package:plantripapp/core/firebase_auth_service.dart';
import 'package:plantripapp/core/my_pref.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:http/http.dart' as http;

class NotificationFCMManager {
  MyPref? _box = Get.find<MyPref>(); //MyPref box = Get.find<MyPref>();
  MyPref? get box => _box;

  setMyPref(final MyPref box) {
    _box = box;
    _firebaseAuthService.setBox(box);
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationFCMManager._internal() {
    debugPrint("NotificationFCMManager._internal...");
    if (box == null) {
      setMyPref(MyPref.to);
    }

    init();
  }

  static final NotificationFCMManager _instance =
      NotificationFCMManager._internal();
  static NotificationFCMManager get instance => _instance;

  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService.instance;
  FirebaseAuthService get firebaseAuthService => _firebaseAuthService;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  FirebaseMessaging get firebaseMessaging => _firebaseMessaging;

  AndroidNotificationChannel? channel;

  bool _initialized = false;
  static const String iconNotif = "logo_small";
  static const String iconBigNotif = "logo_round";
  static const String idNotif = '${appName}App';
  static const String titleNotif = '${appName}BroadcastMessage';
  static const String descNotif = '${appName}NotificationAlert';

  init() async {
    tz.initializeTimeZones();

    if (!kIsWeb && !_initialized) {
      _initialized = true;

      channel = const AndroidNotificationChannel(
        idNotif, // id
        titleNotif, // title
        description: descNotif, // description
        importance: Importance.high,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      AndroidInitializationSettings initializationSettingsAndroid =
          const AndroidInitializationSettings(iconNotif);
      final DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification,
      );
      final InitializationSettings initializationSettings =
          InitializationSettings(
              android: initializationSettingsAndroid,
              iOS: initializationSettingsIOS);
      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        /*onDidReceiveBackgroundNotificationResponse:
            (NotificationResponse? response) {},
        onDidReceiveNotificationResponse: (NotificationResponse? response) {
          if (response != null) {
            onSelectNotification(response.payload);
          }
        },
        //onSelectNotification: onSelectNotification,*/
      );

      if (GetPlatform.isAndroid) {
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()!
            .requestPermission();

        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel!);
      }

      if (GetPlatform.isIOS) {
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );
      }

      try {
        final NotificationSettings settings =
            await firebaseMessaging.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );

        debugPrint('User granted permission: ${settings.authorizationStatus}');
      } catch (e) {
        debugPrint("Error setting ${e.toString()}");
      }

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      if (GetPlatform.isIOS) {
        await firebaseMessaging.setForegroundNotificationPresentationOptions(
          alert: true, // Required to display a heads up notification
          badge: true,
          sound: true,
        );
      }
    }

    firebaseMessaging.getInitialMessage().then((RemoteMessage? message) async {
      if (box == null) {
        setMyPref(MyPref.to);
      }

      if (message != null) {
        debugPrint("getInitialMessage() FCM..");
        if (message.data['post'] != null) {
          Future.delayed(const Duration(milliseconds: 1200), () {
            onSelectNotification(jsonEncode(message.data));
          });
        }
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("onMessage.listenining... get new message");

      RemoteNotification notification = message.notification!;
      Map<String, dynamic> getData = message.data;

      if (box == null) {
        setMyPref(MyPref.to);
      }

      final XController x = XController.to;
      final getMyPref = x.myPref;
      String? largeIconPath;

      if (notification.title != null && !kIsWeb) {
        try {
          String image = getData['image'] ?? '';
          debugPrint(image);

          if (image != '' && GetPlatform.isAndroid) {
            largeIconPath = await _downloadAndSaveFile(image, 'largeIcon');
          }

          String getMember = getMyPref.pMember.val;
          debugPrint(getMember);
          if (getMember != '') {
            var member = jsonDecode(getMember);
            debugPrint(member['fullname']);
          }

          //debugPrint(member);

        } catch (e) {
          debugPrint("Error: \n ${e.toString()}");
        }

        var androidPlatform = androidPlatformChannelSpecifics;
        if (largeIconPath != null && largeIconPath != '') {
          androidPlatform = AndroidNotificationDetails(
            idNotif,
            titleNotif,
            channelDescription: descNotif,
            importance: Importance.max,
            priority: Priority.high,
            icon: iconNotif,
            largeIcon: FilePathAndroidBitmap(largeIconPath),
          );
        }

        var isLogged = false;
        if (box == null) {
          setMyPref(MyPref.to);
        }

        isLogged = box!.pLogin.val;

        if (isLogged) {
          await flutterLocalNotificationsPlugin.zonedSchedule(
            thisIDNotif,
            notification.title,
            notification.body,
            tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
            NotificationDetails(
              android: androidPlatform,
              iOS: const DarwinNotificationDetails(),
            ),
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            payload: jsonEncode(getData),
          );
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('A new onMessageOpenedApp event was published!');
      debugPrint(message.toString());
      if (message.data['post'] != null) {
        onSelectNotification(jsonEncode(message.data));
      }
    });

    firebaseMessaging.getToken(vapidKey: serverKeyFCM).then((String? token) {
      debugPrint("get token FCM $token");
      XController.to.saveTokenFCM(token!);
    });

    firebaseMessaging.onTokenRefresh.listen((String? newtoken) {
      debugPrint("get listen token FCM $newtoken");
      XController.to.saveTokenFCM(newtoken!);
    });

    //subscribe topics

    await subscribeFCMTopic(fcmTopicName);
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  subscribeFCMTopic(String? topic) async {
    await firebaseMessaging.subscribeToTopic(topic!);
  }

  unSubcribeFCMTopic(String? topic) async {
    await firebaseMessaging.unsubscribeFromTopic(topic!);
  }

  Future onDidReceiveLocalNotification(
      int? id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    debugPrint("onDidReceiveLocalNotification title $title");
    debugPrint("onDidReceiveLocalNotification payload $payload");

    try {
      var isLogged = false;
      if (box == null) {
        setMyPref(MyPref.to);
      }

      isLogged = box!.pLogin.val;
      if (isLogged) {
        NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: const DarwinNotificationDetails(),
        );

        await flutterLocalNotificationsPlugin.zonedSchedule(
          thisIDNotif,
          title,
          body,
          tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
          platformChannelSpecifics,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: payload,
        );
      }
    } catch (e) {
      debugPrint("Error onDidReceiveLocalNotification ${e.toString()}");
    }
  }

  Future onSelectNotification(String? payload) async {
    debugPrint("onSelectNotification");
    var isLogged = false;
    if (box == null) {
      setMyPref(MyPref.to);
    }

    isLogged = box!.pLogin.val;

    if (isLogged) {
      if (payload != null) {
        //debugPrint('notification payload: $payload');
        try {
          Map<String, dynamic> dataPayload = jsonDecode(payload);
          //debugPrint(dataPayload);
          if (dataPayload['post'] != null) {
            Map<String, dynamic> postData = jsonDecode(dataPayload['post']);
            debugPrint(postData['id_post']);
            //debugPrint(postData);
          }

          // goes to chat screen
          if (dataPayload['keyname'] != null) {
            //keyname: message_send
            if (dataPayload['keyname'].toString().contains('message')) {
              await Future.delayed(const Duration(milliseconds: 1200));
              Future.microtask(
                () => Navigator.push(
                  Get.context!,
                  MaterialPageRoute(builder: (context) => ChatListScreen()),
                ),
              );
            }
          }
        } catch (e) {
          debugPrint("Error: parsing: $e");
        }
      }
    }
  }

  final int thisIDNotif = 0;
  final AndroidNotificationDetails androidPlatformChannelSpecifics =
      const AndroidNotificationDetails(
    idNotif,
    titleNotif,
    channelDescription: descNotif,
    importance: Importance.max,
    priority: Priority.high,
    icon: iconNotif,
    largeIcon: DrawableResourceAndroidBitmap(iconBigNotif),
  );

  showNotif(String title, String body, String payload) async {
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: const DarwinNotificationDetails(),
    );

    /*await flutterLocalNotificationsPlugin.show(
        thisIDNotif, title, body, platformChannelSpecifics,
        payload: payload);*/
    var isLogged = false;
    if (box == null) {
      setMyPref(MyPref.to);
    }

    isLogged = box!.pLogin.val;
    if (isLogged) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        thisIDNotif,
        title,
        body,
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
    }
  }
}
