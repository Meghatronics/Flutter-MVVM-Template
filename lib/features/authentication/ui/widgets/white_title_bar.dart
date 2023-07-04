import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../router/app_navigator.dart';
import '../../../../utilities/theming/app_colors.dart';
import '../../../../utilities/theming/app_styles.dart';
import '../../../shared/components/app_back_button.dart';

class WhiteTitleBar extends StatelessWidget {
  const WhiteTitleBar({
    super.key,
    required this.heading,
    this.subHeading,
  });

  final String heading;
  final String? subHeading;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (AppNavigator.canPop)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: AppBackButton(
                color: AppColors.of(context).primaryColor,
              ),
            ),
          Text(
            heading,
            textAlign: TextAlign.start,
            style: AppStyles.of(context).headerStyle,
          ).animate().fadeIn(
                begin: 0.2,
                duration: 500.milliseconds,
                curve: Curves.easeInOut,
              ),
          const SizedBox(height: 4),
          if (subHeading != null)
            Text(
              subHeading!,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontFamily: AppStyles.walsheimFontFamily,
                color: AppColors.of(context).bodyText,
                fontSize: 16.0,
                height: 24 / 16,
                fontWeight: FontWeight.w400,
              ),
            ).animate().fadeIn(
                  begin: 0.2,
                  duration: 800.milliseconds,
                  curve: Curves.easeInOut,
                ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
