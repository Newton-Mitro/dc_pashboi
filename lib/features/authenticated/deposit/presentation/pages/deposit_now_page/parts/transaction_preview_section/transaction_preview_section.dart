import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/core/utils/taka_formatter.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/widgets/row_info.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/domain/entities/collection_ledger_entity.dart';

class TransactionPreviewSection extends StatelessWidget {
  final List<CollectionLedgerEntity> collectionLedgers;

  const TransactionPreviewSection({super.key, required this.collectionLedgers});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    final totalAmount = collectionLedgers
        .where((ledger) => ledger.isSelected)
        .fold<double>(0, (sum, ledger) => sum + ledger.depositAmount);

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
                      Locales.string(context, 'priview_of_deposit'),
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                // Scrollable List
                Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
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
                    "${Locales.string(context, 'total_deposit_amount')}:",
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
}
