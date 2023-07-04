import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/navigation/app_navigator.dart';
import '../core/navigation/app_navigator_stack.dart';
import '../core/theming/app_theme_manager.dart';
import '../l10n/generated/messages.dart';
import '../services/app_lifecycle_service/app_lifecycle_service.dart';
import 'environment_config.dart';

class ThisApplication extends StatefulWidget {
  const ThisApplication({super.key});

  @override
  State<ThisApplication> createState() => _ThisApplicationState();
}

class _ThisApplicationState extends State<ThisApplication> {
  @override
  void initState() {
    AppLifecycleService.instance.initialise();
    super.initState();
  }

  @override
  void dispose() {
    AppLifecycleService.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: AppThemeManager(),
      builder: (ctx, currentTheme, _) => MaterialApp(
        debugShowCheckedModeBanner: !EnvironmentConfig.isProd,
        title: EnvironmentConfig.appName,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('es'),
        ],
        initialRoute: '',
        navigatorKey: AppNavigator.mainKey,
        routes: AppRoutes.routes,
        onGenerateRoute: AppRoutes.generateRoutes,
        navigatorObservers: [AppNavigatorObserver.instance],
        theme: currentTheme.themeData,
      ),
    );
  }
}
