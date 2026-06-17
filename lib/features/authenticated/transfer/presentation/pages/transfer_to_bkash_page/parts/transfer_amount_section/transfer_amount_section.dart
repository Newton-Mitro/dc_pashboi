import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/features/authenticated/cards/presentation/pages/bloc/debit_card_bloc.dart';
import 'package:pashboi/shared/widgets/app_text_input.dart';

class TransferAmountSection extends StatefulWidget {
  final String sectionTitle;
  final String? transferAmount;
  final String? transferAmountError;
  final void Function(String) onTransferAmountChanged;

  const TransferAmountSection({
    super.key,
    required this.sectionTitle,
    required this.transferAmount,
    required this.transferAmountError,
    required this.onTransferAmountChanged,
  });

  @override
  State<TransferAmountSection> createState() => _TransferAmountSectionState();
}

class _TransferAmountSectionState extends State<TransferAmountSection> {
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
                    widget.sectionTitle,
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
                      initialValue: widget.transferAmount,
                      keyboardType: TextInputType.number,
                      enabled: true,
                      label: Locales.string(context, 'amount'),
                      errorText: widget.transferAmountError,
                      prefixIcon: Icon(
                        FontAwesomeIcons.coins,
                        color: colorScheme.onSurface,
                      ),
                      onChanged: widget.onTransferAmountChanged,
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
