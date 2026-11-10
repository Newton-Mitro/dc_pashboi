import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pashboi/core/errors/error_message.dart';
import 'package:pashboi/core/errors/exceptions.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/core/utils/failure_mapper.dart';

void main() {
  group('FailureMapper.fromException', () {
    test('maps known application exceptions to matching failures', () {
      expect(
        FailureMapper.fromException(CacheException(message: 'Missing data')),
        isA<CacheFailure>().having(
          (failure) => failure.message,
          'message',
          'Missing data',
        ),
      );
      expect(
        FailureMapper.fromException(NetworkException(message: 'Offline')),
        isA<NetworkFailure>().having(
          (failure) => failure.message,
          'message',
          'Offline',
        ),
      );
      expect(
        FailureMapper.fromException(UnauthorizedException()),
        isA<UnauthorizedFailure>(),
      );
      expect(
        FailureMapper.fromException(ForbiddenException()),
        isA<ForbiddenFailure>(),
      );
      expect(
        FailureMapper.fromException(ServerException()),
        isA<ServerFailure>(),
      );
      expect(
        FailureMapper.fromException(
          ValidationException(
            errors: {'email': 'Invalid email'},
            message: 'Please check your email',
          ),
        ),
        isA<ValidationFailure>()
            .having(
              (failure) => failure.message,
              'message',
              'Please check your email',
            )
            .having((failure) => failure.errors, 'errors', {
              'email': 'Invalid email',
            }),
      );
    });

    test(
      'maps Dio validation responses and preserves safe server messages',
      () {
        final requestOptions = RequestOptions(path: '/profile');
        final failure = FailureMapper.fromException(
          DioException(
            type: DioExceptionType.badResponse,
            requestOptions: requestOptions,
            response: Response(
              requestOptions: requestOptions,
              statusCode: 422,
              data: {
                'message': 'Invalid profile',
                'errors': {'email': 'Invalid email'},
              },
            ),
          ),
        );

        expect(failure, isA<ValidationFailure>());
        expect(failure.message, 'Invalid profile');
        expect((failure as ValidationFailure).errors, {
          'email': 'Invalid email',
        });
      },
    );

    test('maps unknown errors without exposing exception details', () {
      final failure = FailureMapper.fromException(
        StateError('sensitive implementation detail'),
      );

      expect(failure, isA<ServerFailure>());
      expect(failure.message, ErrorMessage.serverError);
    });
  });
}
