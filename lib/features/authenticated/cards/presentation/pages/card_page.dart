import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/features/authenticated/cards/domain/entities/debit_card_entity.dart';
import 'package:pashboi/features/authenticated/cards/presentation/pages/bloc/debit_card_bloc.dart';
import 'package:pashboi/shared/widgets/app_logo.dart';
import 'package:pashboi/shared/widgets/buttons/app_primary_button.dart';
import 'package:pashboi/shared/widgets/page_container.dart';

class CardPage extends StatelessWidget {
  const CardPage({super.key});

  // bool _isExpired(String expiryDate) {
  //   try {
  //     final parts = expiryDate.split('/');
  //     if (parts.length != 3) return false;
  //     final expiry = DateTime(
  //       int.parse(parts[2]),
  //       int.parse(parts[1]),
  //       int.parse(parts[0]),
  //     );
  //     return DateTime.now().isAfter(expiry);
  //   } catch (_) {
  //     return false;
  //   }
  // }

  String? expiryDateHandler(String expiryDate) {
    try {
      final parts = expiryDate.split('/');
      if (parts.length != 3) return null;

      final int day = int.parse(parts[0]);
      final int month = int.parse(parts[1]);
      final int year = int.parse(parts[2]);

      // Expiry date
      final expiry = DateTime(year, month, day);

      // Today's date (without time)
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      // Expired
      if (expiry.isBefore(today)) {
        return 'This card is expired, please apply for re-issue.';
      }

      // Difference
      final difference = expiry.difference(today);

      // Expires today
      if (difference.inDays == 0) {
        final hours = expiry.difference(now).inHours;
        return 'Expires in $hours Hour, please apply for re-issue';
      }

      // Expires within 30 days
      if (difference.inDays <= 30) {
        return 'Expires in ${difference.inDays - 1} days, please apply for re-issue';
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double cardHeight =
        context.isMobile
            ? MediaQuery.of(context).size.height * 0.27
            : MediaQuery.of(context).size.height * 0.5;
    final double cardWidth = cardHeight * 2.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(Locales.string(context, 'my_cards_page_title')),
      ),
      body: PageContainer(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: MultiBlocListener(
              listeners: [
                BlocListener<DebitCardBloc, DebitCardState>(
                  listener: (context, state) {
                    if (state.successMessage != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.successMessage!)),
                      );
                      context.read<DebitCardBloc>().add(const DebitCardLoad());
                    } else if (state.error != null) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.error!)));
                    }
                  },
                ),
              ],
              child: BlocBuilder<DebitCardBloc, DebitCardState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.error != null) {
                    return Center(child: Text(state.error!));
                  }

                  if (state.debitCard != null) {
                    final card = state.debitCard!;
                    final expiryMessage = expiryDateHandler(card.expiryDate);

                    return Column(
                      children: [
                        _buildCardView(card, context, cardHeight, cardWidth),

                        if (expiryMessage != null) ...[
                          const SizedBox(height: 16),

                          Text(
                            expiryMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 12),

                          AppPrimaryButton(
                            label: Locales.string(context, "apply_for_reissue"),
                            enabled: true,
                            onPressed: () {
                              context.read<DebitCardBloc>().add(
                                DebitCardReIssue(
                                  cardNumber: card.cardNumber,
                                  cardTypeCode: card.type,
                                  virtualCard: true,
                                  nameOnCard: card.nameOnCard,
                                ),
                              );
                            },
                          ),
                        ],
                      ],
                    );
                  }

                  return Center(
                    child: AppPrimaryButton(
                      label: Locales.string(context, "issue_a_card"),
                      enabled: true,
                      onPressed: () {
                        context.read<DebitCardBloc>().add(
                          const DebitCardIssue(
                            cardTypeCode: '',
                            withCard: true,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardView(
    DebitCardEntity card,
    BuildContext context,
    double cardHeight,
    double cardWidth,
  ) {
    return Card(
      elevation: 3.0,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: context.theme.colorScheme.primary, width: 2),
      ),
      child: SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/bg/card_bg.png',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                right: 15.0,
                bottom: 15.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppLogo(width: 80, showOrganizationName: false),
                      Text(
                        card.type.toUpperCase(),
                        style: TextStyle(
                          color: context.theme.colorScheme.onSurface,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color:
                                card.isBlock
                                    ? Colors.orange
                                    : card.isActive
                                    ? Colors.green
                                    : Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            card.isBlock
                                ? "BLOCKED"
                                : card.isActive
                                ? "ACTIVE"
                                : "INACTIVE",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 5,
                            ),
                          ),
                        ),
                        Text(
                          card.cardNumber.replaceAllMapped(
                            RegExp(r".{1,4}"),
                            (match) => "${match.group(0)}   ",
                          ),
                          style: TextStyle(
                            color: context.theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        card.nameOnCard.toUpperCase(),
                        style: TextStyle(
                          color: context.theme.colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Valid Thru",
                            style: TextStyle(
                              color: context.theme.colorScheme.onSurface,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            card.expiryDate,
                            style: TextStyle(
                              color: context.theme.colorScheme.onSurface,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
