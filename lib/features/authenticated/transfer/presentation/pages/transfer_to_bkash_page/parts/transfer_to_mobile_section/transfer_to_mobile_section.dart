import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/features/authenticated/cards/presentation/pages/bloc/debit_card_bloc.dart';
import 'package:pashboi/shared/widgets/prefixed_mobile_number_input.dart';

class TransferToMobileSection extends StatefulWidget {
  final String? transferToMobile;
  final String? transferToMobileError;
  final void Function(String) onTransferToMobileChanged;

  const TransferToMobileSection({
    super.key,
    required this.transferToMobile,
    required this.transferToMobileError,
    required this.onTransferToMobileChanged,
  });

  @override
  State<TransferToMobileSection> createState() =>
      _TransferToMobileSectionState();
}

class _TransferToMobileSectionState extends State<TransferToMobileSection> {
  final String _prefix = '+880-';

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
                    Locales.string(context, 'to_bkash_account'),
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: PrefixedMobileNumberInput(
                            initialValue: widget.transferToMobile,
                            label: Locales.string(context, 'bkash_number'),
                            prefixIcon: const Icon(Icons.phone),
                            prefix: _prefix,
                            onChanged: widget.onTransferToMobileChanged,
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
