import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../common/domain/session_manager.dart';
import '../../main/environment_config.dart';
import '../../services/error_logging_service/error_logging_service.dart';
import '../../services/local_storage_service/flutter_secure_local_storage_service.dart';
import '../../services/local_storage_service/local_storage_service.dart';
import '../../services/restful_api_service/dio_network_service.dart';
import '../../services/restful_api_service/restful_api_service.dart';
import '../../utilities/constants/constants.dart';
import 'feature_dependencies.dart';

abstract class ServiceLocator {
  final GetIt locator;
  ServiceLocator(this.locator);

  FutureOr<void> register();

  static final get = GetIt.instance;
  static Future<void> registerDependencies() async {
    final services = _ServiceDependencies(get);
    final features = FeatureDependencies(get);

    services.register();
    features.register();
  }

  static Future<void> reset() async {
    await get.reset();
    await registerDependencies();
  }

  static resetInstance<T extends Object>() {
    get.resetLazySingleton<T>();
  }
}

class _ServiceDependencies extends ServiceLocator {
  _ServiceDependencies(super.locator);

  @override
  FutureOr<void> register() {
    locator.registerLazySingleton(() => SessionManager(
          localStorageService: locator(),
          errorLogService: locator(),
        ));

    locator.registerFactory<LocalStorageService>(
      () => FlutterSecureLocalStorage(
        flutterSecureStorage: const FlutterSecureStorage(),
      ),
    );

    locator.registerLazySingleton<RestfulApiService>(() => DioNetworkService(
          sessionManager: locator(),
          baseUrl: EnvironmentConfig.apiUrl,
          apiVersion: EnvironmentConfig.apiVersion,
          sendTimeout: Constants.networkTimeoutDuration,
          isProd: EnvironmentConfig.isProd,
        ));

    locator.registerLazySingleton<ErrorLogService>(() {
      final service = ErrorLogService.instance;
      service.initialise(isDebug: EnvironmentConfig.isProd);
      return service;
    });
  }
}
