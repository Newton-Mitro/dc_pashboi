import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/core/extensions/string_casing_extension.dart';
import 'package:pashboi/features/authenticated/beneficiaries/presentation/pages/beneficiaries_bloc/beneficiaries_bloc.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/domain/entities/collection_ledger_entity.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/presentation/bloc/collection_ledger_bloc.dart';
import 'package:pashboi/shared/widgets/app_dropdown_select.dart';
import 'package:pashboi/shared/widgets/app_search_input.dart';
import 'package:pashboi/shared/widgets/app_text_input.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DepositForSection extends StatefulWidget {
  final String? sectionTitle;
  final String? searchAccountNumber;
  final String? searchAccountNumberError;
  final String? searchedAccountHolderNameError;
  final String? beneficiaryAccountNumber;
  final void Function(List<CollectionLedgerEntity> collectionLedgers)
  setCollectionLedgers;
  final String? searchedAccountHolderName;
  final void Function(String? accountNumber) changeSearchAccountNumber;
  final void Function(String? accountNumber) onChangeSearchAccountNumber;
  final void Function(String? beneficiaryAccountNumber)
  changeBeneficiaryAccountNumber;
  final void Function(String? accountHolderName)
  changeSearchedAccountHolderName;

  const DepositForSection({
    super.key,
    required this.searchAccountNumber,
    required this.searchedAccountHolderName,
    required this.searchAccountNumberError,
    required this.searchedAccountHolderNameError,
    required this.beneficiaryAccountNumber,
    required this.sectionTitle,
    required this.setCollectionLedgers,
    required this.changeSearchAccountNumber,
    required this.onChangeSearchAccountNumber,
    required this.changeBeneficiaryAccountNumber,
    required this.changeSearchedAccountHolderName,
  });

  @override
  State<DepositForSection> createState() => _DepositForSectionState();
}

class _DepositForSectionState extends State<DepositForSection> {
  void _searchWithAccountNumber(String searchText) {
    if (searchText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Locales.string(context, 'please_enter_account_number')),
        ),
      );
      return;
    }

    context.read<CollectionLedgerBloc>().add(
      FetchCollectionLedgersEvent(searchText: searchText, moduleCode: '16'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CollectionLedgerBloc, CollectionLedgerState>(
      listener: (context, state) {
        if (state is CollectionLedgerError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          widget.changeSearchedAccountHolderName("");
        }
        if (state is CollectionLedgerLoaded) {
          final ledgers = state.collectionAggregate.ledgers;
          widget.setCollectionLedgers(ledgers);

          final searchText = widget.searchAccountNumber ?? '';
          final onlyDigits = searchText.replaceAll(RegExp(r'\D'), '');

          try {
            final matchedLedger = ledgers.firstWhere(
              (ledger) => ledger.accountNumber.trim().contains(onlyDigits),
            );

            widget.changeSearchAccountNumber(
              matchedLedger.accountNumber.trim(),
            );
            widget.changeSearchedAccountHolderName(
              state.collectionAggregate.accountHolderInfo.name
                  .trim()
                  .toTitleCase(),
            );
          } catch (_) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Account not found")));
          }
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildNomineeSelectionCard(context),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

  Widget _buildNomineeSelectionCard(BuildContext context) {
    final theme = context.theme;
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
                  builder: (context, state) {
                    if (state is BeneficiariesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is BeneficiariesError) {
                      return Center(child: Text(state.message));
                    }
                    if (state is BeneficiariesLoaded) {
                      var beneficiaries = state.beneficiaries;

                      if (beneficiaries.isEmpty) {
                        return const SizedBox.shrink();
                      } else {
                        return AppDropdownSelect(
                          value: widget.beneficiaryAccountNumber,
                          items:
                              beneficiaries
                                  .map(
                                    (e) => DropdownMenuItem<String>(
                                      value: e.accountNumber,
                                      child: Text(
                                        "${e.name.trim().toTitleCase()} (${e.accountNumber.trim()})",
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            widget.changeSearchAccountNumber(value);
                            widget.changeBeneficiaryAccountNumber(value);
                            _searchWithAccountNumber(value ?? '');
                          },
                          label: Locales.string(context, "beneficiary"),
                        );
                      }
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 10),
                Text(Locales.string(context, "or")),
                const SizedBox(height: 10),
                BlocBuilder<CollectionLedgerBloc, CollectionLedgerState>(
                  builder: (context, state) {
                    return AppSearchTextInput(
                      initialValue: widget.searchAccountNumber,
                      label: Locales.string(context, "account_number"),
                      isSearch: true,
                      errorText: widget.searchAccountNumberError,
                      enabled: state is! CollectionLedgerLoading,
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
                  initialValue: widget.searchedAccountHolderName,
                  label: Locales.string(context, "account_holder_name"),
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
    final theme = context.theme;
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
