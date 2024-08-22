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
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPalette.backgroundColor
    ),
    scaffoldBackgroundColor: AppPalette.backgroundColor,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      focusedErrorBorder:  _border(color: AppPalette.gradient2),
      enabledBorder: _border(),
      errorBorder: _border(color: AppPalette.errorColor),
      focusedBorder: _border(color: AppPalette.gradient2),
    ),
  );
}
