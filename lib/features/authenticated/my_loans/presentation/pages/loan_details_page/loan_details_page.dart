import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/core/extensions/string_casing_extension.dart';
import 'package:pashboi/core/injection.dart';
import 'package:pashboi/core/utils/my_date_utils.dart';
import 'package:pashboi/core/utils/taka_formatter.dart';
import 'package:pashboi/features/authenticated/my_loans/presentation/pages/loan_details_page/bloc/loan_details_bloc.dart';
import 'package:pashboi/routes/auth_routes_name.dart';
import 'package:pashboi/shared/widgets/page_container.dart';

class LoanDetailsPage extends StatefulWidget {
  final String loanNumber;
  const LoanDetailsPage({super.key, required this.loanNumber});

  @override
  State<LoanDetailsPage> createState() => _LoanDetailsPageState();
}

class _LoanDetailsPageState extends State<LoanDetailsPage> {
  Widget buildInfoRow(
    BuildContext context,
    String title,
    String value, {
    IconData icon = Icons.info_outline,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Icon(icon, size: 20, color: colorScheme.onPrimary),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    color: colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleStat(
    BuildContext context,
    String title,
    String value,
    Color backgroundColor,
    Color borderColor,
  ) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        border: Border.all(color: borderColor, width: 3),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: context.theme.colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: context.theme.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  sl<LoanDetsilsBloc>()
                    ..add(FetchLoanDetsilsEvent(loanNumber: widget.loanNumber)),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(Locales.string(context, 'loan_details_page_title')),
        ),
        body: PageContainer(
          child: BlocBuilder<LoanDetsilsBloc, LoanDetailsState>(
            builder: (context, state) {
              if (state is LoanDetsilsLoading || state is LoanDetailsInitial) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is LoanDetailsError) {
                return Center(child: Text(state.error));
              }

              if (state is LoanDetailsSuccess) {
                final account = state.loan;

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 35),
                      Icon(
                        FontAwesomeIcons.sackDollar,
                        size: 60,
                        color: context.theme.colorScheme.onSurface,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        account.loaneeName.toTitleCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: context.theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        account.typeName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: context.theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        account.number,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          color: context.theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 20,
                        children: [
                          Chip(
                            label: Text(
                              account.status.toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                color: context.theme.colorScheme.onSecondary,
                              ),
                            ),
                            backgroundColor:
                                context.theme.colorScheme.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          Chip(
                            label: Text(
                              account.defaulter ? "Defaulter" : "Regular",
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    account.defaulter
                                        ? context.theme.colorScheme.onError
                                        : context.theme.colorScheme.onPrimary,
                              ),
                            ),
                            backgroundColor:
                                account.defaulter
                                    ? context.theme.colorScheme.error
                                    : context.theme.colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildCircleStat(
                            context,
                            Locales.string(
                              context,
                              'loan_details_page_issued_loan',
                            ),
                            // "Issued",
                            TakaFormatter.format(account.issuedAmount),
                            context.theme.colorScheme.primary,
                            context.theme.colorScheme.onPrimary,
                          ),
                          _buildCircleStat(
                            context,
                            Locales.string(
                              context,
                              'loan_details_page_loan_remaining',
                            ),
                            TakaFormatter.format(account.loanBalance),
                            context.theme.colorScheme.secondary,
                            context.theme.colorScheme.onSecondary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Column(
                        children: [
                          buildInfoRow(
                            context,
                            Locales.string(
                              context,
                              'loan_details_page_last_repayment_date',
                            ),
                            MyDateUtils.formatDate(account.lastPaidDate),
                            icon: FontAwesomeIcons.calendarCheck,
                          ),

                          buildInfoRow(
                            context,
                            Locales.string(
                              context,
                              'loan_details_page_loan_end_date',
                            ),
                            MyDateUtils.formatDate(account.loanEndDate),
                            icon: FontAwesomeIcons.hourglassEnd,
                          ),
                          buildInfoRow(
                            context,
                            Locales.string(
                              context,
                              'loan_details_page_interest_rate',
                            ),
                            "${account.interestRate.toStringAsFixed(2)}%",
                            icon: FontAwesomeIcons.percent,
                          ),
                          buildInfoRow(
                            context,
                            Locales.string(
                              context,
                              'loan_details_page_interest_days',
                            ),
                            "${account.interestForDays} Days",
                            icon: FontAwesomeIcons.clock,
                          ),
                          buildInfoRow(
                            context,
                            Locales.string(
                              context,
                              'loan_details_page_installments',
                            ),
                            account.numberOfInstallments.toString(),
                            icon: FontAwesomeIcons.listOl,
                          ),
                          buildInfoRow(
                            context,
                            Locales.string(
                              context,
                              'loan_details_page_refund_amount',
                            ),
                            TakaFormatter.format(account.refundAmount),
                          ),
                          buildInfoRow(
                            context,
                            Locales.string(
                              context,
                              'loan_details_page_defaulter_reason',
                            ),
                            account.defaulterReason,
                            icon: FontAwesomeIcons.triangleExclamation,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  AuthRoutesName.loanStatementPage,
                                  arguments: {
                                    'loanNumber': widget.loanNumber.trim(),
                                  },
                                );
                              },

                              icon: const Icon(Icons.show_chart),
                              label: Text(
                                Locales.string(
                                  context,
                                  'loan_details_page_view_loan_statement',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
