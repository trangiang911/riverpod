// HTTP Error 100 – Data Empty
// HTTP Error 102 – Multiple Fail
// HTTP Error 401 – Unauthorized
// HTTP Error 400 – Bad Request
// HTTP Error 404 – Page Not Found
// HTTP Error 403 – Forbidden Error
// HTTP Error 500 – Internal Error
// HTTP Error 503 – Service Unavailable
// HTTP Error 504 - Request Timeout Error

import 'package:demo_base_riverpod_1/data/constants/constants.dart';
import 'package:dio/dio.dart';

import 'failure.dart';

enum StatusCode {
  none,
  success,
  noInternet,
  unauthorized,
  dataEmpty,
  multipleFail,
  badRequest,
  pageNotFound,
  forbiddenError,
  internalError,
  serviceUnavailable,
  conflict,
  myQRCodeTokenInvalid,
  serverTimeOutError,
  appTimeOutError,
  login100Error,
  login1100Error,
  timeout400Error,
}

extension StatusCodeExtension on StatusCode {
  int get value {
    switch (this) {
      case StatusCode.internalError:
        return 500;
      case StatusCode.forbiddenError:
        return 403;
      case StatusCode.badRequest:
        return 400;
      case StatusCode.unauthorized:
        return 401;
      case StatusCode.serviceUnavailable:
        return 503;
      case StatusCode.serverTimeOutError:
        return 504;
      case StatusCode.appTimeOutError:
        return -4;
      default:
        return 0;
    }
  }
}

class ApiException extends DioError {
  final String? _prefix;
  final StatusCode? _statusCode;
  final Failure? failure;

  ApiException(
    RequestOptions requestOptions, [
    this._prefix,
    this._statusCode,
    this.failure,
  ]) : super(requestOptions: requestOptions);

  int? get errorCode => failure?.errorCode;

  StatusCode? get statusCode => _statusCode;

  int? get errorCodeScreen {
    switch (_statusCode!.value) {
      case 200:
        return Constants.noErrorCode;
      case 400:
        return Constants.errorCode400;
      case 404:
        return Constants.errorCode404;
      case 500:
        return Constants.errorCode500;
      case 503:
        return Constants.errorCode503;
      case 504:
        return Constants.errorCode504;
      case -4:
        return Constants.appTimeOutError;
      default:
        return -2;
    }
  }

  @override
  String toString() {
    String errorMessage = Constants.stringEmpty;
    if (errorCode != null) {
      errorMessage = "[${failure!.errorCode}] ${failure!.message}";
    }

    return "[${_statusCode!.value}][$_statusCode]$_prefix$errorMessage";
  }
}

/// サーバー内部のプログラムエラー
/// 500
class FetchDataException extends ApiException {
  FetchDataException(RequestOptions requestOptions, [Failure? failure])
      : super(
          requestOptions,
          "Error during communication: ",
          StatusCode.internalError,
          failure,
        );
}

/// 403
class ForbiddenException extends ApiException {
  ForbiddenException(RequestOptions requestOptions, [Failure? failure])
      : super(
          requestOptions,
          "Forbidden error[会員資格が無効] : ",
          StatusCode.forbiddenError,
          failure,
        );
}

/// パラメータ不正
/// 400
class BadRequestException extends ApiException {
  BadRequestException(RequestOptions requestOptions, [Failure? failure])
      : super(
          requestOptions,
          "Invalid request: ",
          StatusCode.badRequest,
          failure,
        );
}

/// アクセストークンが不正 or 会員資格が無効
/// 401
class UnauthorisedException extends ApiException {
  UnauthorisedException(RequestOptions requestOptions, [Failure? failure])
      : super(
          requestOptions,
          "Unauthorised request: ",
          StatusCode.unauthorized,
          failure,
        );
}

class IgnoreException extends ApiException {
  IgnoreException(RequestOptions requestOptions, [Failure? failure])
      : super(
          requestOptions,
          "Ignore request: ",
          StatusCode.unauthorized,
          failure,
        );
}

/// サーバーが停止している
/// 503
class ServerUnavailableException extends ApiException {
  ServerUnavailableException(RequestOptions requestOptions, [Failure? failure])
      : super(
          requestOptions,
          "Service unavailable: ",
          StatusCode.serviceUnavailable,
          failure,
        );
}

/// サーバー側通信のタイムアウト
/// 504
class ServerTimeOutException extends ApiException {
  ServerTimeOutException(RequestOptions requestOptions, [Failure? failure])
      : super(
          requestOptions,
          "Server timeout exception: ",
          StatusCode.serverTimeOutError,
          failure,
        );
}

// When can not get ble password will throw exception
class BLEApiDetailException extends ApiException {
  ApiException err; // Error child
  BLEApiDetailException({required this.err})
      : super(
          err.requestOptions,
          "BLEApiDetailException",
          StatusCode.none,
          null,
        );
}

class LoginTimeoutBadRequestException extends ApiException {
  LoginTimeoutBadRequestException(
    RequestOptions requestOptions, [
    Failure? failure,
  ]) : super(
          requestOptions,
          "Retry login timeout bad request: ",
          StatusCode.badRequest,
          failure,
        );
}

class RefreshTokenBadRequestException extends ApiException {
  RefreshTokenBadRequestException(
    RequestOptions requestOptions, [
    Failure? failure,
  ]) : super(
          requestOptions,
          "Retry login timeout bad request: ",
          StatusCode.badRequest,
          failure,
        );
}

/// アプリ内タイムアウト
class AppTimeOutException extends ApiException {
  AppTimeOutException(RequestOptions requestOptions, [Failure? failure])
      : super(
          requestOptions,
          "App timeout exception: ",
          StatusCode.appTimeOutError,
          failure,
        );
}

class NoInternetException extends ApiException {
  NoInternetException(RequestOptions requestOptions, [Failure? failure])
      : super(
          requestOptions,
          "App timeout exception: ",
          StatusCode.noInternet,
          failure,
        );
}
