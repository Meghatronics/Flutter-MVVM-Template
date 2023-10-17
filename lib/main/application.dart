import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/presentation/presentation.dart';
import '../core/service_locator/service_locator.dart';
import '../l10n/generated/messages.dart';
import '../services/app_lifecycle_service/app_lifecycle_service.dart';
import 'environment_config.dart';

class ThisApplication extends StatefulWidget {
  const ThisApplication({super.key});

  @override
  State<ThisApplication> createState() => _ThisApplicationState();
}

class _ThisApplicationState extends State<ThisApplication> {
  late final AppThemeManager _themeManager;

  @override
  void initState() {
    AppLifecycleService.instance.initialise();
    _themeManager = AppThemeManager(
      lightTheme: AppTheme(
        colors: AppColors.defaultColors,
        headingFontFamily: AppStyles.defaultHeadingFont,
        bodyFontFamily: AppStyles.defaultBodyFont,
      ),
      darkTheme: null,
      localStore: ServiceLocator.get(),
      defaultMode: ThemeMode.system,
    );
    _themeManager.initialise();
    super.initState();
  }

  @override
  void dispose() {
    AppLifecycleService.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppViewBuilder<AppThemeManager>(
      model: _themeManager,
      initState: (vm) => vm.initialise(),
      builder: (themeManager, _) => MaterialApp(
        theme: themeManager.lightTheme,
        darkTheme: themeManager.darkTheme,
        themeMode: themeManager.themeMode,
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
        initialRoute: AppRoutes.splashRoute,
        routes: AppRoutes.routes,
        onGenerateRoute: AppRoutes.generateRoutes,
        navigatorKey: AppNavigator.mainKey,
        navigatorObservers: [AppNavigatorObserver.instance],
        builder: (context, widget) {
          if (kReleaseMode) {
            const errT = Text('A rendering error occured');
            ErrorWidget.builder = (errorDetails) {
              if (widget is Scaffold || widget is Navigator) {
                return const Scaffold(body: Center(child: errT));
              } else {
                return errT;
              }
            };
          }
          return widget ?? const Scaffold();
        },
      ),
    );
  }
}
