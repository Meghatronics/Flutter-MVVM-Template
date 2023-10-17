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
        scaffoldBackgroundColor: colors.backgroundColor,
        primaryColor: colors.primaryColor,
        appBarTheme: AppBarTheme(backgroundColor: colors.primaryColor),
        splashColor: colors.tertiaryColor,
        extensions: [colors, styles],
        textTheme: TextTheme(
          bodySmall: styles.body14Regular,
          titleSmall: styles.body14Medium,
        ),
        canvasColor: colors.backgroundColor,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: colors.attitudeErrorMain,
          selectionColor: colors.grey3,
          selectionHandleColor: colors.secondaryColor,
        ),
        colorScheme: ColorScheme(
          primary: colors.primaryColor,
          onPrimary: colors.backgroundColor,
          secondary: colors.secondaryColor,
          onSecondary: colors.backgroundColor,
          background: colors.backgroundColor,
          onBackground: colors.backgroundColor,
          surface: colors.backgroundColor,
          onSurface: colors.textStrong,
          error: colors.attitudeErrorDark,
          onError: colors.attitudeErrorDark,
          brightness: Brightness.dark,
        ),
        dialogBackgroundColor: colors.backgroundColor,
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: colors.backgroundColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(32),
            ),
          ),
        ),
      );
}
