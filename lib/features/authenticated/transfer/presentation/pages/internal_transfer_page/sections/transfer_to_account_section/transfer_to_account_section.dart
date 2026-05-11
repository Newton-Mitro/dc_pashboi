import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/shared/widgets/app_dropdown_select.dart';
import 'package:pashboi/shared/widgets/app_search_input.dart';
import 'package:pashboi/shared/widgets/app_text_input.dart';
import 'package:pashboi/features/authenticated/transfer/presentation/pages/internal_transfer_page/bloc/internal_transfer_steps_bloc.dart';
import 'package:pashboi/features/authenticated/transfer/presentation/pages/internal_transfer_page/sections/transfer_to_account_section/bloc/transfer_search_account_bloc.dart';
import 'package:pashboi/features/authenticated/beneficiaries/presentation/pages/beneficiaries_bloc/beneficiaries_bloc.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/presentation/bloc/collection_ledger_bloc.dart';

class TransferToAccountSection extends StatefulWidget {
  final String? sectionTitle;

  final String? searchAccountNumber;
  final String? searchAccountNumberError;

  final String? beneficiaryAccountNumber;

  final String? searchedAccountHolderName;
  final String? searchedAccountHolderNameError;

  final void Function(String? accountNumber) onChangeSearchAccountNumber;
  final void Function(String? accountNumber) changeSearchAccountNumber;
  final void Function(String? beneficiaryAccountNumber)
  changeBeneficiaryAccountNumber;
  final void Function(String? accountHolderName)
  changeSearchedAccountHolderName;

  const TransferToAccountSection({
    super.key,
    this.sectionTitle,
    required this.searchAccountNumber,
    required this.searchAccountNumberError,
    required this.beneficiaryAccountNumber,
    required this.searchedAccountHolderName,
    required this.searchedAccountHolderNameError,
    required this.onChangeSearchAccountNumber,
    required this.changeSearchAccountNumber,
    required this.changeBeneficiaryAccountNumber,
    required this.changeSearchedAccountHolderName,
  });

  @override
  State<TransferToAccountSection> createState() =>
      _TransferToAccountSectionState();
}

class _TransferToAccountSectionState extends State<TransferToAccountSection> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransferSearchAccountBloc, TransferSearchAccountState>(
      listener: (context, state) {
        if (state is TransferSearchAccountError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          widget.changeSearchedAccountHolderName("");
        } else if (state is TransferSearchAccountLoaded) {
          // Update the UI with the loaded account holder name
          widget.changeSearchedAccountHolderName(state.accountHolderName);

          // Also propagate this into your internal-transfer step data
          context.read<InternalTransferStepsBloc>().add(
            InternalTransferUpdateStepData(
              step: 2,
              data: {'searchedAccountHolderName': state.accountHolderName},
            ),
          );
        }
      },
      builder: (context, state) {
        // Decide what name to show in the name field
        String? displayedName = widget.searchedAccountHolderName;
        if (state is TransferSearchAccountLoaded) {
          displayedName = state.accountHolderName;
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNomineeSelectionCard(context, displayedName),
            const SizedBox(height: 25),
          ],
        );
      },
    );
  }

  void _searchWithAccountNumber(String searchText) {
    if (searchText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Locales.string(context, 'please_enter_account_number')),
        ),
      );
      return;
    }

    context.read<TransferSearchAccountBloc>().add(
      FetchTransferSearchAccountEvent(searchText: searchText, moduleCode: '16'),
    );
  }

  Widget _buildNomineeSelectionCard(
    BuildContext context,
    String? displayedName,
  ) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.colorScheme.primary),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, widget.sectionTitle ?? "Search Account"),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                BlocBuilder<BeneficiariesBloc, BeneficiariesState>(
                  builder: (context, bState) {
                    if (bState is BeneficiariesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (bState is BeneficiariesError) {
                      return Center(child: Text(bState.message));
                    } else if (bState is BeneficiariesLoaded) {
                      final beneficiaries =
                          bState.beneficiaries
                              .where(
                                (e) =>
                                    e.accountNumber !=
                                        widget.beneficiaryAccountNumber &&
                                    e.accountNumber.contains('T'),
                              )
                              .toList();

                      if (beneficiaries.isEmpty) return const SizedBox.shrink();

                      return AppDropdownSelect(
                        value: widget.beneficiaryAccountNumber,
                        items:
                            beneficiaries
                                .map(
                                  (e) => DropdownMenuItem<String>(
                                    value: e.accountNumber,
                                    child: Text(
                                      "${e.name.trim()} (${e.accountNumber.trim()})",
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          widget.changeSearchAccountNumber(value);
                          widget.changeBeneficiaryAccountNumber(value);
                          _searchWithAccountNumber(value ?? '');
                        },
                        label: Locales.string(context, 'beneficiary'),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                const SizedBox(height: 10),
                Text(Locales.string(context, 'or')),
                const SizedBox(height: 10),
                BlocBuilder<CollectionLedgerBloc, CollectionLedgerState>(
                  builder: (context, cState) {
                    bool isLoading = cState is CollectionLedgerLoading;
                    return AppSearchTextInput(
                      initialValue: widget.searchAccountNumber,
                      label: Locales.string(context, 'account_number'),
                      isSearch: true,
                      errorText: widget.searchAccountNumberError,
                      enabled: !isLoading,
                      prefixIcon: Icon(
                        FontAwesomeIcons.piggyBank,
                        color: theme.colorScheme.onSurface,
                      ),
                      onChanged: widget.onChangeSearchAccountNumber,
                      onSearchPressed: () {
                        _searchWithAccountNumber(
                          widget.searchAccountNumber ?? '',
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                AppTextInput(
                  initialValue: displayedName,
                  label: Locales.string(context, 'account_holder_name'),
                  errorText: widget.searchedAccountHolderNameError,
                  prefixIcon: Icon(
                    Icons.person,
                    color: theme.colorScheme.onSurface,
                  ),
                  enabled: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
