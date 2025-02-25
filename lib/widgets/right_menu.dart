import 'package:ToDoDude/util/ads.dart';
import 'package:flutter/material.dart';
import 'package:ToDoDude/util/color_palette.dart';

class RightMenu extends StatefulWidget {
  final String thisPage;
  const RightMenu({Key? key, required this.thisPage}) : super(key: key);
  @override
  State<RightMenu> createState() => _RightMenuState();
}

class _RightMenuState extends State<RightMenu> {
  AdsService adsService = AdsService();

  @override
  void initState() {
    super.initState();
    adsService.interstitialAdLoading();
  }

  @override
  void dispose() {
    adsService.interstitialDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ListTile buildListTile(IconData icon, String title, String goTo) {
      return ListTile(
        onTap: () async {
          if (widget.thisPage != title) {
            try {
              adsService.showInterstitialAd();
            } catch (error) {
              print(error);
            }
            Navigator.restorablePopAndPushNamed(context, goTo); // Перейти на новую страницу
          }
        },
        leading: Icon(
          icon,
          color: widget.thisPage == title ? brand : txt,
        ),
        title: Text(
          title,
          style: TextStyle(
            letterSpacing: 1.5,
            fontSize: 16,
            color: widget.thisPage == title ? brand : txt,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      width: 190,
      height: 380,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x99000000),
            spreadRadius: 1000,
            offset: Offset(5, 5),
          ),
        ],
        color: bg,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildListTile(Icons.sunny_snowing, 'Wish Board', '/wishboard'),
          buildListTile(Icons.sports_basketball, 'Habits', '/habbitsTracker'),
          buildListTile(Icons.calendar_month, 'Calendar', '/calendar'),
          buildListTile(Icons.inbox, 'Inbox', '/inbox'),
          buildListTile(Icons.create_rounded, 'Notes', '/notes'),
          buildListTile(Icons.add_chart_outlined, 'Dashboard', '/statistics'),
          const Center(
            child: Text(
              'v1.0.0',
              style: TextStyle(color: hintTxt),
            ),
          ),
        ],
      ),
    );
  }
}
