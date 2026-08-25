import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/core/extensions/string_casing_extension.dart';
import 'package:pashboi/core/injection.dart';
import 'package:pashboi/core/utils/my_date_utils.dart';
import 'package:pashboi/core/utils/taka_formatter.dart';
import 'package:pashboi/features/authenticated/my_accounts/presentation/pages/account_details_page/bloc/account_details_bloc.dart';
import 'package:pashboi/routes/auth_routes_name.dart';
import 'package:pashboi/shared/widgets/page_container.dart';

class AccountDetailsPage extends StatefulWidget {
  final String accountNumber;

  const AccountDetailsPage({super.key, required this.accountNumber});

  @override
  State<AccountDetailsPage> createState() => _AccountDetailsPageState();
}

class _AccountDetailsPageState extends State<AccountDetailsPage> {
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
          bottom: BorderSide(
            color: colorScheme.primary,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  sl<AccountDetailsBloc>()..add(
                    FetchAccountDetailsEvent(
                      accountNumber: widget.accountNumber,
                    ),
                  ),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(Locales.string(context, 'account_details_page_title')),
        ),
        body: SafeArea(
          child: PageContainer(
            child: BlocBuilder<AccountDetailsBloc, AccountDetailsState>(
              builder: (context, state) {
                if (state is AccountDetailsLoading ||
                    state is AccountDetailsInitial) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is AccountDetailsError) {
                  return Center(child: Text(state.error));
                }

                if (state is AccountDetailsSuccess) {
                  final account = state.account;

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 35),
                        Icon(
                          FontAwesomeIcons.piggyBank,
                          size: 60,
                          color: context.theme.colorScheme.onSurface,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          account.name.toTitleCase(),
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
                              side: BorderSide(
                                color: context.theme.colorScheme.secondary,
                                width: 1,
                              ),
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                            Chip(
                              label: Text(
                                account.defaultAccount
                                    ? "Defaulter"
                                    : "Regular",
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      account.defaultAccount
                                          ? context.theme.colorScheme.onError
                                          : context.theme.colorScheme.onPrimary,
                                ),
                              ),
                              backgroundColor:
                                  account.defaultAccount
                                      ? context.theme.colorScheme.error
                                      : context.theme.colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(
                                color:
                                    account.defaultAccount
                                        ? context.theme.colorScheme.error
                                        : context.theme.colorScheme.primary,
                                width: 1,
                              ),
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
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
                                'account_details_page_balance',
                              ),
                              TakaFormatter.format(account.balance),
                              context.theme.colorScheme.secondary,
                              context.theme.colorScheme.onSecondary,
                            ),
                            if (account.typeCode == "16")
                              _buildCircleStat(
                                context,
                                // "Withdrawable",
                                Locales.string(
                                  context,
                                  'account_details_page_withdrawable',
                                ),
                                TakaFormatter.format(
                                  account.withdrawableBalance,
                                ),
                                context.theme.colorScheme.primary,
                                context.theme.colorScheme.onPrimary,
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
                                'account_details_page_last_deposit_date',
                              ),
                              MyDateUtils.formatDate(account.lastPaidDate),
                              icon: FontAwesomeIcons.calendarCheck,
                            ),
                            buildInfoRow(
                              context,
                              Locales.string(
                                context,
                                'account_details_page_maturity_date',
                              ),
                              MyDateUtils.formatDate(account.maturityDate),
                              icon: FontAwesomeIcons.hourglassEnd,
                            ),
                            buildInfoRow(
                              context,
                              Locales.string(
                                context,
                                'account_details_page_nominee',
                              ),
                              account.nominees.toTitleCase(),
                              icon: FontAwesomeIcons.userShield,
                            ),
                            // AccountStatementPage(),
                          ],
                        ),
                        const SizedBox(height: 20),

                        if (!["18", "30", "22"].contains(account.typeCode)) ...[
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AuthRoutesName.accountStatementPage,
                                arguments: {
                                  // 'accountNumber': account.number.trim(),
                                  'accountDetails': account,
                                },
                              );
                            },

                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              backgroundColor:
                                  context.theme.colorScheme.primary,
                              foregroundColor:
                                  context.theme.colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              Locales.string(
                                context,
                                'account_details_page_view_statement_button_text',
                              ),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
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
}
