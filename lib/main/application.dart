import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../common/presentation/presentation.dart';
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
      darkTheme: AppTheme(
        colors: AppColors.defaultColors.copyWith(
          backgroundColor: Colors.orange,
          primaryColor: Colors.orange,
        ),
        headingFontFamily: AppStyles.defaultHeadingFont,
        bodyFontFamily: AppStyles.defaultBodyFont,
      ),
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
        initialRoute: '/',
        navigatorKey: AppNavigator.mainKey,
        routes: AppRoutes.routes,
        onGenerateRoute: AppRoutes.generateRoutes,
        navigatorObservers: [AppNavigatorObserver.instance],
      ),
    );
  }
}
