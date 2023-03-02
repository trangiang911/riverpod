import 'package:demo_base_riverpod_1/data/dio/app_dio.dart';
import 'package:demo_base_riverpod_1/utils/log_utils.dart';
import 'package:dio/dio.dart';

abstract class DataSource {

  Future<T?> post<T>(
      // url represents end point
      String url, {
        Object? body,
        String? param,
        required T Function(Object?) mapper,
      }) async {
    Uri uri = AppDio().processUri(url: url, param: param);
    LogUtils.d('[$runtimeType][REQUEST:POST] API:【${uri.path}】 body:$body');

    return AppDio()
        .postUri<String>(
      uri,
      data: body,
    )
        .then(
          (response) => mapper.call(
        AppDio().convertResponseToObject(
          response,
          runtimeType.toString(),
          uri.path,
        ),
      ),
    );
  }

  Future<T?> put<T>(
      String url, {
        Object? body,
        String? param,
        required T Function(Object?) mapper,
        bool needAccessToken = true,
      }) async {
    Uri uri = AppDio().processUri(url: url, param: param);

    return AppDio()
        .putUri<String>(
      uri,
      data: body,
    )
        .then(
          (response) => mapper.call(
        AppDio().convertResponseToObject(
          response,
          runtimeType.toString(),
          uri.path,
        ),
      ),
    );
  }

  Future<T?> delete<T>(
      // url represents end point
      String url, {
        Object? body,
        String? param,
        required T Function(Object?) mapper,
      }) async {
    Uri uri = AppDio().processUri(url: url, param: param);

    return AppDio()
        .deleteUri<String>(
      uri,
      data: body,
    )
        .then(
          (response) => mapper.call(
        AppDio().convertResponseToObject(
          response,
          runtimeType.toString(),
          uri.path,
        ),
      ),
    );
  }

  Future<T?> get<T>(
      // url represents end point
      String url, {
        String? param,
        required T Function(Object?) mapper,
      }) async {
    Uri uri = AppDio().processUri(url: url, param: param);

    return AppDio()
        .getUri<String>(
      uri,
    )
        .then(
          (response) => mapper.call(
        AppDio().convertResponseToObject(
          response,
          runtimeType.toString(),
          uri.path,
        ),
      ),
    );
  }

  Future<T?> patch<T>(
      String url, {
        Object? body,
        String? param,
        required T Function(Object?) mapper,
        bool needAccessToken = true,
      }) async {
    Uri uri = AppDio().processUri(url: url, param: param);

    return AppDio()
        .patchUri<String>(
      uri,
      data: body,
    )
        .then(
          (response) => mapper.call(
        AppDio().convertResponseToObject(
          response,
          runtimeType.toString(),
          uri.path,
        ),
      ),
    );
  }

  /// Only get image from server with res File
  Future<Response> getImage<T>(
      String url, {
        String? param,
      }) async {
    Uri uri = AppDio().processUri(url: url, param: param);
    try {
      final res = await AppDio().getUri<List<int>>(
        uri,
        options: Options(responseType: ResponseType.bytes),
      );

      return res;
    } on Exception {
      rethrow;
    }
  }
}
