import 'package:flutter/material.dart';
import 'package:flutter_tests/util/color_palette.dart';

ThemeData mainTheme() => ThemeData(
    fontFamily: 'Campton',
    drawerTheme: const DrawerThemeData(
      scrimColor: Colors.transparent,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      toolbarTextStyle: TextStyle(fontSize: 24, color: brand),
      iconTheme: IconThemeData(size: 24, color: brand),
      color: bg,
      foregroundColor: brand,
    ),
    scaffoldBackgroundColor: bg,
    shadowColor: shadowDark,
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide.none,
      ),
      outlineBorder: BorderSide.none,
      counterStyle: TextStyle(
        color: txt,
      ),
      hintStyle: TextStyle(
        color: hintTxt,
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    ),
    textSelectionTheme:
        const TextSelectionThemeData(selectionColor: brand, cursorColor: brand),
    textTheme: const TextTheme());
