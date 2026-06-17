import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/features/authenticated/beneficiaries/presentation/pages/add_beneficiary_bloc/add_beneficiary_bloc.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/presentation/bloc/collection_ledger_bloc.dart';
import 'package:pashboi/shared/widgets/app_search_input.dart';
import 'package:pashboi/shared/widgets/app_text_input.dart';
import 'package:pashboi/shared/widgets/page_container.dart';
import 'package:pashboi/shared/widgets/progress_submit_button/progress_submit_button.dart';

class AddBeneficiaryPage extends StatefulWidget {
  const AddBeneficiaryPage({super.key});

  @override
  State<AddBeneficiaryPage> createState() => _AddBeneficiaryPageState();
}

class _AddBeneficiaryPageState extends State<AddBeneficiaryPage> {
  final TextEditingController _accountSearchController =
      TextEditingController();
  final TextEditingController _accountHolderController =
      TextEditingController();

  String _accountNumber = '';

  void _submit() {
    if (!mounted) return;
    context.read<AddBeneficiaryBloc>().add(
      AddBeneficiarySubmit(
        accountNumber: _accountNumber,
        beneficiaryName: _accountHolderController.text.trim(),
      ),
    );
  }

  void _showSnackBar({
    required String title,
    required String message,
    required ContentType contentType,
  }) {
    // 🔐 THIS CHECK IS MANDATORY INSIDE THE FUNCTION TOO
    if (!mounted) return;

    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
      ),
    );

    // Still may crash if context is stale — wrap in post-frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    });
  }

  @override
  void initState() {
    super.initState();
    _accountSearchController.text = '';
  }

  @override
  void dispose() {
    _accountSearchController.dispose();
    _accountHolderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final theme = context.theme;

    return Scaffold(
      appBar: AppBar(
        title: Text(Locales.string(context, 'add_beneficiary_page_title')),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AddBeneficiaryBloc, AddBeneficiaryState>(
            listener: (context, state) {
              if (!mounted) return;

              if (state is AddBeneficiaryFailure) {
                _showSnackBar(
                  title: Locales.string(context, "oops"),
                  message: state.error,
                  contentType: ContentType.failure,
                );
              }

              if (state is AddBeneficiarySuccess) {
                _showSnackBar(
                  title: Locales.string(context, "success"),
                  message: Locales.string(
                    context,
                    "beneficiary_added_successfully",
                  ),
                  contentType: ContentType.success,
                );

                Navigator.pop(context);
              }
            },
          ),
          BlocListener<CollectionLedgerBloc, CollectionLedgerState>(
            listener: (context, state) {
              if (state is CollectionLedgerLoaded) {
                final person = state.collectionAggregate.accountHolderInfo;
                final rawInput = _accountSearchController.text.trim();
                final searchText = rawInput.replaceAll(RegExp(r'\D'), '');

                final matchedAccounts =
                    state.collectionAggregate.ledgers
                        .where(
                          (ledger) => ledger.accountNumber
                              .toLowerCase()
                              .contains(searchText),
                        )
                        .toList();

                if (matchedAccounts.isNotEmpty) {
                  final matchedAccount = matchedAccounts.first;
                  _accountSearchController.text = matchedAccount.accountNumber;
                  setState(() {
                    _accountNumber = matchedAccount.accountNumber;
                  });
                  _accountHolderController.text = person.name;
                } else {
                  _accountSearchController.text = rawInput;
                  _accountHolderController.clear();
                  _accountNumber = '';
                }
              }

              if (state is CollectionLedgerError) {
                _showSnackBar(
                  title: Locales.string(context, "oops"),
                  message: state.message,
                  contentType: ContentType.failure,
                );
              }
            },
          ),
        ],
        child: BlocBuilder<AddBeneficiaryBloc, AddBeneficiaryState>(
          builder: (context, addBeneficiaryState) {
            final validationErrors =
                addBeneficiaryState is AddBeneficiaryValidationError
                    ? addBeneficiaryState.errors
                    : null;

            final isLoading = addBeneficiaryState is AddBeneficiaryLoading;

            return PageContainer(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.users,
                            size: 40,
                            color: theme.colorScheme.onSurface,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            Locales.string(
                              context,
                              'add_beneficiary_page_title',
                            ),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 45),
                          BlocBuilder<
                            CollectionLedgerBloc,
                            CollectionLedgerState
                          >(
                            builder: (context, collectionState) {
                              return AppSearchTextInput(
                                controller: _accountSearchController,
                                label: Locales.string(
                                  context,
                                  'add_beneficiary_page_account_number_input_label',
                                ),
                                isSearch: true,
                                enabled:
                                    collectionState is! CollectionLedgerLoading,
                                prefixIcon: Icon(
                                  FontAwesomeIcons.piggyBank,
                                  color: theme.colorScheme.onSurface,
                                ),
                                errorText:
                                    collectionState
                                            is CollectionLedgerValidationError
                                        ? collectionState.errors['searchText']
                                        : validationErrors?['accountNumber'],
                                onSearchPressed: () {
                                  final searchText =
                                      _accountSearchController.text.trim();
                                  context.read<CollectionLedgerBloc>().add(
                                    FetchCollectionLedgersEvent(
                                      searchText: searchText,
                                      moduleCode: '16',
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          AppTextInput(
                            controller: _accountHolderController,
                            label: Locales.string(
                              context,
                              'add_beneficiary_page_account_holder_name',
                            ),
                            prefixIcon: Icon(
                              Icons.person,
                              color: theme.colorScheme.onSurface,
                            ),
                            enabled: false,
                            errorText: validationErrors?['beneficiaryName'],
                          ),
                        ],
                      ),
                    ),
                  ),
                  ProgressSubmitButton(
                    width: width - 10,
                    height: 100,
                    backgroundColor: theme.colorScheme.primary,
                    progressColor: theme.colorScheme.secondary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    label: Locales.string(context, 'press_and_hold_to_submit'),
                    enabled: !isLoading,
                    onSubmit: isLoading ? null : _submit,
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
