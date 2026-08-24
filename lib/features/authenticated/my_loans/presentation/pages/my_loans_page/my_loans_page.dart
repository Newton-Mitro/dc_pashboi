import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/loan_account_entity.dart';
import 'package:pashboi/features/authenticated/my_loans/presentation/pages/my_loans_page/bloc/my_loans_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/core/injection.dart';
import 'package:pashboi/features/authenticated/my_accounts/presentation/widgets/account_card_body.dart';
import 'package:pashboi/shared/widgets/app_icon_card.dart';
import 'package:pashboi/routes/auth_routes_name.dart';
import 'package:pashboi/shared/widgets/page_container.dart';

class MyLoansPage extends StatelessWidget {
  const MyLoansPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MyLoansBloc>()..add(FetchMyLoansEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(Locales.string(context, 'my_loans_page_title')),
        ),
        body: SafeArea(
          child: PageContainer(
            child: BlocBuilder<MyLoansBloc, MyLoansState>(
              builder: (context, state) {
                if (state is MyLoansLoading || state is MyLoansInitial) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is MyLoansError) {
                  return Center(child: Text(state.error));
                }

                if (state is MyLoansLoaded) {
                  final accountList = state.loans;

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
                            Locales.string(context, 'no_loan_accounts'),
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
                              'my_loans_page_account_balance_graph',
                            ),
                            textStyle: TextStyle(
                              color: context.theme.colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <CartesianSeries<LoanAccountEntity, String>>[
                            BarSeries<LoanAccountEntity, String>(
                              dataSource: accountList,
                              xValueMapper: (data, _) => data.shortTypeName,
                              yValueMapper: (data, _) => data.loanBalance,
                              name: Locales.string(
                                context,
                                'my_loans_page_loan_account_label',
                              ),
                              color: context.theme.colorScheme.primary,
                              dataLabelMapper:
                                  (data, _) =>
                                      data.loanBalance.toStringAsFixed(0),
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
                                        account.defaulter
                                            ? context.theme.colorScheme.error
                                            : context.theme.colorScheme.primary,
                                    cardBody: AccountCardBody(
                                      accountName: account.typeName.trim(),
                                      accountNumber: account.number,
                                      balance: account.loanBalance,
                                    ),
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        AuthRoutesName.loanDetailsPage,
                                        arguments: {
                                          'loanNumber': account.number.trim(),
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
