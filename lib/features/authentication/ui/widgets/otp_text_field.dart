import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../utilities/theming/app_colors.dart';
import '../../../../utilities/theming/app_styles.dart';

class OtpTextField extends StatelessWidget {
  const OtpTextField({
    super.key,
    required this.length,
    required this.controller,
    required this.validator,
    this.onChanged,
    this.onCompleted,
  });

  final int length;
  final TextEditingController controller;
  final String? Function(String v) validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size.width;
    const horizontalPadding = 48;
    final minimumSpacing = 10 * length;
    final spaceForFields = (screen - horizontalPadding - minimumSpacing);
    final width = (spaceForFields / length).clamp(32.0, 56.0);
    final outlineColor = AppColors.of(context).outlineColor;
    return PinCodeTextField(
      autoDisposeControllers: false,
      appContext: context,
      length: length,
      controller: controller,
      onChanged: onChanged ?? (_) {},
      onCompleted: onCompleted,
      keyboardType: TextInputType.number,
      animationType: AnimationType.scale,
      backgroundColor: Colors.transparent,
      textStyle: TextStyle(
        fontFamily: AppStyles.satoshiFontFamily,
        fontSize: 22,
        height: 28 / 22,
        color: AppColors.of(context).headerTextColor,
        fontWeight: FontWeight.w700,
      ),
      showCursor: false,
      autoFocus: true,
      enableActiveFill: false,
      errorTextSpace: 24,
      validator: (v) => validator(v ?? ''),
      pinTheme: PinTheme(
        borderRadius: BorderRadius.circular(5),
        activeFillColor: Colors.transparent,
        inactiveFillColor: Colors.transparent,
        selectedFillColor: Colors.transparent,
        activeColor: outlineColor,
        inactiveColor: outlineColor,
        selectedColor: outlineColor,
        disabledColor: outlineColor,
        fieldHeight: 48,
        fieldWidth: width,
        borderWidth: 1,
        shape: PinCodeFieldShape.box,
      ),
    );
  }
}
