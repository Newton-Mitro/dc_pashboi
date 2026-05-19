import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:pashboi/core/extensions/app_context.dart';

class OtpVerificationSection extends StatefulWidget {
  final void Function() resendOTP;
  final void Function(String otp) onOtpChanged;
  final String otp;
  final int otpLength;
  final int countdownSeconds;

  const OtpVerificationSection({
    super.key,
    required this.resendOTP,
    required this.onOtpChanged,
    this.otp = '',
    this.otpLength = 6,
    this.countdownSeconds = 60,
  });

  @override
  State<OtpVerificationSection> createState() => _OtpVerificationSectionState();
}

class _OtpVerificationSectionState extends State<OtpVerificationSection> {
  late List<TextEditingController> _otpControllers;
  late List<FocusNode> _focusNodes;
  late CountDownController _countDownController;
  bool _isWaiting = true;

  @override
  void initState() {
    super.initState();

    _otpControllers = List.generate(
      widget.otpLength,
      (i) => TextEditingController(
        text: i < widget.otp.length ? widget.otp[i] : '',
      ),
    );

    _focusNodes = List.generate(widget.otpLength, (i) {
      final node = FocusNode();
      node.addListener(() {
        if (node.hasFocus) {
          _otpControllers[i].clear(); // Clear when focused
          _notifyOtpChanged();
        }
      });
      return node;
    });

    _countDownController = CountDownController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startCountdown();
    });
  }

  void _startCountdown() {
    setState(() {
      _isWaiting = true;
      _countDownController.start();
    });
  }

  void _notifyOtpChanged() {
    final currentOtp = _otpControllers.map((c) => c.text).join();
    widget.onOtpChanged(currentOtp); // Always notify
  }

  @override
  void dispose() {
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final n in _focusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: context.theme.colorScheme.surface,
            border: Border.all(color: context.theme.colorScheme.primary),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.primary,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(5),
                  ),
                ),
                child: Center(
                  child: Text(
                    Locales.string(context, "otp_verification_page_title"),
                    style: TextStyle(
                      color: context.theme.colorScheme.onPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
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

                    // OTP boxes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(widget.otpLength, (index) {
                        return SizedBox(
                          width: 50,
                          height: 50,
                          child: RawKeyboardListener(
                            focusNode: FocusNode(), // for backspace detection
                            onKey: (event) {
                              if (event is RawKeyDownEvent &&
                                  event.logicalKey ==
                                      LogicalKeyboardKey.backspace &&
                                  _otpControllers[index].text.isEmpty &&
                                  index > 0) {
                                FocusScope.of(
                                  context,
                                ).requestFocus(_focusNodes[index - 1]);
                              }
                            },
                            child: TextField(
                              controller: _otpControllers[index],
                              focusNode: _focusNodes[index],
                              autofocus: index == 0,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
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
                                if (value.length > 1) {
                                  _otpControllers[index].text = value[0];
                                  _otpControllers[index].selection =
                                      const TextSelection.collapsed(offset: 1);
                                }

                                _notifyOtpChanged();

                                if (value.isNotEmpty &&
                                    index < widget.otpLength - 1) {
                                  FocusScope.of(
                                    context,
                                  ).requestFocus(_focusNodes[index + 1]);
                                }
                              },
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 20),

                    // Countdown or resend
                    if (_isWaiting)
                      Column(
                        children: [
                          CircularCountDownTimer(
                            duration: widget.countdownSeconds,
                            initialDuration: 0,
                            controller: _countDownController,
                            width: 60,
                            height: 60,
                            ringColor: Colors.grey.shade300,
                            fillColor: Theme.of(context).colorScheme.secondary,
                            backgroundColor: Colors.transparent,
                            strokeWidth: 6.0,
                            strokeCap: StrokeCap.round,
                            isTimerTextShown: true,
                            isReverse: true,
                            isReverseAnimation: true,
                            autoStart: true,
                            textStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: context.theme.colorScheme.onPrimary,
                            ),
                            onComplete: () {
                              setState(() {
                                _isWaiting = false;
                              });
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
                      Column(
                        children: [
                          Text(Locales.string(context, 'dont_received_otp')),
                          TextButton(
                            onPressed: () {
                              for (final c in _otpControllers) {
                                c.clear();
                              }
                              widget.resendOTP();
                              _startCountdown();
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
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
