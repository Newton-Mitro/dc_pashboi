import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pashboi/core/injection.dart';
import 'package:pashboi/features/auth/data/data_sources/auth_local_datasource.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final AuthLocalDataSource authLocalDataSource;

  AuthInterceptor({required this.dio, required this.authLocalDataSource});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final authUser = await authLocalDataSource.getAuthUser();
      final accessToken = authUser.accessToken;

      options.headers['Accept'] = 'application/json';
      options.headers['Content-Type'] = 'application/json';

      if (accessToken.isNotEmpty) {
        options.headers['Token'] = accessToken;
      }

      return handler.next(options);
    } catch (e) {
      options.headers['Accept'] = 'application/json';
      options.headers['Content-Type'] = 'application/json';
      return handler.next(options);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final dataString = response.data?['Message'];

    if (dataString is String &&
        dataString == 'Authorization has been denied for this request.') {
      authLocalDataSource.clearAuthUser().then((_) {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          '/',
          (route) => false,
        );
      });

      final context = navigatorKey.currentContext;
      if (context != null) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Oops!',
            message:
                'Authorization has been denied for this request. You have been logged out.',
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    }

    return handler.next(response);
  }
}
