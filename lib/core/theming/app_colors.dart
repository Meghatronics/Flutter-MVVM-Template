import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  final Color primaryColor;
  final Color secondaryColor;
  final Color alternateColor;
  final Color backgroundColor;
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
    required this.alternateColor,
    required this.backgroundColor,
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
    primaryColor: Color(0XFF00F9BE),
    secondaryColor: Color(0XFF011936),
    alternateColor: Color(0XFF009F6B),
    backgroundColor: Color(0XFF03261D),
    textStrong: Color(0XFFE4FEF8),
    textMedium: Color(0XFFC5D0CF),
    textMute: Color(0XFF9EA7A5),
    grey1: Color(0XFFCDD4D2),
    grey2: Color(0XFFABB7B4),
    grey3: Color(0XFF81938E),
    grey4: Color(0XFF576E68),
    grey5: Color(0XFF2D4A43),
    attitudeErrorLight: Color(0XFFFDDEDE),
    attitudeErrorMain: Color(0XFFF75859),
    attitudeErrorDark: Color(0XFF7C2C2D),
    attitudeSuccessLight: Color(0XFFCCECE4),
    attitudeSuccessMain: Color(0XFF009F7A),
    attitudeSuccessDark: Color(0XFF00503D),
    attitudeWarningLight: Color(0XFFFFEDDC),
    attitudeWarningMain: Color(0XFFFFA552),
    attitudeWarningDark: Color(0XFF805229),
    attitudeInfoLight: Color(0XFFD6EBFF),
    attitudeInfoMain: Color(0XFF339DFF),
    attitudeInfoDark: Color(0XFF113455),
  );

  @override
  ThemeExtension<AppColors> copyWith({
    Color? primaryColor,
    Color? secondaryMainBlue,
    Color? secondaryMainGreen,
    Color? backgroundDark,
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
      secondaryColor: secondaryMainBlue ?? this.secondaryColor,
      alternateColor:
          secondaryMainGreen ?? this.alternateColor,
      backgroundColor: backgroundDark ?? this.backgroundColor,
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
  ThemeExtension<AppColors> lerp(
      covariant ThemeExtension<AppColors>? other, double t) {
    return other ?? this;
  }
}
