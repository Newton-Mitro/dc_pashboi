import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/entities/deposit_account_entity.dart';
import 'package:pashboi/features/authenticated/my_accounts/presentation/pages/add_operating_account_page/bloc/add_operating_account_bloc.dart';
import 'package:pashboi/features/authenticated/my_accounts/presentation/pages/dependents_page/bloc/fetch_dependents_bloc.dart';
import 'package:pashboi/features/authenticated/my_accounts/presentation/pages/my_account_page/bloc/my_account_bloc.dart';
import 'package:pashboi/shared/widgets/app_dropdown_select.dart';
import 'package:pashboi/shared/widgets/app_text_input.dart';
import 'package:pashboi/shared/widgets/page_container.dart';
import 'package:pashboi/shared/widgets/progress_submit_button/progress_submit_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddOperatingAccountPage extends StatefulWidget {
  const AddOperatingAccountPage({super.key});

  @override
  State<AddOperatingAccountPage> createState() =>
      _AddOperatingAccountPageState();
}

class _AddOperatingAccountPageState extends State<AddOperatingAccountPage> {
  final TextEditingController _mobileNumberController = TextEditingController();
  // operatorId  (Users personId)
  int selectedDependentId = 0; // Family Member Id = accountHolderId
  String? selectedAccount;
  int accountHolderInfoId = 0;

  @override
  void initState() {
    super.initState();
    context.read<FetchDependentsBloc>().add(FetchDependentsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Locales.string(context, 'add_operating_account_page_title'),
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AddOperatingAccountBloc, AddOperatingAccountState>(
            listener: (context, state) {
              if (state is AddOperatingAccountSuccess) {
                final snackBar = SnackBar(
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: Locales.string(context, 'oops'),
                    message: Locales.string(
                      context,
                      'operating_account_added_successfully',
                    ),
                    contentType: ContentType.success,
                  ),
                );

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);

                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              }
              if (state is AddOperatingAccountError) {
                final snackBar = SnackBar(
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: Locales.string(context, 'oops'),
                    message: state.message,
                    contentType: ContentType.failure,
                  ),
                );

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
              }
            },
          ),
        ],
        child: BlocBuilder<FetchDependentsBloc, FetchDependentsState>(
          builder: (context, fetchDependentsState) {
            if (fetchDependentsState is FetchDependentsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (fetchDependentsState is FetchDependentsError) {
              return Center(child: Text(fetchDependentsState.message));
            } else if (fetchDependentsState is FetchDependentsLoaded) {
              final dependents = fetchDependentsState.dependents;

              return PageContainer(
                child: BlocBuilder<
                  AddOperatingAccountBloc,
                  AddOperatingAccountState
                >(
                  builder: (context, addOperatingAccountState) {
                    return Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesomeIcons.users,
                                  size: 40,
                                  color: context.theme.colorScheme.onSurface,
                                ),
                                const SizedBox(height: 4),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    Locales.string(
                                      context,
                                      'add_operating_account_page_title',
                                    ),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 45),
                                Column(
                                  spacing: 16,
                                  children: [
                                    AppDropdownSelect<int>(
                                      value: selectedDependentId,
                                      errorText:
                                          addOperatingAccountState
                                                  is AddOperatingAccountValidationErrorState
                                              ? addOperatingAccountState
                                                  .errors['dependents']
                                              : null,
                                      label: Locales.string(
                                        context,
                                        'add_operating_account_page_dependents_input_label',
                                      ),
                                      enabled: dependents.isNotEmpty,
                                      items:
                                          dependents
                                              .map(
                                                (dependent) => DropdownMenuItem(
                                                  value:
                                                      dependent.accountHolderId,
                                                  child: Text(
                                                    dependent.accountHolderName,
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                      onChanged: (value) {
                                        if (value != null) {
                                          context.read<MyAccountBloc>().add(
                                            FetchMyAccountEvent(value),
                                          );
                                          setState(() {
                                            selectedDependentId = value;
                                            selectedAccount = null;
                                          });
                                        }
                                      },
                                      prefixIcon: Icons.person_outline,
                                    ),
                                    BlocBuilder<MyAccountBloc, MyAccountState>(
                                      builder: (context, myAccountsState) {
                                        if (myAccountsState
                                            is MyAccountLoading) {
                                          return const CircularProgressIndicator();
                                        } else if (myAccountsState
                                            is MyAccountError) {
                                          return Text(myAccountsState.error);
                                        } else if (myAccountsState
                                            is MyAccountSuccess) {
                                          final List<DepositAccountEntity>
                                          accounts = myAccountsState.myAccounts;
                                          return AppDropdownSelect<String>(
                                            value: selectedAccount,
                                            label: Locales.string(
                                              context,
                                              'add_operating_account_page_dependents_accounts_input_label',
                                            ),
                                            errorText:
                                                addOperatingAccountState
                                                        is AddOperatingAccountValidationErrorState
                                                    ? addOperatingAccountState
                                                        .errors['dependentsAccounts']
                                                    : null,
                                            items:
                                                accounts
                                                    .map(
                                                      (account) =>
                                                          DropdownMenuItem(
                                                            value:
                                                                account.number,
                                                            child: Text(
                                                              account.number,
                                                            ),
                                                          ),
                                                    )
                                                    .toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                selectedAccount = value;
                                                final selectedAcc =
                                                    accounts
                                                        .where(
                                                          (acc) =>
                                                              acc.number ==
                                                              value,
                                                        )
                                                        .toList();
                                                _mobileNumberController.text =
                                                    selectedAcc.isNotEmpty
                                                        ? selectedAcc
                                                            .first
                                                            .mobileNumber
                                                            .trim()
                                                        : '';
                                                setState(() {
                                                  accountHolderInfoId =
                                                      selectedAcc.isNotEmpty
                                                          ? selectedAcc
                                                              .first
                                                              .accountHolderId
                                                          : 0;
                                                });
                                              });
                                            },
                                            prefixIcon:
                                                Icons
                                                    .account_balance_wallet_outlined,
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                    AppTextInput(
                                      controller: _mobileNumberController,
                                      label: Locales.string(
                                        context,
                                        'add_operating_account_page_mobile_number_input_label',
                                      ),
                                      enabled: false,
                                      prefixIcon: Icon(
                                        FontAwesomeIcons.mobile,
                                        color:
                                            context.theme.colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        ProgressSubmitButton(
                          width: width - 10,
                          height: 100,
                          backgroundColor: context.theme.colorScheme.primary,
                          progressColor: context.theme.colorScheme.secondary,
                          foregroundColor: context.theme.colorScheme.onPrimary,
                          label: Locales.string(
                            context,
                            'press_and_hold_to_submit',
                          ),
                          onSubmit: () {
                            context.read<AddOperatingAccountBloc>().add(
                              AddOperatingAccountEvent(
                                accountHolderId: selectedDependentId,
                                accountHolderInfoId: accountHolderInfoId,
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
