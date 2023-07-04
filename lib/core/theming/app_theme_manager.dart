import 'package:flutter/material.dart';

import '../../common/presentation/presentation.dart';

// import 'app_colors.dart';
// import 'app_styles.dart';
// import 'app_theme.dart';

export 'app_colors.dart';
export 'app_styles.dart';
export 'app_theme.dart';

class AppThemeManager extends ValueNotifier<AppTheme> {
  AppThemeManager()
      : super(
          AppTheme(
            colors: AppColors.defaultColors,
            headingFontFamily: AppStyles.defaultHeadingFont,
            bodyFontFamily: AppStyles.defaultBodyFont,
          ),
        );

  void changeTheme(AppTheme theme) {
    value = theme;
  }
}
