import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/features/authenticated/cards/domain/entities/debit_card_entity.dart';
import 'package:pashboi/features/authenticated/cards/presentation/pages/bloc/debit_card_bloc.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/entities/deposit_account_entity.dart';
import 'package:pashboi/shared/widgets/app_dropdown_select.dart';
import 'package:pashboi/shared/widgets/app_text_input.dart';

class TransferFromSection extends StatefulWidget {
  final String? sectionTitle;
  final String? accountNumber;
  final String? accountError;
  final void Function(
    DebitCardEntity? debitCard,
    DepositAccountEntity? selectedAccount,
  )?
  onAccountChanged;

  final String? selectedCardNumber;
  final String? accountTypeName;
  final double? accountBalance;
  final double? accountWithdrawable;
  final String? accountOperatorName;
  final String? accountHolderName;
  final String? accountName;

  const TransferFromSection({
    super.key,
    this.sectionTitle,
    required this.accountNumber,
    required this.accountError,
    required this.onAccountChanged,
    required this.selectedCardNumber,
    required this.accountTypeName,
    required this.accountBalance,
    required this.accountWithdrawable,
    required this.accountOperatorName,
    required this.accountHolderName,
    required this.accountName,
  });

  @override
  State<TransferFromSection> createState() => _TransferFromSectionState();
}

class _TransferFromSectionState extends State<TransferFromSection> {
  @override
  void initState() {
    context.read<DebitCardBloc>().add(DebitCardLoad());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    return BlocBuilder<DebitCardBloc, DebitCardState>(
      builder: (context, state) {
        DebitCardEntity? debitCard;
        List<DepositAccountEntity> cardAccounts = [];

        if (state.debitCard != null) {
          cardAccounts = state.debitCard!.cardsAccounts;
          debitCard = state.debitCard;
        }

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
                        widget.sectionTitle ??
                            Locales.string(
                              context,
                              'money_will_be_transferred_from',
                            ),
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
                        AppDropdownSelect(
                          label: Locales.string(context, 'account_number'),
                          value: widget.accountNumber,
                          errorText: widget.accountError,
                          enabled: cardAccounts.isNotEmpty,
                          items:
                              cardAccounts.isNotEmpty
                                  ? cardAccounts
                                      .map(
                                        (acc) => DropdownMenuItem(
                                          value: acc.number,
                                          child: Text(acc.number),
                                        ),
                                      )
                                      .toList()
                                  : [
                                    const DropdownMenuItem(
                                      value: '',
                                      child: Text("No accounts found"),
                                    ),
                                  ],
                          prefixIcon: Icons.account_balance,
                          onChanged: (value) {
                            if (value != null && debitCard != null) {
                              final selectedAcc = cardAccounts.firstWhere(
                                (acc) => acc.number == value,
                              );

                              if (widget.onAccountChanged != null) {
                                widget.onAccountChanged!(
                                  debitCard,
                                  selectedAcc,
                                );
                              }
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        AppTextInput(
                          initialValue: widget.selectedCardNumber,
                          enabled: false,
                          label: Locales.string(context, 'card_number'),
                          prefixIcon: Icon(
                            FontAwesomeIcons.creditCard,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 10),
                        AppTextInput(
                          initialValue: widget.accountTypeName,
                          enabled: false,
                          label: Locales.string(context, 'account_type'),
                          prefixIcon: Icon(
                            FontAwesomeIcons.tag,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 10),
                        AppTextInput(
                          initialValue: widget.accountBalance.toString(),
                          enabled: false,
                          label: Locales.string(context, 'available_balance'),
                          prefixIcon: Icon(
                            FontAwesomeIcons.coins,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 10),
                        AppTextInput(
                          initialValue: widget.accountWithdrawable.toString(),
                          enabled: false,
                          label: Locales.string(
                            context,
                            'withdrawable_balance',
                          ),
                          prefixIcon: Icon(
                            FontAwesomeIcons.coins,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
