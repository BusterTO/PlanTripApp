import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsHelper {
  //appID
  static const String appIDAndroid = "ca-app-pub-0154172666410102~9737291621";
  static const String appIDiOS = "ca-app-pub-0154172666410102~3377905017";

  //bannerUnitID
  static const String bannerIDAndroid =
      "ca-app-pub-0154172666410102/6195640046";
  static const String bannerIDiOS = "ca-app-pub-0154172666410102/9279617312";

  //interstitialID
  static const String interstitialIDAndroid =
      "ca-app-pub-0154172666410102/6789185348";
  static const String interstitialIDiOS =
      "ca-app-pub-0154172666410102/8980234417";

  //var eventListener = null;
  final String appId = GetPlatform.isAndroid
      ? (isInDebugMode
          ? 'ca-app-pub-3940256099942544~3347511713' //test debug ID
          : appIDAndroid)
      : appIDiOS;

  static const kEYWORDS = <String>[
    'plantrip',
    'plan',
    'trip',
    'travel',
    'networking',
    'social',
    'community',
  ];

  static const cONTENTURL = 'https://plantrip.theaterify.id/';

  static const AdRequest request = AdRequest(
    keywords: kEYWORDS,
    contentUrl: cONTENTURL,
    nonPersonalizedAds: true,
  );

  static bool _bannerReady = false;
  bool get bannerReady => _bannerReady;

  static final BannerAdListener listenerBanner = BannerAdListener(
    onAdLoaded: (Ad ad) {
      debugPrint('${ad.runtimeType} loaded.');
      _bannerReady = true;
    },
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      //debugPrint('${ad.runtimeType} failed to load: $error.');
      ad.dispose();
      _bannerAd = null;

      Future.delayed(const Duration(seconds: 5), () {
        createBannerAd();
      });
    },
    onAdOpened: (Ad ad) => debugPrint('${ad.runtimeType} onAdOpened.'),
    onAdClosed: (Ad ad) {
      debugPrint('${ad.runtimeType} closed.');
      ad.dispose();
      Future.delayed(const Duration(seconds: 5), () {
        createBannerAd();
      });
    },
    //onApplicationExit: (Ad ad) => debugPrint('${ad.runtimeType} onApplicationExit.'),
  );

  static BannerAd? _bannerAd;
  static BannerAd? get bannerAd => _bannerAd;

  static InterstitialAd? _interstitialAd;
  static InterstitialAd? get interstitialAd => _interstitialAd;

  AdsHelper._internal() {
    init();
  }

  static final AdsHelper _instance = AdsHelper._internal();
  static AdsHelper get instance => _instance;

  init() {
    debugPrint("[AdsHelper] initialization...");
    MobileAds.instance.initialize().then((InitializationStatus status) {
      debugPrint('Initialization done: ${status.adapterStatuses}');
      MobileAds.instance
          .updateRequestConfiguration(RequestConfiguration(
              tagForChildDirectedTreatment:
                  TagForChildDirectedTreatment.unspecified))
          .then((value) {
        //prepare init ad unit

        Future.delayed(const Duration(seconds: 2), () {
          createBannerAd();
          createInterstitialAd();
        });
      });
    });

    debugPrint("Ads initialization done...");
  }

  static createBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: GetPlatform.isAndroid
          ? (isInDebugMode
              ? 'ca-app-pub-3940256099942544/6300978111' //test debug ID
              : bannerIDAndroid)
          : bannerIDiOS,
      size: AdSize.banner,
      request: request,
      listener: listenerBanner,
    );

    return _bannerAd!.load();
  }

  static createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: GetPlatform.isAndroid
            ? (isInDebugMode
                ? 'ca-app-pub-3940256099942544/1033173712' //test debug ID
                : interstitialIDAndroid)
            : interstitialIDiOS,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;

            _interstitialAd!.fullScreenContentCallback =
                FullScreenContentCallback(
              onAdShowedFullScreenContent: (InterstitialAd ad) =>
                  debugPrint('$ad onAdShowedFullScreenContent.'),
              onAdDismissedFullScreenContent: (InterstitialAd ad) {
                debugPrint('$ad onAdDismissedFullScreenContent.');
                ad.dispose();

                Future.delayed(const Duration(seconds: 15), () {
                  createInterstitialAd();
                });
              },
              onAdFailedToShowFullScreenContent:
                  (InterstitialAd ad, AdError error) {
                //debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
                ad.dispose();

                Future.delayed(const Duration(seconds: 15), () {
                  createInterstitialAd();
                });
              },
              onAdImpression: (InterstitialAd ad) =>
                  debugPrint('$ad impression occurred.'),
            );
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }

  static bool get isInDebugMode {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }
}
