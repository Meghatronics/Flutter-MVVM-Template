import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../common/data/app_exceptions.dart';
import '../../common/domain/session_manager.dart';
import 'api_request.dart';
import 'restful_api_service.dart';

/// Implementation of [RestfulApiService] using the Dio library.
class DioNetworkService extends RestfulApiService {
  final Dio _dio;
  final SessionManager sessionManager;

  DioNetworkService({
    required this.sessionManager,
    required super.baseUrl,
    required super.apiVersion,
    required super.isProd,
    required super.sendTimeout,
    super.receiveTimeout,
  }) : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: sendTimeout,
          sendTimeout: sendTimeout,
          receiveTimeout: receiveTimeout ?? sendTimeout,
        )) {
    _dio.interceptors.addAll([
      if (!isProd || kDebugMode) NetworkLoggerInterceptor(),
      DataErrorInterceptor(),
    ]);
  }

  /*  @override
  bool init({
    required String baseUrl,
    required String apiVersion,
    required Duration sendTimeout,
    required bool isProd,
    Duration? receiveTimeout,
  }) {
    if (!initialized) {
      _dio.options.baseUrl = Uri.http(baseUrl, apiVersion).toString();
      _dio.options.connectTimeout = sendTimeout;
      _dio.options.sendTimeout = sendTimeout;
      _dio.options.receiveTimeout = (receiveTimeout ?? sendTimeout);
      _dio.interceptors.addAll([
        if (!isProd || kDebugMode) NetworkLoggerInterceptor(),
        DataErrorInterceptor(),
      ]);
    }
    return super.init(
      baseUrl: baseUrl,
      apiVersion: apiVersion,
      sendTimeout: sendTimeout,
      isProd: isProd,
    );
  } */

  @override
  Future<Json> sendFormData<T>({required ApiRequest request}) async {
    // assert(initialized, 'This Network Service has not been initialized');
    final data = FormData.fromMap(
      request.body.map(
        (key, value) {
          if (value is File) {
            final type = lookupMimeType(value.path);
            final contentType = type != null ? MediaType.parse(type) : null;
            return MapEntry(
              key,
              MultipartFile.fromFileSync(
                value.path,
                contentType: contentType,
              ),
            );
          } else {
            return MapEntry(key, value);
          }
        },
      ),
    );
    try {
      final response = await _dio.request(
        request.endpoint,
        data: data,
        queryParameters: request.queryParams,
        options: Options(
          method: request.method,
          contentType: 'multipart/form-data',
          headers: sessionManager.sessionHeaders(request.useToken),
        ),
      );
      final res = response.data;
      if (res is! Map) {
        return {'data': res};
      }
      return res as Map<String, dynamic>;
    } on DioException catch (e) {
      throw e.error!;
    }
  }

  @override
  Future<Json> sendJson<T>({required ApiRequest request}) async {
    // assert(initialized, 'This Network Service has not been initialized');
    try {
      final headers = sessionManager.sessionHeaders(request.useToken);
      final response = await _dio.request(
        request.endpoint,
        data: request.body,
        queryParameters: request.queryParams,
        options: Options(
          method: request.method,
          contentType: 'Application/json',
          responseType: ResponseType.json,
          headers: headers,
        ),
      );
      final res = response.data;
      if (res is! Map) {
        return {'data': res};
      }
      return res as Map<String, dynamic>;
    } on DioException catch (e) {
      throw e.error!;
    }
  }
}

class DataErrorInterceptor extends Interceptor {
  DataErrorInterceptor();

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data is! Map) {
      response.data = {'data': response.data};
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.isNetworkError) {
      handler.next(DioException(
        requestOptions: err.requestOptions,
        error: NetworkException(),
      ));
    } else if (err.isTimeoutError) {
      handler.next(DioException(
        requestOptions: err.requestOptions,
        error: TimeoutException('Request Timed out. Try again'),
      ));
    } else if (err.isServerError) {
      String? message;
      if (err.response?.data is Map) {
        message = err.response?.data['message'];
      }
      handler.next(DioException(
        requestOptions: err.requestOptions,
        error: ServerException(errorMessage: message),
      ));
    } else {
      Map json;
      if (err.response == null) {
        json = {};
      } else if (err.response?.data is Map) {
        json = err.response!.data;
      } else {
        json = jsonDecode(err.response!.data);
      }
      handler.next(DioException(
        requestOptions: err.requestOptions,
        error: InputException(errorMessage: json['message']),
      ));
    }
  }
}

class NetworkLoggerInterceptor extends PrettyDioLogger {
  NetworkLoggerInterceptor()
      : super(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 88,
        );
}

extension DioExceptionExtension on DioException {
  bool get isTimeoutError => [
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
        DioExceptionType.connectionTimeout,
      ].contains(type);

  bool get isNetworkError =>
      error is SocketException || type == DioExceptionType.connectionError;

  bool get isServerError => (response?.statusCode ?? 501) >= 500;
}
