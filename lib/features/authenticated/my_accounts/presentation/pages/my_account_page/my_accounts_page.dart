import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/features/authenticated/my_accounts/presentation/pages/my_account_page/bloc/my_account_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/core/injection.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/entities/deposit_account_entity.dart';
import 'package:pashboi/features/authenticated/my_accounts/presentation/widgets/account_card_body.dart';
import 'package:pashboi/shared/widgets/app_icon_card.dart';
import 'package:pashboi/routes/auth_routes_name.dart';
import 'package:pashboi/shared/widgets/page_container.dart';

class MyAccountsPage extends StatelessWidget {
  const MyAccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MyAccountBloc>()..add(FetchMyAccountEvent(0)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(Locales.string(context, 'my_accounts_page_title')),
        ),
        body: SafeArea(
          child: PageContainer(
            child: BlocBuilder<MyAccountBloc, MyAccountState>(
              builder: (context, state) {
                if (state is MyAccountLoading || state is MyAccountInitial) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is MyAccountError) {
                  return Center(child: Text(state.error));
                }

                if (state is MyAccountSuccess) {
                  final accountList = state.myAccounts;

                  if (accountList.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.boxOpen,
                            size: 50,
                            color: context.theme.colorScheme.onSurface
                                .withOpacity(0.6),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            Locales.string(context, 'no_deposit_accounts'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: context.theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 30,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Chart Section
                        SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          backgroundColor: Colors.transparent,
                          legend: Legend(
                            isVisible: true,
                            position: LegendPosition.top,
                            overflowMode: LegendItemOverflowMode.wrap,
                          ),
                          enableSideBySideSeriesPlacement: true,
                          title: ChartTitle(
                            text: Locales.string(
                              context,
                              'my_accounts_page_account_balance_graph',
                            ),
                            textStyle: TextStyle(
                              color: context.theme.colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series:
                              <CartesianSeries<DepositAccountEntity, String>>[
                                BarSeries<DepositAccountEntity, String>(
                                  dataSource: accountList,
                                  xValueMapper: (data, _) => data.shortTypeName,
                                  yValueMapper: (data, _) => data.balance,
                                  name: Locales.string(
                                    context,
                                    'my_accounts_page_deposit_account_label',
                                  ),
                                  color: context.theme.colorScheme.primary,
                                  dataLabelMapper:
                                      (data, _) =>
                                          data.balance.toStringAsFixed(0),
                                  dataLabelSettings: DataLabelSettings(
                                    isVisible: true,
                                  ),
                                ),
                              ],
                        ),

                        const SizedBox(height: 20),

                        // Account Cards
                        Column(
                          children:
                              accountList.map((account) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                  ),
                                  child: AppIconCard(
                                    leftIcon: FontAwesomeIcons.piggyBank,
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
                                          'accountNumber':
                                              account.number.trim(),
                                        },
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox(); // fallback
              },
            ),
          ),
        ),
      ),
    );
  }
}
