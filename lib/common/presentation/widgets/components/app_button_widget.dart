import 'package:flutter/material.dart';

import '../../presentation.dart';
import 'app_loader_widget.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.busy = false,
    this.color,
    this.textColor = Colors.white,
    this.enabled = true,
  }) : _isOutline = false;

  const AppButton.outline({
    super.key,
    required this.label,
    required this.onPressed,
    this.busy = false,
    this.color = Colors.white,
    Color outlineColor = const Color(0xFF325CAB),
    this.enabled = true,
  })  : _isOutline = true,
        textColor = outlineColor;

  final String label;
  final bool busy;
  final bool enabled;
  final VoidCallback onPressed;
  final Color? color;
  final Color textColor;

  final bool _isOutline;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: enabled && !busy
          ? () {
              FocusScope.of(context).unfocus();
              onPressed();
            }
          : null,
      style: ButtonStyle(
        textStyle:
            MaterialStateProperty.all(AppStyles.of(context).body14Medium),
        minimumSize: MaterialStateProperty.all(const Size.fromHeight(56)),
        backgroundColor: MaterialStateColor.resolveWith((states) {
          if (_isOutline) return Colors.transparent;
          if (states.contains(MaterialState.disabled)) {
            return AppColors.of(context).grey4;
          }
          return color ?? AppColors.of(context).primaryColor;
        }),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: _isOutline
                ? BorderSide(width: 1, color: textColor)
                : BorderSide.none,
          ),
        ),
      ),
      child: busy
          ? const AppLoaderWidget()
          : Text(
              label,
              style: AppStyles.of(context).body16Regular,
            ),
    );
  }
}
