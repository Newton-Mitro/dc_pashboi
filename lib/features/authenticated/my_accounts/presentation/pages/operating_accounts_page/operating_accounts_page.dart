import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/core/injection.dart';
import 'package:pashboi/features/authenticated/my_accounts/presentation/pages/operating_accounts_page/bloc/fetch_operating_accounts_bloc.dart';
import 'package:pashboi/features/authenticated/my_accounts/presentation/widgets/account_card_body.dart';
import 'package:pashboi/shared/widgets/app_icon_card.dart';
import 'package:pashboi/routes/auth_routes_name.dart';
import 'package:pashboi/shared/widgets/page_container.dart';

class DependentsAccountsPage extends StatelessWidget {
  final int dependentPersonId;
  const DependentsAccountsPage({super.key, required this.dependentPersonId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              sl<FetchOperatingAccountsBloc>()
                ..add(FetchOperatingAccountsEvent(dependentPersonId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            Locales.string(context, 'dependents_accounts_page_title'),
          ),
        ),
        body: PageContainer(
          child: BlocBuilder<
            FetchOperatingAccountsBloc,
            FetchOperatingAccountsState
          >(
            builder: (context, state) {
              if (state is FetchOperatingAccountsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is FetchOperatingAccountsError) {
                return Center(
                  child: Text(state.message, textAlign: TextAlign.center),
                );
              } else if (state is FetchOperatingAccountsLoaded) {
                final accounts = state.operatingAccounts;

                if (accounts.isEmpty) {
                  return Center(
                    child: Text(
                      Locales.string(context, 'no_operating_account_found'),
                      style: TextStyle(
                        fontSize: 14,
                        color: context.theme.colorScheme.onSurface,
                      ),
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children:
                        accounts.map((account) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: AppIconCard(
                              leftIcon: FontAwesomeIcons.buildingColumns,
                              rightIcon: FontAwesomeIcons.chevronRight,
                              boarderColor:
                                  account.defaultAccount
                                      ? context.theme.colorScheme.error
                                      : context.theme.colorScheme.primary,
                              cardBody: AccountCardBody(
                                accountName: account.typeName.trim(),
                                accountNumber: account.number,
                                balance: account.balance,
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AuthRoutesName.accountsDetailsPage,
                                  arguments: {
                                    'accountNumber': account.number.trim(),
                                  },
                                );
                              },
                            ),
                          );
                        }).toList(),
                  ),
                );
              }

              return const SizedBox(); // fallback
            },
          ),
        ),
      ),
    );
  }
}
