import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pashboi/core/errors/error_message.dart';
import 'package:pashboi/core/errors/exceptions.dart';
import 'package:pashboi/core/errors/failures.dart';

class FailureMapper {
  static Failure fromException(Object exception) {
    if (exception is ValidationException) {
      return ValidationFailure(
        errors: exception.errors,
        message: exception.message,
      );
    }
    if (exception is CacheException) {
      return CacheFailure(message: exception.message);
    }
    if (exception is NetworkException) {
      return NetworkFailure(message: exception.message);
    }
    if (exception is UnauthorizedException) {
      return UnauthorizedFailure(message: exception.message);
    }
    if (exception is ForbiddenException) {
      return ForbiddenFailure(message: exception.message);
    }
    if (exception is ServerException) {
      return ServerFailure(message: exception.message);
    }
    if (exception is TimeoutException) {
      return NetworkFailure(message: ErrorMessage.timeout, statusCode: 408);
    }
    if (exception is DioException) {
      final dioError = exception;

      switch (dioError.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return NetworkFailure(message: ErrorMessage.timeout, statusCode: 408);

        case DioExceptionType.badResponse:
          final statusCode = dioError.response?.statusCode ?? 500;
          final data = dioError.response?.data;

          switch (statusCode) {
            case 400:
            case 422:
              return ValidationFailure(
                errors: _extractValidationErrors(data),
                message: _extractMessage(data) ?? ErrorMessage.validationError,
                statusCode: statusCode,
              );
            case 401:
              return UnauthorizedFailure(
                message: _extractMessage(data) ?? ErrorMessage.unauthorized,
                statusCode: statusCode,
              );
            case 403:
              return ForbiddenFailure(
                message: _extractMessage(data) ?? ErrorMessage.forbidden,
                statusCode: statusCode,
              );
            case 408:
              return NetworkFailure(
                message: ErrorMessage.timeout,
                statusCode: 408,
              );
            case 500:
            default:
              return ServerFailure(
                message: _extractMessage(data) ?? ErrorMessage.serverError,
                statusCode: statusCode,
              );
          }

        case DioExceptionType.cancel:
          return const RequestCancelledFailure(
            message: "Request was cancelled",
            statusCode: -4,
          );

        case DioExceptionType.connectionError:
        case DioExceptionType.unknown:
          if (dioError.error is TimeoutException) {
            return NetworkFailure(
              message: ErrorMessage.timeout,
              statusCode: 408,
            );
          }
          if (dioError.error is SocketException) {
            return NetworkFailure(statusCode: -1);
          }
          return NetworkFailure(statusCode: -1);
        default:
          return NetworkFailure(statusCode: -1);
      }
    } else if (exception is SocketException) {
      return NetworkFailure(statusCode: -1);
    } else {
      return ServerFailure();
    }
  }

  static Map<String, dynamic> _extractValidationErrors(dynamic data) {
    if (data is Map) {
      final errors = data['errors'] ?? data['Errors'];
      if (errors is Map) {
        return Map<String, dynamic>.from(errors);
      }
    }
    return {'error': 'Invalid request'};
  }

  static String? _extractMessage(dynamic data) {
    if (data is! Map) return null;
    final message = data['Message'] ?? data['message'];
    if (message is String && message.trim().isNotEmpty) {
      return message.trim();
    }
    return null;
  }
}
