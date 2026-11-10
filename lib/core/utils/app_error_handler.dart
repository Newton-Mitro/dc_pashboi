import 'package:flutter/foundation.dart';
import 'package:pashboi/core/injection.dart';
import 'package:pashboi/core/services/logging/logger_service.dart';

class AppErrorHandler {
  static void install() {
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      _log(
        'Unhandled Flutter error',
        details.exception,
        details.stack ?? StackTrace.current,
      );
    };

    PlatformDispatcher.instance.onError = (error, stackTrace) {
      _log('Unhandled platform error', error, stackTrace);
      return true;
    };
  }

  static void _log(String message, Object error, StackTrace stackTrace) {
    try {
      if (sl.isRegistered<LoggerService>()) {
        sl<LoggerService>().logFatal(message, error, stackTrace);
        return;
      }
    } on Object catch (loggingError) {
      debugPrint('Failed to log $message: $loggingError');
    }
    debugPrint('$message: $error\n$stackTrace');
  }
}
