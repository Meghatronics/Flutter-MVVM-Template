import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

import '../../features/shared/models/user_model.dart';
import 'analytics_service.dart';

class MixpanelAnalyticsService extends AnalyticsService {
  final Mixpanel mixpanel;

  MixpanelAnalyticsService(this.mixpanel);

  @override
  void configure([bool shouldRecord = false]) {
    mixpanel.optInTracking();
    super.configure(shouldRecord);
  }

  @override
  Future<void> flushLogUpload() async {
    if (shouldRecord) return mixpanel.flush();
  }

  @override
  FutureOr<void> logEvent(String name, {Map<String, dynamic>? properties}) {
    if (shouldRecord) mixpanel.track(name, properties: properties);
  }

  @override
  FutureOr<void> logInUser(UserModel user) {
    if (shouldRecord) {
      mixpanel.identify(user.id);
      mixpanel.getPeople().set('\$email', user.email);
      mixpanel.getPeople().set('\$first_name', user.firstName);

      if (user.avatarUrl != null) {
        mixpanel.getPeople().set('\$avatar', user.avatarUrl);
      }
    }
  }

  @override
  FutureOr<void> logOutUser() {
    if (shouldRecord) mixpanel.reset();
  }

  @override
  NavigatorObserver get navigatorObserver =>
      shouldRecord ? _MixpanelNavigatorObserver(mixpanel) : NavigatorObserver();
}

class _MixpanelNavigatorObserver extends NavigatorObserver {
  final Mixpanel mixpanel;

  _MixpanelNavigatorObserver(
    this.mixpanel,
  );

  void _sendNavigationToMixPanel(Route route, Route? previousRoute) {
    final name = route.settings.name ?? 'Unnamed Route';
    mixpanel.track(
      'Screen View',
      properties: {'name': name},
    );
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (previousRoute != null) _sendNavigationToMixPanel(previousRoute, route);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _sendNavigationToMixPanel(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    if (newRoute != null) _sendNavigationToMixPanel(newRoute, oldRoute);
  }
}
