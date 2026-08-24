import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/core/injection.dart';
import 'package:pashboi/features/auth/presentation/bloc/reset_password_bloc/reset_password_bloc.dart';
import 'package:pashboi/routes/public_routes_name.dart';
import 'package:pashboi/shared/widgets/page_container.dart';
import 'package:pashboi/shared/widgets/app_text_input.dart';
import 'package:pashboi/shared/widgets/buttons/app_primary_button.dart';
import 'package:pashboi/shared/widgets/prefixed_mobile_number_input.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  String _mobileNumber = '';
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late final TextEditingController _mobileNumberController;
  late final ResetPasswordBloc _resetPasswordBloc;

  @override
  void initState() {
    super.initState();
    _mobileNumberController = TextEditingController();
    _resetPasswordBloc =
        sl<ResetPasswordBloc>()..add(GetRegisteredMobileRequested());
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _mobileNumberController.dispose();
    _resetPasswordBloc.close();
    super.dispose();
  }

  void _onResetPasswordPressed() {
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      _showSnackBar(
        title: Locales.string(context, 'oops'),
        message: Locales.string(context, 'password_mismatch'),
        isError: true,
      );
      return;
    }

    _resetPasswordBloc.add(
      ResetPasswordRequested(mobileNumber: _mobileNumber, password: password),
    );
  }

  void _showSnackBar({
    required String title,
    required String message,
    bool isError = false,
  }) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: isError ? ContentType.failure : ContentType.success,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, PublicRoutesName.loginPage);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _resetPasswordBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(Locales.string(context, 'reset_password_page_title')),
        ),
        body: SafeArea(
          child: BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
            listener: (context, state) {
              if (state is ResetPasswordFailure) {
                _showSnackBar(
                  title: Locales.string(context, 'oops'),
                  message: state.message,
                  isError: true,
                );
              } else if (state is ResetPasswordSuccess) {
                _showSnackBar(
                  title: Locales.string(context, 'success'),
                  message: Locales.string(context, 'reset_password_success'),
                );
                Future.delayed(
                  const Duration(milliseconds: 700),
                  _navigateToLogin,
                );
              } else if (state is RegisteredMobileLoaded) {
                setState(() {
                  _mobileNumber = state.mobile;
                  _mobileNumberController.text = '+880-$_mobileNumber';
                });
              }
            },
            builder: (context, state) {
              return PageContainer(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    spacing: 10,
                    children: [
                      const Icon(
                        FontAwesomeIcons.lock,
                        size: 80,
                        textDirection: TextDirection.ltr,
                      ),
                      Text(
                        Locales.string(context, 'reset_password_page_title'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 26,
                          vertical: 36,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            PrefixedMobileNumberInput(
                              label: Locales.string(
                                context,
                                'reset_password_page_mobile_number_label',
                              ),
                              prefixIcon: const Icon(Icons.phone),
                              prefix: '+880-',
                              controller: _mobileNumberController,
                              readOnly: true,
                              onChanged: (_) {},
                              errorText:
                                  state is ResetPasswordValidationError
                                      ? state.errors['mobile']?.isNotEmpty ==
                                              true
                                          ? state.errors['mobile']
                                          : null
                                      : null,
                            ),
                            const SizedBox(height: 16),
                            AppTextInput(
                              controller: _passwordController,
                              label: Locales.string(
                                context,
                                'reset_password_page_password_label',
                              ),
                              obscureText: true,
                              prefixIcon: Icon(
                                Icons.lock,
                                color: context.theme.colorScheme.onSurface,
                              ),
                              errorText:
                                  state is ResetPasswordValidationError
                                      ? state.errors['password']?.isNotEmpty ==
                                              true
                                          ? state.errors['password']
                                          : null
                                      : null,
                            ),
                            const SizedBox(height: 16),
                            AppTextInput(
                              controller: _confirmPasswordController,
                              label: Locales.string(
                                context,
                                'reset_password_page_confirm_password_label',
                              ),
                              obscureText: true,
                              prefixIcon: Icon(
                                Icons.lock,
                                color: context.theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 36),
                            if (state is ResetPasswordLoading)
                              const Center(child: CircularProgressIndicator())
                            else
                              AppPrimaryButton(
                                label: Locales.string(
                                  context,
                                  'reset_password_page_reset_password_button',
                                ),
                                onPressed: _onResetPasswordPressed,
                                iconBefore: Icon(
                                  Icons.lock_reset,
                                  color: context.theme.colorScheme.onPrimary,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
