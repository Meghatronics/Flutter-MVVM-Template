import 'package:flutter/material.dart';

import '../../../../core/navigation/app_navigator.dart';
import '../../presentation.dart';
import 'app_button_widget.dart';

class AppDatePicker extends StatefulWidget {
  const AppDatePicker({
    super.key,
    required this.initialSelection,
    required this.firstDate,
    required this.lastDate,
    this.title,
  });

  final String? title;
  final DateTime? initialSelection;
  final DateTime firstDate;
  final DateTime lastDate;

  Future<DateTime?> show([BuildContext? context]) {
    final navigator =
        context != null ? AppNavigator(context) : AppNavigator.main;
    return navigator.openDialog<DateTime>(
      routeName: 'CustomDatePicker(${title ?? 'No Title'})',
      dialog: this,
    );
  }

  @override
  State<AppDatePicker> createState() => _AppDatePickerState();
}

class _AppDatePickerState extends State<AppDatePicker> {
  late DateTime _selectedDate;

  @override
  void initState() {
    _selectedDate = widget.initialSelection ?? widget.lastDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.of(context).primaryColor;
    final headerTextColor = AppColors.of(context).primaryColor;
    final backgroundColor = AppColors.of(context).backgroundColor;

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: TextTheme(
          bodySmall: AppStyles.of(context).body14Regular,
          titleSmall: AppStyles.of(context).body14Medium,
        ),
        canvasColor: backgroundColor,
        colorScheme: ColorScheme(
          onPrimary: backgroundColor,
          onSurface: headerTextColor,
          primary: primaryColor,
          background: backgroundColor,
          brightness: Brightness.dark,
          error: AppColors.of(context).attitudeErrorDark,
          onBackground: backgroundColor,
          onError: AppColors.of(context).attitudeErrorDark,
          onSecondary: backgroundColor,
          secondary: primaryColor,
          surface: backgroundColor,
        ),
        dialogBackgroundColor: backgroundColor,
      ),
      child: Dialog(
        insetPadding: const EdgeInsets.all(20),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.title != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  widget.title!,
                  style: AppStyles.of(context).heading16Regular,
                ),
              ),
            CalendarDatePicker(
              initialDate: _selectedDate,
              firstDate: widget.firstDate,
              lastDate: widget.lastDate,
              onDateChanged: (date) {
                _selectedDate = date;
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16, left: 16, bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 88,
                    height: 48,
                    child: AppButton(
                      onPressed: () =>
                          AppNavigator(context).maybePop(_selectedDate),
                      label: 'Select',
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 88,
                    height: 48,
                    child: AppButton.outline(
                      onPressed: () => AppNavigator(context).maybePop(null),
                      label: 'Cancel',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
