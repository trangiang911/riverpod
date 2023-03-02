import 'dart:convert';

import 'package:demo_base_riverpod_1/data/config/flavor_config.dart';
import 'package:demo_base_riverpod_1/data/constants/constants.dart';
import 'package:demo_base_riverpod_1/data/dio/interceptors.dart';
import 'package:demo_base_riverpod_1/utils/log_utils.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AppDio with DioMixin implements Dio {
  static String baseUrl =
      "${FlavorConfig.instance!.baseApiUrl}${FlavorConfig.instance!.versionApi}";

  static String? get savingLogUrl {
    return "${FlavorConfig.instance!.saveRidingLogApiUrl}${FlavorConfig.instance!.saveRidingLogVersionApi}";
  }

  String latestResponseTs = "";

  AppDio._([BaseOptions? options]) {
    options = BaseOptions(
      contentType: 'application/json',
      connectTimeout: Constants.timeConnectTimeout,
      sendTimeout: Constants.timeSendTimeout,
      receiveTimeout: Constants.timeReceiveTimeout,
    );

    this.options = options;

    // Firebase Performance
    // interceptors.add(DioFirebasePerformanceInterceptor()); // TODO: Add when feature firebase apply
    interceptors.add(HandleInterceptors(this));

    if (kDebugMode) {
      // Local Log
      interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
    }
    httpClientAdapter = DefaultHttpClientAdapter()
      ..onHttpClientCreate = (client) {
        /// https://github.com/dart-lang/http/issues/267
        /// https://github.com/dart-lang/http/issues/14
        client.badCertificateCallback = (cert, host, port) => true;

        return client;
      };
  }

  static AppDio? _instance;

  factory AppDio() => _instance ??= AppDio._();

  Object? convertResponseToObject(
      Response<String> response,
      String serviceName,
      String apiUrl,
      ) {
    LogUtils.d(
      "[$serviceName]API:【$apiUrl】[RESPONSE_RESULT] [${response.statusCode}]",
    );
    final body = response.data ?? "";
    LogUtils.d("[RESPONSE_BODY] => $body");
    dynamic responseJson = jsonDecode(body == "" ? "{}" : body);
    if (response.statusCode == 200) {
      LogUtils.d("[$serviceName]API:【$apiUrl】[responseJson] $responseJson");

      return _convertResponseJson(responseJson);
    }

    return null;
  }

  Object _convertResponseJson(dynamic responseJson) {
    if (responseJson['result'] is Map) {
      return responseJson['result'] as Map<String, dynamic>;
    } else if (responseJson['result'] is List) {
      return responseJson['result'] as List<dynamic>;
    } else {
      return responseJson as Map<String, dynamic>;
    }
  }

  Uri _parseURI(String path) {
    final uri = Uri.parse(path);

    return uri.isAbsolute ? uri : Uri.parse("$baseUrl$path");
  }

  Uri processUri({required String url, String? param}) {
    String? othersVersion = FlavorConfig.instance!.othersVersionApi![url];
    bool useBaseUrl = othersVersion != null && othersVersion.isNotEmpty;
    String baseUrl = url;
    if (useBaseUrl) {
      baseUrl = "${FlavorConfig.instance!.baseApiUrl}$othersVersion$url";
    }
    if (param != null) {
      baseUrl = baseUrl + param;
    }

    return useBaseUrl ? Uri.parse(baseUrl) : _parseURI(baseUrl);
  }
}
