import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/core/utils/my_date_utils.dart';
import 'package:pashboi/features/authenticated/deposit/presentation/pages/scheduled_deposits_page/bloc/scheduled_deposits_bloc.dart';
import 'package:pashboi/routes/auth_routes_name.dart';
import 'package:pashboi/shared/widgets/app_icon_card.dart';
import 'package:pashboi/shared/widgets/page_container.dart';

class BankToDcDepositsPage extends StatefulWidget {
  const BankToDcDepositsPage({super.key});

  @override
  State<BankToDcDepositsPage> createState() => _BankToDcDepositsPageState();
}

class _BankToDcDepositsPageState extends State<BankToDcDepositsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ScheduledDepositsBloc>().add(FetchScheduledDeposits());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Locales.string(context, "bank_to_dc_deposits_page_title")),
      ),
      body: PageContainer(
        child: SafeArea(
          child: BlocBuilder<ScheduledDepositsBloc, ScheduledDepositsState>(
            builder: (context, state) {
              if (state is ScheduledDepositsLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ScheduledDepositsFailure) {
                return Center(
                  child: Text(
                    state.error,
                    style: TextStyle(
                      color: context.theme.colorScheme.error,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }

              if (state is ScheduledDepositsLoaded) {
                final depositRequests =
                    state.depositRequests
                        .where((request) => request.transactionMethod == 'Bank')
                        .toList();

                if (depositRequests.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          FontAwesomeIcons.boxOpen,
                          size: 60,
                          color: context.theme.colorScheme.onSurface
                              .withOpacity(0.4),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          Locales.string(context, "empty_bank_to_dc_transfer"),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: context.theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  itemCount: depositRequests.length,
                  itemBuilder: (context, index) {
                    final info = depositRequests[index];
                    final requestStatus = info.status;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: AppIconCard(
                        leftIcon: FontAwesomeIcons.calendarDays,
                        cardBody: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${Locales.string(context, "bank_to_dc_deposit_info_page_request_id_label")}: ${info.id}",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: context.theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${Locales.string(context, "bank_to_dc_deposit_info_page_type_label")}: ${info.transactionMethod == "Savings Account" ? "Schedule Deposit" : "From ${info.transactionMethod} To D.C Account"}",
                              style: TextStyle(
                                color: context.theme.colorScheme.onSurface,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${Locales.string(context, "bank_to_dc_deposit_info_page_schedule_date_label")}: ${MyDateUtils.formatDate(info.depositDate)}",
                              style: TextStyle(
                                fontSize: 12,
                                color: context.theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 0,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    requestStatus == "Approved"
                                        ? Colors.green
                                        : Colors.orange,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                requestStatus,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.normal,
                                  color:
                                      requestStatus == "Approved"
                                          ? context.theme.colorScheme.onTertiary
                                          : context
                                              .theme
                                              .colorScheme
                                              .onSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        boarderColor: context.theme.colorScheme.primary,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AuthRoutesName.bankToDcTransferInfoPage,
                            arguments: {'depositRequest': info},
                          );
                        },
                      ),
                    );
                  },
                );
              }

              // Default fallback (initial state or add success)
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
