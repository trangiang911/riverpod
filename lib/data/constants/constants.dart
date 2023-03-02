import 'package:flutter/material.dart';

class Constants {
  const Constants._();

  static final navigatorKey = GlobalKey<NavigatorState>();

  //TODO Constants
  static const String stringEmpty = "";

  /// 15000msec
  static const int timeConnectTimeout = 15000;

  /// 15000msec
  static const int timeSendTimeout = 15000;

  /// 15000msec
  static const int timeReceiveTimeout = 15000;

  /// Error code number
  static const int noErrorCode = -1;
  static const int appTimeOutError = -4;
  static const int noInternet = 0;
  static const int errorCode400 = 400;
  static const int errorCode404 = 404;
  static const int errorCode500 = 500;
  static const int errorCode503 = 503;
  static const int errorCode504 = 504;

}
