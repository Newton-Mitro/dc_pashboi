import 'package:bloc/bloc.dart';

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
    _prettyPrint('❌ Error', {
      'bloc': bloc.runtimeType.toString(),
      'error': error.toString(),
      'stackTrace': stackTrace
          .toString()
          .split('\n')
          .take(3)
          .join('\n'), // only top 3 lines
    });
  }

  void _prettyPrint(String title, Map<String, String> data) {
    final buffer = StringBuffer();
    buffer.writeln('--- $title ---');
    data.forEach((key, value) {
      buffer.writeln('$key: $value');
    });
    buffer.writeln('----------------------\n');
  }
}
