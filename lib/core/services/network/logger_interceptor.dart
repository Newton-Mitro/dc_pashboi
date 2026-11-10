import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:pashboi/core/services/logging/logger_service.dart';

class LoggerInterceptor extends Interceptor {
  final LoggerService loggerService;

  LoggerInterceptor({required this.loggerService});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final buffer = StringBuffer();
    buffer.writeln("╔════════════════════════════════════════");
    buffer.writeln("║ 📤 REQUEST: ${options.method} ${options.uri}");
    buffer.writeln("║ Headers: ${_prettyJson(options.headers)}");

    if (options.data != null) {
      buffer.writeln("║ Body: ${_prettyJson(options.data)}");
    }
    buffer.writeln("╚════════════════════════════════════════");

    loggerService.logInfo(buffer.toString());
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final buffer = StringBuffer();
    buffer.writeln("╔════════════════════════════════════════");
    buffer.writeln(
      "║ ✅ RESPONSE [${response.statusCode}]: ${response.requestOptions.uri}",
    );
    buffer.writeln("║ Headers: ${_prettyJson(response.headers.map)}");
    buffer.writeln("║ Data: ${_prettyJson(response.data)}");
    buffer.writeln("╚════════════════════════════════════════");

    loggerService.logDebug(buffer.toString());
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final buffer = StringBuffer();
    buffer.writeln("╔════════════════════════════════════════");
    buffer.writeln(
      "║ ❌ ERROR [${err.response?.statusCode}]: ${err.requestOptions.uri}",
    );
    buffer.writeln("║ Message: ${err.message}");

    if (err.response != null) {
      buffer.writeln("║ Error Data: ${_prettyJson(err.response?.data)}");
    }
    buffer.writeln("╚════════════════════════════════════════");

    loggerService.logError(buffer.toString());
    handler.next(err);
  }

  String _prettyJson(dynamic json) {
    try {
      return const JsonEncoder.withIndent(
        '  ',
      ).convert(_sanitizeForLogging(json));
    } catch (_) {
      return '<${json.runtimeType}>';
    }
  }

  dynamic _sanitizeForLogging(dynamic value, {int depth = 0}) {
    if (value is String) {
      if (value.length > 512) {
        return '${value.substring(0, 128)}… <${value.length} characters omitted>';
      }
      return value;
    }

    if (depth >= 4) return '<nested data omitted>';

    if (value is Map) {
      final entries = value.entries.take(30);
      final result = <String, dynamic>{
        for (final entry in entries)
          entry.key.toString(): _sanitizeForLogging(
            entry.value,
            depth: depth + 1,
          ),
      };
      if (value.length > 30) {
        result['…'] = '${value.length - 30} entries omitted';
      }
      return result;
    }

    if (value is Iterable) {
      final entries = value.take(20).toList();
      final result =
          entries
              .map((entry) => _sanitizeForLogging(entry, depth: depth + 1))
              .toList();
      if (value is List && value.length > 20) {
        result.add('${value.length - 20} items omitted');
      } else if (value is! List) {
        result.add('additional items omitted');
      }
      return result;
    }

    if (value == null || value is num || value is bool) return value;
    return _sanitizeForLogging(value.toString(), depth: depth + 1);
  }
}
