import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/features/auth/presentation/bloc/mobile_number_verification_bloc/mobile_number_verification_bloc.dart';
import 'package:pashboi/features/auth/presentation/bloc/otp_verification_bloc/otp_verification_bloc.dart';
import 'package:pashboi/shared/widgets/page_container.dart';
import 'package:pashboi/shared/widgets/buttons/app_primary_button.dart';

class OtpVerificationPage extends StatefulWidget {
  final String routeName;
  final String mobileNumber;
  final String otpRegId;

  const OtpVerificationPage({
    super.key,
    required this.routeName,
    required this.mobileNumber,
    required this.otpRegId,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _isWaiting = true;
  final int _otpDuration = 60;
  final CountDownController _countDownController = CountDownController();
  late String _otpRegId;

  @override
  void initState() {
    super.initState();
    _otpRegId = widget.otpRegId;
    _countDownController.start();

    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) _otpControllers[i].clear();
      });
    }
  }

  @override
  void dispose() {
    try {
      _countDownController.pause();
    } catch (_) {}
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _resendOTP() {
    setState(() => _isWaiting = true);
    try {
      _countDownController.restart(duration: _otpDuration);
    } catch (_) {}

    context.read<VerifyMobileNumberBloc>().add(
      SubmitMobileNumber(mobileNumber: widget.mobileNumber, isRegistered: true),
    );
  }

  void _verifyOtp() {
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: Locales.string(context, 'oops'),
            message: Locales.string(context, 'please_enter_6_digit_otp'),
            contentType: ContentType.failure,
          ),
        ),
      );
      return;
    }

    context.read<OtpVerificationBloc>().add(
      VerifyOtpSubmitted(
        mobileNumber: widget.mobileNumber,
        otp: otp,
        otpRegId: _otpRegId,
      ),
    );
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  void _clearOtpFields() {
    for (var c in _otpControllers) {
      c.clear();
    }
    for (var f in _focusNodes) {
      f.unfocus();
    }
    setState(() => _isWaiting = false);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<OtpVerificationBloc, OtpVerificationState>(
          listener: (context, state) {
            if (state is OtpVerificationFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: Locales.string(context, 'oops'),
                    message: state.error,
                    contentType: ContentType.failure,
                  ),
                ),
              );
            } else if (state is OtpVerificationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: Locales.string(context, 'success'),
                    message: state.message,
                    contentType: ContentType.success,
                  ),
                ),
              );

              Navigator.pushReplacementNamed(context, widget.routeName);
            }
          },
        ),
        BlocListener<VerifyMobileNumberBloc, VerifyMobileNumberState>(
          listener: (context, state) {
            if (state is VerifyMobileNumberSuccess) {
              setState(() {
                _otpRegId = state.message;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: Locales.string(context, 'success'),
                    message: state.message,
                    contentType: ContentType.success,
                  ),
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(Locales.string(context, "otp_verification_page_title")),
        ),
        body: SafeArea(
          child: PageContainer(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 36),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 10,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Icon(FontAwesomeIcons.key, size: 80),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        Locales.string(context, "otp_verification_page_title"),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    Locales.string(
                      context,
                      "otp_verification_page_instruction",
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 50,
                        height: 50,
                        child: TextField(
                          controller: _otpControllers[index],
                          focusNode: _focusNodes[index],
                          autofocus: index == 0,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          decoration: InputDecoration(
                            filled: true,
                            counterText: '',
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: context.theme.colorScheme.secondary,
                                width: 2.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: context.theme.colorScheme.secondary,
                                width: 1.0,
                              ),
                            ),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 10,
                            ),
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              _otpControllers[index].text = value[0];
                              _otpControllers[index].selection =
                                  const TextSelection.collapsed(offset: 1);
                            }
                            _onOtpChanged(value, index);
                          },
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  if (_isWaiting)
                    Column(
                      children: [
                        CircularCountDownTimer(
                          duration: _otpDuration,
                          initialDuration: 0,
                          controller: _countDownController,
                          width: 60,
                          height: 60,
                          ringColor: Colors.grey.shade300,
                          fillColor: context.theme.colorScheme.secondary,
                          backgroundColor: Colors.transparent,
                          strokeWidth: 6.0,
                          strokeCap: StrokeCap.round,
                          isTimerTextShown: true,
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: context.theme.colorScheme.onSurface,
                          ),
                          isReverse: true,
                          autoStart: true,
                          onComplete: () {
                            if (mounted) {
                              setState(() => _isWaiting = false);
                            }
                          },
                        ),
                        const SizedBox(height: 8),
                        Text(
                          Locales.string(
                            context,
                            "otp_verification_page_otp_expired_in_text",
                          ),
                          style: TextStyle(
                            color: context.theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    )
                  else
                    TextButton(
                      onPressed: () {
                        _clearOtpFields();
                        _resendOTP();
                      },
                      child: Text(
                        Locales.string(
                          context,
                          "otp_verification_page_reseend_otp_button",
                        ),
                        style: TextStyle(
                          color: context.theme.colorScheme.onSurface,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  BlocBuilder<OtpVerificationBloc, OtpVerificationState>(
                    builder: (context, state) {
                      final isLoading = state is OtpVerificationLoading;
                      return AppPrimaryButton(
                        label: Locales.string(
                          context,
                          "otp_verification_page_verify_otp_button",
                        ),
                        onPressed: isLoading ? null : _verifyOtp,
                        iconBefore: Icon(
                          Icons.check_circle,
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
