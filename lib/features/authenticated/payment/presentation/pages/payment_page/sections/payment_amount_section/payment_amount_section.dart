import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/features/authenticated/cards/presentation/pages/bloc/debit_card_bloc.dart';
import 'package:pashboi/shared/widgets/app_text_input.dart';

class PaymentAmountSection extends StatefulWidget {
  final String? paymentAmount;
  final String? paymentAmountError;
  final void Function(String) onPaymentAmountChanged;

  const PaymentAmountSection({
    super.key,
    required this.paymentAmount,
    required this.paymentAmountError,
    required this.onPaymentAmountChanged,
  });

  @override
  State<PaymentAmountSection> createState() => _PaymentAmountSectionState();
}

class _PaymentAmountSectionState extends State<PaymentAmountSection> {
  @override
  void initState() {
    context.read<DebitCardBloc>().add(DebitCardLoad());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border.all(color: colorScheme.primary),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
                child: Center(
                  child: Text(
                    Locales.string(context, "payment_amount"),
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Form fields
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 5),

                    AppTextInput(
                      initialValue: widget.paymentAmount,
                      keyboardType: TextInputType.number,
                      enabled: true,
                      label: Locales.string(context, "amount"),
                      errorText: widget.paymentAmountError,
                      prefixIcon: Icon(
                        FontAwesomeIcons.coins,
                        color: colorScheme.onSurface,
                      ),
                      onChanged: widget.onPaymentAmountChanged,
                    ),
                    const SizedBox(height: 16),

                    AppTextInput(
                      initialValue: widget.paymentAmount,
                      enabled: true,
                      label: Locales.string(context, "reference"),
                      errorText: widget.paymentAmountError,
                      prefixIcon: Icon(
                        FontAwesomeIcons.tags,
                        color: colorScheme.onSurface,
                      ),
                      onChanged: widget.onPaymentAmountChanged,
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
