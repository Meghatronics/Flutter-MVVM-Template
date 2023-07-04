import 'package:flutter/material.dart';

import '../../../../utilities/extensions/string_extension.dart';
import '../../../../utilities/theming/app_colors.dart';
import '../../../../utilities/theming/app_styles.dart';
import '../../domain/models/login_method_enum.dart';

class LoginMethodSwitchButton extends StatelessWidget {
  const LoginMethodSwitchButton({
    super.key,
    required this.loginMethod,
    required this.onTapped,
  });
  final LoginMethod loginMethod;
  final ValueChanged<LoginMethod> onTapped;

  @override
  Widget build(BuildContext context) {
    return ExcludeFocus(
      child: Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: SizedBox(
          width: 48,
          child: InkResponse(
            onTap: () => onTapped(loginMethod),
            child: Center(
              child: Text(
                'Use ${loginMethod.name.capitalize()}',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: AppStyles.satoshiFontFamily,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: AppColors.of(context).primaryColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
