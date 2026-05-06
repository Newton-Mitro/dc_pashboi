import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:intl/intl.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/core/utils/taka_formatter.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/widgets/row_info.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/domain/entities/collection_ledger_entity.dart';

class DepositLaterPreviewSection extends StatelessWidget {
  final List<CollectionLedgerEntity> collectionLedgers;
  final String? depositDate;
  final String? numberOfMonths;

  const DepositLaterPreviewSection({
    super.key,
    required this.collectionLedgers,
    required this.depositDate,
    required this.numberOfMonths,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    final totalAmount = collectionLedgers
        .where((ledger) => ledger.isSelected)
        .fold<double>(0, (sum, ledger) => sum + ledger.depositAmount);

    // ✅ Generate schedule dates
    final scheduleDates = _generateScheduleDates();

    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border.all(color: colorScheme.primary, width: 1.2),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Scrollable content
          Padding(
            padding: const EdgeInsets.only(
              bottom: 60,
            ), // Leave space for fixed bar
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      Locales.string(context, 'deposit_later_preview'),
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ✅ Show Deposit Schedule Before Ledgers
                          if (scheduleDates.isNotEmpty) ...[
                            SectionTitle(
                              Locales.string(context, 'schedule_for_deposit'),
                            ),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children:
                                  scheduleDates
                                      .map(
                                        (date) => Chip(
                                          label: Text(
                                            date,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color:
                                                  context
                                                      .theme
                                                      .colorScheme
                                                      .onPrimary,
                                            ),
                                          ),
                                          backgroundColor: colorScheme.primary,
                                          visualDensity: VisualDensity.compact,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 0,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            side: BorderSide(
                                              color: colorScheme.primary,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // ✅ Show Ledgers
                          SectionTitle(
                            Locales.string(context, 'selected_ledgers'),
                          ),
                          for (final ledger in collectionLedgers)
                            if (ledger.isSelected)
                              InfoRow(collectionLedgerEntity: ledger),

                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Fixed Bottom Total
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 55,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: colorScheme.primary, width: 1.2),
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Locales.string(context, 'total_deposit_amount'),
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    TakaFormatter.format(totalAmount),
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ Generate deposit dates for the given number of months
  List<String> _generateScheduleDates() {
    if (depositDate == null || numberOfMonths == null) return [];

    final int day = int.tryParse(depositDate!) ?? 1;
    final int months = int.tryParse(numberOfMonths!) ?? 1;

    final now = DateTime.now();
    final DateFormat formatter = DateFormat('dd MMM yyyy');

    List<String> dates = [];

    for (int i = 1; i <= months; i++) {
      // ✅ Schedule from next month onward
      final nextMonthDate = DateTime(now.year, now.month + i, day);

      // ✅ If the day exceeds the month's last day, DateTime will auto-adjust
      dates.add(formatter.format(nextMonthDate));
    }

    return dates;
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: context.theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
