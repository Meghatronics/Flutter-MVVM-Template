import 'package:flutter/material.dart';

import 'api_request.dart';

typedef Json = Map<String, dynamic>;

/// Service used to interact with external REST apps and apis
abstract class RestfulApiService {
  @protected
  final String baseUrl, apiVersion;

  @protected
  final bool isProd;

  @protected
  final Duration sendTimeout, receiveTimeout;


  RestfulApiService({
    required this.baseUrl,
    required this.apiVersion,
    required this.isProd,
    required this.sendTimeout,
    Duration? receiveTimeout,
  }) : receiveTimeout = receiveTimeout ?? sendTimeout;


  // bool get initialized => _ready;
  // bool _ready = false;
  // @mustCallSuper
  // bool init({
  //   required String baseUrl,
  //   required String apiVersion,
  //   required Duration sendTimeout,
  //   required bool isProd,
  //   Duration? receiveTimeout,
  // }) {
  //   if (!_ready) {
  //     baseUrl = baseUrl;
  //     apiVersion = apiVersion;
  //     _ready = true;
  //     return true;
  //   }
  //   return false;
  // }

  /// Sends a JSON request with the specified [request].
  ///
  /// Throws a [NetworkException], [TimeoutException], [ServerException], or [InputException] if there is an error.
  Future<Json> sendJson<T>({required ApiRequest request});

  /// Sends a multipart/form-data request with the specified [request].
  ///
  /// Throws a [NetworkException], [TimeoutException], [ServerException], or [InputException] if there is an error.
  Future<Json> sendFormData<T>({required ApiRequest request});
}
