import 'package:flutter/material.dart';

import '../../../../utilities/theming/app_colors.dart';
import 'raw_countdown_timer.dart';

class CountdownTimerDisplayWidget extends RawCountdownTimerWidget {
  CountdownTimerDisplayWidget.fromDateTime(
    DateTime dateTime, {
    String format = 'hh:mm:ss',
    TextStyle? style,
    VoidCallback? onExpired,
    Widget? expiredWidget,
    Key? key,
    Widget? prefix,
    Widget? suffix,
  }) : super(
          key: key ?? const ValueKey('timer_display_widget'),
          durationToTime: dateTime.difference(DateTime.now()),
          format: format,
          expiredWidget: expiredWidget,
          onExpired: onExpired,
          builder: (context, time) {
            return Wrap(
              // mainAxisSize: MainAxisSize.min,
              children: [
                prefix ?? const SizedBox.shrink(),
                Text(
                  time,
                  style: style ??
                      TextStyle(
                        color: AppColors.of(context).bodyText,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                ),
                suffix ?? const SizedBox.shrink(),
              ],
            );
          },
        );

  CountdownTimerDisplayWidget.fromDuration(
    Duration duration, {
    String format = 'hh:mm:ss',
    TextStyle? style,
    VoidCallback? onExpired,
    Widget? expiredWidget,
    Key? key,
    Widget? prefix,
    Widget? suffix,
  }) : super(
          key: key ?? const ValueKey('timer_display_widget'),
          durationToTime: duration,
          format: format,
          expiredWidget: expiredWidget,
          onExpired: onExpired,
          builder: (context, time) {
            return Wrap(
              // mainAxisSize: MainAxisSize.min,
              children: [
                prefix ?? const SizedBox.shrink(),
                Text(
                  time,
                  style: style ??
                      TextStyle(
                        color: AppColors.of(context).bodyText,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                ),
                suffix ?? const SizedBox.shrink(),
              ],
            );
          },
        );
}
