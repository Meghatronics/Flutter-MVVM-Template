import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;
  final Color backgroundColor;
  final Color overlayBackground;
  final Color textStrong;
  final Color textMedium;
  final Color textMute;
  final Color grey1;
  final Color grey2;
  final Color grey3;
  final Color grey4;
  final Color grey5;
  final Color attitudeErrorLight;
  final Color attitudeErrorMain;
  final Color attitudeErrorDark;
  final Color attitudeSuccessLight;
  final Color attitudeSuccessMain;
  final Color attitudeSuccessDark;
  final Color attitudeWarningLight;
  final Color attitudeWarningMain;
  final Color attitudeWarningDark;
  final Color attitudeInfoLight;
  final Color attitudeInfoMain;
  final Color attitudeInfoDark;

  const AppColors({
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.backgroundColor,
    required this.overlayBackground,
    required this.textStrong,
    required this.textMedium,
    required this.textMute,
    required this.grey1,
    required this.grey2,
    required this.grey3,
    required this.grey4,
    required this.grey5,
    required this.attitudeErrorLight,
    required this.attitudeErrorMain,
    required this.attitudeErrorDark,
    required this.attitudeSuccessLight,
    required this.attitudeSuccessMain,
    required this.attitudeSuccessDark,
    required this.attitudeWarningLight,
    required this.attitudeWarningMain,
    required this.attitudeWarningDark,
    required this.attitudeInfoLight,
    required this.attitudeInfoMain,
    required this.attitudeInfoDark,
  });

  static AppColors of(BuildContext context) {
    final theme = Theme.of(context).extension<AppColors>();
    if (theme == null) {
      throw Exception('AppColors has not been added to app theme extensions');
    }
    return theme;
  }

  static const defaultColors = AppColors(
    primaryColor: Color(0xFF00F9BE),
    secondaryColor: Color(0xFF011936),
    tertiaryColor: Color(0xFF009F6B),
    backgroundColor: Color(0xFF03261D),
    overlayBackground: Color(0xFF03441D),
    textStrong: Color(0xFFE4FEF8),
    textMedium: Color(0xFFC5D0CF),
    textMute: Color(0xFF9EA7A5),
    grey1: Color(0xFFCDD4D2),
    grey2: Color(0xFFABB7B4),
    grey3: Color(0xFF81938E),
    grey4: Color(0xFF576E68),
    grey5: Color(0xFF2D4A43),
    attitudeErrorLight: Color(0xFFFDDEDE),
    attitudeErrorMain: Color(0xFFF75859),
    attitudeErrorDark: Color(0xFF7C2C2D),
    attitudeSuccessLight: Color(0xFFCCECE4),
    attitudeSuccessMain: Color(0xFF009F7A),
    attitudeSuccessDark: Color(0xFF00503D),
    attitudeWarningLight: Color(0xFFFFEDDC),
    attitudeWarningMain: Color(0xFFFFA552),
    attitudeWarningDark: Color(0xFF805229),
    attitudeInfoLight: Color(0xFFD6EBFF),
    attitudeInfoMain: Color(0xFF339DFF),
    attitudeInfoDark: Color(0xFF113455),
  );

  @override
  AppColors copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? tertiaryColor,
    Color? backgroundColor,
    Color? overlayBackground,
    Color? textStrong,
    Color? textMedium,
    Color? textMute,
    Color? grey1,
    Color? grey2,
    Color? grey3,
    Color? grey4,
    Color? grey5,
    Color? attitudeErrorLight,
    Color? attitudeErrorMain,
    Color? attitudeErrorDark,
    Color? attitudeSuccessLight,
    Color? attitudeSuccessMain,
    Color? attitudeSuccessDark,
    Color? attitudeWarningLight,
    Color? attitudeWarningMain,
    Color? attitudeWarningDark,
    Color? attitudeInfoLight,
    Color? attitudeInfoMain,
    Color? attitudeInfoDark,
  }) {
    return AppColors(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      tertiaryColor: tertiaryColor ?? this.tertiaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      overlayBackground: overlayBackground ?? this.overlayBackground,
      textStrong: textStrong ?? this.textStrong,
      textMedium: textMedium ?? this.textMedium,
      textMute: textMute ?? this.textMute,
      grey1: grey1 ?? this.grey1,
      grey2: grey2 ?? this.grey2,
      grey3: grey3 ?? this.grey3,
      grey4: grey4 ?? this.grey4,
      grey5: grey5 ?? this.grey5,
      attitudeErrorLight: attitudeErrorLight ?? this.attitudeErrorLight,
      attitudeErrorMain: attitudeErrorMain ?? this.attitudeErrorMain,
      attitudeErrorDark: attitudeErrorDark ?? this.attitudeErrorDark,
      attitudeSuccessLight: attitudeSuccessLight ?? this.attitudeSuccessLight,
      attitudeSuccessMain: attitudeSuccessMain ?? this.attitudeSuccessMain,
      attitudeSuccessDark: attitudeSuccessDark ?? this.attitudeSuccessDark,
      attitudeWarningLight: attitudeWarningLight ?? this.attitudeWarningLight,
      attitudeWarningMain: attitudeWarningMain ?? this.attitudeWarningMain,
      attitudeWarningDark: attitudeWarningDark ?? this.attitudeWarningDark,
      attitudeInfoLight: attitudeInfoLight ?? this.attitudeInfoLight,
      attitudeInfoMain: attitudeInfoMain ?? this.attitudeInfoMain,
      attitudeInfoDark: attitudeInfoDark ?? this.attitudeInfoDark,
    );
  }

  @override
  AppColors lerp(covariant AppColors? other, double t) {
    return other ?? this;
  }
}
