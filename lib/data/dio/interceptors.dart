import 'dart:convert';
import 'dart:io';

import 'package:demo_base_riverpod_1/data/api/api_exception.dart';
import 'package:demo_base_riverpod_1/data/api/failure.dart';
import 'package:demo_base_riverpod_1/data/dio/app_dio.dart';
import 'package:demo_base_riverpod_1/utils/log_utils.dart';
import 'package:dio/dio.dart';

class HandleInterceptors extends QueuedInterceptorsWrapper {
  final AppDio appDio;

  HandleInterceptors(this.appDio);

  //TODO header
  Map<String, String> get headers {
    //String acceptLanguage = "en-US";
    // if (SPrefLocaleModel().getLocale() == Constants.ja) {
    //   acceptLanguage = "ja-JP";
    // }
    // if (SPrefLocaleModel().getLocale() == Constants.vi) {
    //   acceptLanguage = "vi-VN";
    // }

    return <String, String>{
      'Accept': '*/*',
    };
  }

  Map<String, String> get authorizedHeaders {
    return headers..putIfAbsent('Authorization', () => "Bearer");
  }

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    final path = err.requestOptions.path;
    final statusCode = err.response?.statusCode;
    final bodyFailure = err.response?.data?.toString() ?? "";
    LogUtils.d("【API:ERROR/$statusCode】【$path】【$bodyFailure】 $err");
    if (_isNetworkError(err)) {
      LogUtils.d("【interceptor:error】【$path】 network error ...");
      handler.reject(NoInternetException(err.requestOptions, null));

      return;
    }
    if (_isTimeoutException(err)) {
      LogUtils.d("【interceptor:error】【$path】 timeout error ...");
      // Retry api
      handler.reject(AppTimeOutException(
        err.requestOptions,
        Failure(errorCode: -4, message: "Error internet"),
      ));
    }
    Failure? failure;
    try {
      dynamic responseJson = jsonDecode(bodyFailure == "" ? "{}" : bodyFailure);
      failure = Failure.fromJson(
        responseJson as Map<String, dynamic>,
      );
    } on Exception {
      failure = Failure(message: bodyFailure, errorCode: statusCode);
    }
    if (statusCode != null) {
      switch (statusCode) {
        case 400:
          handler.reject(BadRequestException(err.requestOptions, failure));
          break;
        case 401:
          //ToDo: handle refresh token
          break;
        case 403:
          handler.reject(ForbiddenException(err.requestOptions, failure));
          break;
        case 500:
          handler.reject(FetchDataException(err.requestOptions, failure));
          break;
        case 504:
          handler.reject(ServerTimeOutException(err.requestOptions, failure));
          break;
        case 503:
          handler
              .reject(ServerUnavailableException(err.requestOptions, failure));
          break;
        default:
          handler.next(err);
          break;
      }
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    LogUtils.d("onRequest -> [options.path] => ${options.path}");
    options.headers = authorizedHeaders;
    super.onRequest(options, handler);
  }

  bool _isNetworkError(DioError err) {
    return err.error != null &&
        (err.error is SocketException || err.error is HttpException);
  }

  bool _isTimeoutException(DioError err) {
    return err.type == DioErrorType.sendTimeout ||
        err.type == DioErrorType.connectTimeout ||
        err.type == DioErrorType.receiveTimeout;
  }
}
