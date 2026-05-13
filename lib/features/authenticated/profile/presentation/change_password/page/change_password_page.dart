import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:pashboi/features/authenticated/profile/presentation/change_password/bloc/change_password_bloc.dart';
import 'package:pashboi/shared/widgets/app_text_input.dart';
import 'package:pashboi/shared/widgets/network_error_dialog.dart';
import 'package:pashboi/shared/widgets/page_container.dart';
import 'package:pashboi/shared/widgets/progress_submit_button/progress_submit_button.dart';
import 'package:password_strength_indicator_plus/password_strength_indicator_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<ChangePasswordBloc>().add(
      ChangePasswordSubmitted(
        currentPassword: currentPasswordController.text.trim(),
        newPassword: newPasswordController.text.trim(),
        confirmPassword: confirmPasswordController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(Locales.string(context, 'change_password_title')),
      ),
      body: BlocListener<ChangePasswordBloc, ChangePasswordState>(
        listener: (context, state) {
          if (state is ChangePasswordError) {
            if (state.message == "No internet connection") {
              NetworkErrorDialog.show(context);
            } else {
              final snackBar = SnackBar(
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                content: AwesomeSnackbarContent(
                  title: Locales.string(context, 'oops'),
                  message: state.message,
                  contentType: ContentType.failure,
                ),
              );

              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(snackBar);
            }
          }
          if (state is ChangePasswordSuccess) {
            final snackBar = SnackBar(
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: Locales.string(context, 'success'),
                message: Locales.string(
                  context,
                  'password_cahanged_successfully',
                ),
                contentType: ContentType.success,
              ),
            );

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);

            Navigator.of(context).pop();
            context.read<AuthBloc>().add(LogoutRequested());
          }
        },
        child: BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
          builder: (context, state) {
            return PageContainer(
              child: Column(
                children: [
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          padding: const EdgeInsets.all(16.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: IntrinsicHeight(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 10,
                                children: [
                                  Column(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.key,
                                        size: 40,
                                        color:
                                            context.theme.colorScheme.onSurface,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        Locales.string(
                                          context,
                                          'change_password_title',
                                        ),
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 45),
                                  AppTextInput(
                                    label: Locales.string(
                                      context,
                                      'change_password_current_password_input_label',
                                    ),
                                    controller: currentPasswordController,
                                    errorText:
                                        state is ChangePasswordValidationError
                                            ? state
                                                        .errors['currentPassword']
                                                        ?.isNotEmpty ==
                                                    true
                                                ? state
                                                    .errors['currentPassword']
                                                : null
                                            : null,
                                    obscureText: true,
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color:
                                          context.theme.colorScheme.onSurface,
                                    ),
                                  ),

                                  AppTextInput(
                                    controller: newPasswordController,
                                    errorText:
                                        state is ChangePasswordValidationError
                                            ? state
                                                        .errors['newPassword']
                                                        ?.isNotEmpty ==
                                                    true
                                                ? state.errors['newPassword']
                                                : null
                                            : null,
                                    obscureText: true,
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color:
                                          context.theme.colorScheme.onSurface,
                                    ),
                                    label: Locales.string(
                                      context,
                                      'change_password_new_password_input_label',
                                    ),
                                  ),
                                  PasswordStrengthIndicatorPlus(
                                    textController: newPasswordController,
                                    hideRules: true,
                                  ),
                                  const SizedBox(height: 1),
                                  AppTextInput(
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color:
                                          context.theme.colorScheme.onSurface,
                                    ),
                                    errorText:
                                        state is ChangePasswordValidationError
                                            ? state
                                                        .errors['confirmPassword']
                                                        ?.isNotEmpty ==
                                                    true
                                                ? state
                                                    .errors['confirmPassword']
                                                : null
                                            : null,
                                    controller: confirmPasswordController,
                                    label: Locales.string(
                                      context,
                                      'change_password_confirm_password_input_label',
                                    ),
                                    obscureText: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  ProgressSubmitButton(
                    width: width - 10,
                    height: 100,
                    enabled: state is ChangePasswordLoading ? false : true,
                    backgroundColor: context.theme.colorScheme.primary,
                    progressColor: context.theme.colorScheme.secondary,
                    foregroundColor: context.theme.colorScheme.onPrimary,
                    label: Locales.string(context, 'press_and_hold_to_submit'),
                    onSubmit: _submit,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
