import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:pashboi/core/injection.dart';
import 'package:pashboi/core/services/logging/logger_service.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    _prettyPrint('🟢 Bloc Created', {
      'bloc': bloc.runtimeType.toString(),
      'state': bloc.state.toString(),
    });
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    _prettyPrint('📩 Event Dispatched', {
      'bloc': bloc.runtimeType.toString(),
      'event': event.toString(),
    });
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    _prettyPrint('🔄 State Changed', {
      'bloc': bloc.runtimeType.toString(),
      'currentState': change.currentState.toString(),
      'nextState': change.nextState.toString(),
    });
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    _prettyPrint('🔁 Transition', {
      'bloc': bloc.runtimeType.toString(),
      'event': transition.event.toString(),
      'currentState': transition.currentState.toString(),
      'nextState': transition.nextState.toString(),
    });
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    final message = 'Unhandled ${bloc.runtimeType} error';
    try {
      if (sl.isRegistered<LoggerService>()) {
        sl<LoggerService>().logError(message, error, stackTrace);
      } else {
        debugPrint('$message: $error\n$stackTrace');
      }
    } on Object catch (loggingError) {
      debugPrint('Failed to log $message: $loggingError');
      debugPrint('$message: $error\n$stackTrace');
    }
  }

  void _prettyPrint(String title, Map<String, String> data) {
    // Only log if LoggerService is available (sl is initialized)
    try {
      final logger = sl<LoggerService>();
      final buffer = StringBuffer();
      data.forEach((key, value) {
        buffer.write('$key: $value | ');
      });
      logger.logTrace('$title: ${buffer.toString()}');
    } catch (e) {
      // Fallback if sl is not ready yet
      debugPrint('$title: $data');
    }
  }
}
