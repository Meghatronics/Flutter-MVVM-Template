import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import '../../features/shared/models/user_model.dart';
import 'analytics_service.dart';

class AppAnalyticsServiceImpl extends AnalyticsService {
  final FirebaseAnalytics firebaseAnalytics;

  AppAnalyticsServiceImpl({
    required this.firebaseAnalytics,
  });

  @override
  FutureOr<void> logInUser(UserModel user) async {
    if (shouldRecord) {
      //? Login for Firebase Analytics
      firebaseAnalytics.setUserId(id: user.id);
      firebaseAnalytics.setUserProperty(name: 'email', value: user.email);
    }
  }

  @override
  FutureOr<void> logOutUser() async {
    if (shouldRecord) {
      //? Logout for Firebase Analytics
      firebaseAnalytics.resetAnalyticsData();
    }
  }

  @override
  FutureOr<void> logEvent(
    String name, {
    Map<String, dynamic>? properties,
  }) async {
    if (!shouldRecord) return;
    /*  //? Log on MixPanel
    mixPanel.track(name, properties: properties); */
    //? Log on Firebase Analytics
    // Replaced all whitespace with '_' for firebase compatibility.
    final firebaseEventName = name.replaceAll(RegExp(r'\s\b|\b\s'), '_');
    firebaseAnalytics
        .logEvent(
          name: firebaseEventName,
          parameters: properties,
        )
        .catchError((_) => null);
  }

  @override
  NavigatorObserver get navigatorObserver => shouldRecord
      ? FirebaseAnalyticsObserver(analytics: firebaseAnalytics)
      : NavigatorObserver();

  @override
  Future<void> flushLogUpload() async {}
}
