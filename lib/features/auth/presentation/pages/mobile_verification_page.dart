import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/features/auth/presentation/bloc/mobile_number_verification_bloc/mobile_number_verification_bloc.dart';
import 'package:pashboi/routes/public_routes_name.dart';
import 'package:pashboi/shared/widgets/buttons/app_primary_button.dart';
import 'package:pashboi/shared/widgets/page_container.dart';
import 'package:pashboi/shared/widgets/prefixed_mobile_number_input.dart';

class MobileVerificationPage extends StatefulWidget {
  final String routeName;
  final String pageTitle;

  const MobileVerificationPage({
    super.key,
    required this.routeName,
    required this.pageTitle,
  });

  @override
  State<MobileVerificationPage> createState() => _MobileVerificationPageState();
}

class _MobileVerificationPageState extends State<MobileVerificationPage> {
  final String _prefix = '+880-';

  String _mobileNumber = '';
  String? mobileError;

  void _sendOtp() {
    final rawNumber = _mobileNumber.replaceFirst(_prefix, '').trim();

    if (rawNumber.isEmpty) {
      setState(() {
        mobileError = Locales.string(
          context,
          'please_enter_your_mobile_number',
        );
      });
      return;
    }

    setState(() {
      mobileError = null;
    });

    context.read<VerifyMobileNumberBloc>().add(
      SubmitMobileNumber(mobileNumber: _mobileNumber, isRegistered: true),
    );
  }

  void _showSnackBar({
    required String title,
    required String message,
    required ContentType type,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: title,
            message: message,
            contentType: type,
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerifyMobileNumberBloc, VerifyMobileNumberState>(
      listener: (context, state) {
        if (state is VerifyMobileNumberFailure) {
          _showSnackBar(
            title: Locales.string(context, 'failed'),
            message: state.error,
            type: ContentType.failure,
          );
        }

        if (state is VerifyMobileNumberSuccess) {
          _showSnackBar(
            title: Locales.string(context, 'success'),
            message: state.message,
            type: ContentType.success,
          );

          Navigator.pushReplacementNamed(
            context,
            PublicRoutesName.otpVerificationPage,
            arguments: {
              'routeName': widget.routeName,
              'mobileNumber': _mobileNumber,
              'otpRegId': state.message,
            },
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(widget.pageTitle)),
        body: SafeArea(
          child: PageContainer(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 36),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const Icon(FontAwesomeIcons.mobileScreenButton, size: 80),
                      const SizedBox(height: 16),
                      Text(
                        Locales.string(
                          context,
                          "mobile_verification_page_title",
                        ),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  PrefixedMobileNumberInput(
                    errorText: mobileError,
                    label: Locales.string(
                      context,
                      "mobile_verification_page_mobile_number_label",
                    ),
                    prefixIcon: const Icon(Icons.phone),
                    prefix: _prefix,
                    onChanged: (value) {
                      setState(() {
                        _mobileNumber = value;
                        mobileError = null;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  BlocBuilder<VerifyMobileNumberBloc, VerifyMobileNumberState>(
                    builder: (context, state) {
                      final isLoading = state is VerifyMobileNumberLoading;

                      return AppPrimaryButton(
                        label:
                            isLoading
                                ? Locales.string(context, 'sending')
                                : Locales.string(
                                  context,
                                  "mobile_verification_page_send_otp_button",
                                ),
                        onPressed: isLoading ? null : _sendOtp,
                        iconBefore: Icon(
                          Icons.send,
                          color: context.theme.colorScheme.onPrimary,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
