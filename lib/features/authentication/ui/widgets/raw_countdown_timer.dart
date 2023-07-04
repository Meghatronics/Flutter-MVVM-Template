// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';

class RawCountdownTimerWidget extends StatefulWidget {
  const RawCountdownTimerWidget({
    super.key,
    required this.durationToTime,
    required this.builder,
    this.format = 'hh:mm:ss',
    this.expiredWidget,
    this.onExpired,
  });

  final Function(BuildContext context, String timeString) builder;

  /// Format in which the timer should display.
  /// Uses double digit for each time component.
  /// **hh** for hour. **mm** for minute. **ss** for seconds
  /// Format string should contain the above for what components you wish to show.
  ///
  /// *Note:* If a component is excluded in format, it will not be added to another component
  /// E.g. If timer is for a duration of 2 hours, 20 minutes, 30 seconds, and format is
  /// `mm mins ss seconds`,
  /// Output will be in the form *20 mins 30 seconds*
  /// And will show *60 mins 00 seconds* when 20 minutes is up
  final String format;

  /// This widget will be displayed instead of the timer, once and
  /// if the timer has expired. If not provided, the timer will stop
  /// at 0 (Showing in the provided format)
  final Widget? expiredWidget;

  /// method is called once, immediately timer expires.
  final VoidCallback? onExpired;
  final Duration durationToTime;

  @override
  State<RawCountdownTimerWidget> createState() =>
      _RawCountdownTimerWidgetState();
}

class _RawCountdownTimerWidgetState extends State<RawCountdownTimerWidget> {
  static const tickerDuration = Duration(seconds: 1);
  static const HOUR_KEY = 'hh';
  static const MINUTE_KEY = 'mm';
  static const SECONDS_KEY = 'ss';

  Timer? _timer;
  String _timeString = '';
  bool _expired = false;
  late int timeInSeconds;

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    timeInSeconds = widget.durationToTime.inSeconds;
    if (timeInSeconds <= 0) {
      _timeString = _convertSecondsToString(0);
      // if (widget.onExpired != null) widget.onExpired();
      _expired = true;
      return;
    }
    _timer = Timer.periodic(
      tickerDuration,
      (timer) {
        timeInSeconds--;
        setState(() {
          _timeString = _convertSecondsToString(timeInSeconds);
        });
        if (timeInSeconds <= 0) _expireTimer();
      },
    );
  }

  void _expireTimer() {
    if (widget.onExpired != null) widget.onExpired!();
    _timer?.cancel();
    setState(() {
      _expired = true;
    });
  }

  String _convertSecondsToString(int inSeconds) {
    final format = widget.format;
    int? hours, minutes, seconds;
    if (format.contains(HOUR_KEY)) {
      hours = inSeconds ~/ (60 * 60);
      inSeconds -= (hours * 60 * 60);
    }
    if (format.contains(MINUTE_KEY)) {
      minutes = inSeconds ~/ 60;
      inSeconds -= (minutes * 60);
    }
    seconds = inSeconds;

    return widget.format
        .replaceFirst(HOUR_KEY, _doubleDigitPadding(hours))
        .replaceFirst(MINUTE_KEY, _doubleDigitPadding(minutes))
        .replaceFirst(SECONDS_KEY, _doubleDigitPadding(seconds));
  }

  String _doubleDigitPadding(int? value) {
    if (value == null) return '';
    return value.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    if (_expired && widget.expiredWidget != null) return widget.expiredWidget!;

    return widget.builder(context, _timeString);
  }
}
