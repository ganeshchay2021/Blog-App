import 'package:blogapp/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static _border({Color color=AppPalette.borderColor}) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: color,
          width: 2,
        ),
      );
  static final darkThemeMode = ThemeData.dark().copyWith(
    //Theme for chip widget
    chipTheme: const ChipThemeData(
      color: WidgetStatePropertyAll(AppPalette.backgroundColor),
      side: BorderSide.none
    ),

    //theme for appbar
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPalette.backgroundColor
    ),

    //theme for scafold
    scaffoldBackgroundColor: AppPalette.backgroundColor,

    //theme for textfield decoration
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      focusedErrorBorder:  _border(color: AppPalette.gradient2),
      enabledBorder: _border(),
      errorBorder: _border(color: AppPalette.errorColor),
      focusedBorder: _border(color: AppPalette.gradient2),
    ),
  );
}
