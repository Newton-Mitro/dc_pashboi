import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/core/utils/taka_formatter.dart';

class TransferPreviewSection extends StatelessWidget {
  final String senderName;
  final String senderAccount;
  final String bkashNumber;
  final String transferAmount;

  const TransferPreviewSection({
    super.key,
    required this.senderName,
    required this.senderAccount,
    required this.bkashNumber,
    required this.transferAmount,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final textTheme = context.theme.textTheme;

    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Scrollable content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🌟 Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: Text(
                    Locales.string(context, 'transfer_preview'),
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),

              // 🌐 Preview Content
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _labelValueGroup(
                          context,
                          label: Locales.string(context, 'sender_account'),
                          primary: senderName,
                          secondary: senderAccount,
                        ),
                        Divider(
                          height: 32,
                          color: context.theme.colorScheme.primary,
                        ),
                        _labelValueGroup(
                          context,
                          label: Locales.string(context, 'bkash_wallet'),
                          primary: "+880-$bkashNumber",
                        ),
                        Divider(
                          height: 32,
                          color: context.theme.colorScheme.primary,
                        ),
                        _labelValueGroup(
                          context,
                          label: Locales.string(context, 'transfer_amount'),
                          primary: TakaFormatter.format(
                            double.parse(transferAmount),
                          ),
                        ),
                      ],
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

  Widget _labelValueGroup(
    BuildContext context, {
    required String label,
    required String primary,
    String? secondary,
    bool highlight = false,
  }) {
    final textTheme = context.theme.textTheme;
    final colorScheme = context.theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment:
          secondary == null
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              primary,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: highlight ? colorScheme.primary : null,
              ),
            ),
            if (secondary != null)
              Text(
                secondary,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
