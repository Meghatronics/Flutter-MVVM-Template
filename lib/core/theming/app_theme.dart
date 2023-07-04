import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_styles.dart';

class AppTheme {
  final AppColors colors;
  final String headingFontFamily;
  final String bodyFontFamily;
  final AppStyles styles;

  AppTheme({
    required this.colors,
    required this.headingFontFamily,
    required this.bodyFontFamily,
  }) : styles = AppStyles(
          colors: colors,
          headingFontFamily: headingFontFamily,
          bodyFontFamily: bodyFontFamily,
        );

  ThemeData get themeData => ThemeData(
        // TODO set everything
        scaffoldBackgroundColor: colors.backgroundColor,
        primaryColor: colors.primaryColor,
        appBarTheme: AppBarTheme(backgroundColor: colors.primaryColor),
        splashColor: colors.attitudeErrorMain,
        extensions: [colors, styles],
      );
}
