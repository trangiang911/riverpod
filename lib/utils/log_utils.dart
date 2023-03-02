
import 'package:demo_base_riverpod_1/data/enums/enums.dart';
import 'package:demo_base_riverpod_1/plugin/file/logger_manager.dart';

/// <p>ログユーティリティクラス</p>
class LogUtils {
  /// <p>ログ出力モードを表します。</p>
  /// ログは本クラスを経由し出力してください。。
  /// apkリリース時には必ずfalseに変更してください。
  static const bool logMode = true;

  /// <p>LogUtilsのインスタンスを生成します。</p>
  LogUtils();

  /// <p>ログ出力を行います。</p>
  /// 必ずメソッドの先頭でコールして下さい。
  ///
  /// @param msg           [IN]ログメッセージを指定します。
  static void methodIn({String message = ""}) {
    _outputLog(Level.trace, '[S]${_outputMessage(message)}', null);
  }

  /// <p>ログ出力を行います。</p>
  /// 必ずメソッドの末尾でコールして下さい。
  ///
  /// @param msg           [IN]ログメッセージを指定します。
  static void methodOut({String message = ""}) {
    _outputLog(Level.trace, '[N]${_outputMessage(message)}', null);
  }

  /// <p>ログ出力を行います。</p>
  ///
  /// @param msg           [IN]ログメッセージを指定します。
  static void d(String msg, {Exception? ex}) {
    _outputLog(Level.debug, _outputMessage(msg), ex);
  }

  /// <p>ログ出力を行います。</p>
  ///
  /// @param msg           [IN]ログメッセージを指定します。
  static void i(String msg) {
    _outputLog(Level.info, _outputMessage(msg), null);
  }

  /// <p>ログ出力を行います。</p>
  ///
  /// @param msg           [IN]ログメッセージを指定します。
  static void w(String msg) {
    _outputLog(Level.warn, _outputMessage(msg), null);
  }

  /// <p>ログ出力を行います。</p>
  ///
  /// @param msg           [IN]ログメッセージを指定します。
  static void e(String msg) {
    _outputLog(Level.error, _outputMessage(msg), null);
  }

  /// <p>ログ出力を行います。</p>
  ///
  /// @param type          [IN]ログの種類を指定します。
  /// @param msg           [IN]出力内容を指定します。
  /// @param tr            [IN]例外を指定します。
  static void _outputLog(Level level, String msg, Exception? ex) {
    String msgOut = msg;
    switch (level) {
      case Level.error:
        msgOut = 'E/$msg';
        break;
      case Level.warn:
        msgOut = 'W/$msg';
        break;
      case Level.info:
        msgOut = 'I/$msg';
        break;
      case Level.debug:
        msgOut = 'D/$msg';
        break;
      case Level.trace:
        msgOut = msg;
        break;
      default:
        break;
    }

    // TODO FIX Product
    // if (FlavorConfig.isDevelopment()) {
      // ignore: avoid_print
      print(msgOut);
    // }
    outputFileLog(level, msgOut);
  }

  static String _outputMessage(String msg) {
    String stackTrace = StackTrace.current.toString();
    // スタックトレースから情報を取得 // 0: LogUtils._outputMessage, 1: LogUtils.e, 2: 呼び出し元
    String topStack = stackTrace.split("#2")[1];
    String fileInfo = topStack
        .substring(topStack.indexOf("package"), topStack.indexOf(")"))
        .trim();
    String methodName = topStack.substring(0, topStack.indexOf("(")).trim();

    return '[$methodName]::$msg  <$fileInfo>';
  }

  /// <p>リアルタイムログに書き出します。</p>
  ///
  /// @param type          [IN]ログの種類を指定します。
  /// @param msg           [IN]出力内容を指定します。
  static void outputFileLog(Level level, String msg) {
    switch (level) {
      case Level.error:
      case Level.warn:
      case Level.info:
      case Level.debug:
        LoggerManager().saveDebugLogFile(message: msg);
        break;
      case Level.trace:
        break;
      default:
        break;
    }
  }
}
