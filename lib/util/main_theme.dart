import 'package:flutter/material.dart';
import 'package:ToDoDude/util/color_palette.dart';

ThemeData mainTheme() => ThemeData(
    fontFamily: 'Campton',
    drawerTheme: const DrawerThemeData(
      scrimColor: Colors.transparent,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      toolbarTextStyle: TextStyle(
        fontSize: 24,
        color: brand,
      ),
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
      hintStyle: TextStyle(
        color: hintTxt,
        letterSpacing: 1.5,
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
        side: WidgetStateBorderSide.resolveWith(
          (states) => const BorderSide(
            width: 1.0,
            color: brand,
          ),
        ),
      ),
      fillColor: WidgetStateProperty.all(bg),
      checkColor: WidgetStateProperty.all(brand),
    ),
    textSelectionTheme: const TextSelectionThemeData(selectionColor: brand, cursorColor: brand),
    textTheme: const TextTheme(
        // bodyMedium: TextStyle(letterSpacing: 1.5),
        ));
