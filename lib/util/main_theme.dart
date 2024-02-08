import 'package:flutter/material.dart';
import 'package:flutter_tests/util/color_palette.dart';

ThemeData mainTheme() => ThemeData(
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
    );
