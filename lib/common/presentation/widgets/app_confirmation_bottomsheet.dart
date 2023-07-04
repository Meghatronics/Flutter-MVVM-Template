import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../core/navigation/app_navigator.dart';
import '../presentation.dart';
import 'components/app_bottom_sheet.dart';
import 'components/app_button_widget.dart';

class AppConfirmationSheet extends AppBottomSheet<bool> {
  AppConfirmationSheet({
    super.key,
    required String heading,
    required String? body,
    VoidCallback? yesOnPressed,
    String? yesLabel,
    String? cancelLabel,
    Widget? illustration,
  }) : super(
          heading: null,
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 32),
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 124,
                width: 124,
                child: illustration ??
                    Lottie.asset(
                      AppResources.i.attentionAnimation,
                    ),
              ),
              const SizedBox(height: 0),
              Text(
                heading,
                textAlign: TextAlign.center,
                style: AppStyles.of(context).heading24Regular,
              ),
              if (body != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    body,
                    style: AppStyles.of(context).body16Regular,
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: AppButton.outline(
                      label: 'Cancel',
                      onPressed: () => AppNavigator(context).pop(false),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppButton(
                      label: 'Yes',
                      onPressed:
                          yesOnPressed ?? () => AppNavigator(context).pop(true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
}
