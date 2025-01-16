import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AdsService {
  static final AdsService _instance = AdsService._internal();
  factory AdsService() => _instance;
  AdsService._internal();

  late final Box _box = Hive.box('dateOfLastShowingAds');
  InterstitialAd? _interstitialAd;
  bool isInterstitialAdReady = false;

  // Инициализация Hive и загрузка данных
  Future<void> init() async {
    var date = _box.get('dateOfLastShowingAds');
    if (date == null) {
      _box.put('dateOfLastShowingAds', DateTime.now());
    }
  }

  void saveLastShowingDate() {
    _box.put('dateOfLastShowingAds', DateTime.now());
  }

  void interstitialAdLoading() {
    InterstitialAd.load(
        adUnitId: Platform.isAndroid ? 'ca-app-pub-4376742320742204/2181247729' : 'ca-app-pub-4376742320742204/7803742513',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          _interstitialAd = ad;
          isInterstitialAdReady = true;
          print("Реклама загружена");
        }, onAdFailedToLoad: (error) {
          isInterstitialAdReady = false;
          print('Ошибка загрузки: ${error}');
        }));
  }

  void interstitialDispose() {
    _interstitialAd?.dispose();
    isInterstitialAdReady = false;
  }

  void showInterstitialAd() async {
    DateTime date = _box.get('dateOfLastShowingAds');
    if (isInterstitialAdReady && DateTime.now().difference(date).inMinutes > 10) {
      saveLastShowingDate();
      try {
        await _interstitialAd!.show();
      } catch (error) {
        print(error);
      }
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        isInterstitialAdReady = false;
        interstitialAdLoading();
      }, onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        isInterstitialAdReady = false;
      });
    } else {
      print("Реклама недоступна или прошло меньше 10 минут с момента последнего показа.");
    }
  }
}
