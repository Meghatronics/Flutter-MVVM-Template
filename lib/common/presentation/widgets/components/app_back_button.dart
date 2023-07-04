import 'package:flutter/material.dart';

import '../../../../core/navigation/app_navigator.dart';
import '../../presentation.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({this.color, super.key});
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: runtimeType,
      transitionOnUserGestures: true,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: AppNavigator.main.maybePop,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.keyboard_backspace_rounded,
                color: color ?? AppColors.of(context).primaryColor,
              ),
              Text(
                'Back',
                style: AppStyles.of(context).label14Regular.copyWith(
                      color: color ?? AppColors.of(context).primaryColor,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
