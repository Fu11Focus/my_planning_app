import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsService {
  static final AdsService _instance = AdsService._internal();
  factory AdsService() => _instance;
  AdsService._internal();

  InterstitialAd? _interstitialAd;
  bool _isAdReady = false;

  void loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: 'ca-app-pub-4376742320742204/3986387639', //мой айди
      // adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Тестовый Ad Unit ID
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isAdReady = true;
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              ad.dispose();
              loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
              ad.dispose();
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Failed to load an interstitial ad: ${error.message}');
          _isAdReady = false;
        },
      ),
    );
  }

  void showInterstitialAd() async {
    if (_isAdReady && _interstitialAd != null) {
      await _interstitialAd!.show();
      _isAdReady = false;
      _interstitialAd = null;
    } else {
      print('Interstitial ad is not ready.');
    }
  }
}
