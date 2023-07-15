import 'package:flutter/material.dart';

import '../../common/presentation/presentation.dart';
import '../../services/local_storage_service/local_storage_service.dart';

export 'app_colors.dart';
export 'app_styles.dart';
export 'app_theme.dart';

enum AppThemeMode {
  light(ThemeMode.light),
  dark(ThemeMode.dark),
  system(ThemeMode.system),
  previousMode(ThemeMode.system);

  final ThemeMode mode;
  const AppThemeMode(this.mode);
}

class AppThemeManager extends AppViewModel {
  final AppTheme _lightTheme;
  final AppTheme? _darkTheme;
  final AppThemeMode _appThemeMode;
  final LocalStorageService _localStore;

  ThemeMode? _themeMode;

  AppThemeManager({
    required AppTheme lightTheme,
    required AppTheme? darkTheme,
    required LocalStorageService localStore,
    AppThemeMode appThemeMode = AppThemeMode.previousMode,
  })  : _lightTheme = lightTheme,
        _darkTheme = darkTheme,
        _localStore = localStore,
        _appThemeMode = appThemeMode;

  ThemeData? get lightTheme => _lightTheme.themeData;
  ThemeData? get darkTheme => _darkTheme?.themeData;

  ThemeMode get themeMode => _themeMode ?? ThemeMode.light;

  Future<void> initialise() async {
    if (_appThemeMode == AppThemeMode.previousMode) {
      final mode = await _getLastTheme();
      _themeMode = mode;
    } else {
      _themeMode = _appThemeMode.mode;
    }
  }

  Future<ThemeMode> _getLastTheme() async {
    final name = await _localStore.fetchString(LocalStoreKeys.THEME_MODE);
    final mode = ThemeMode.values.firstWhere(
      (element) => element.name == name,
      orElse: () => ThemeMode.light,
    );
    return mode;
  }

  void changeMode(ThemeMode mode) {
    if (mode == _themeMode) return;
    if (mode == ThemeMode.dark && _darkTheme == null) return;
    _themeMode = mode;
    _localStore.saveString(LocalStoreKeys.THEME_MODE, themeMode.name);
    setState();
  }
}
