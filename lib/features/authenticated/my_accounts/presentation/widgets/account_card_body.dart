import 'package:flutter/material.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/core/utils/taka_formatter.dart';

class AccountCardBody extends StatelessWidget {
  const AccountCardBody({
    super.key,
    required this.accountName,
    required this.accountNumber,
    required this.balance,
  });

  final String accountName;
  final String accountNumber;
  final double balance;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          accountName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: context.theme.colorScheme.onSurface,
          ),
        ),
        Text(
          accountNumber.trim(),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Lexend',
            fontWeight: FontWeight.normal,
            color: context.theme.colorScheme.onSurface,
          ),
        ),
        Text(
          TakaFormatter.format(balance),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Lexend',
            fontWeight: FontWeight.normal,
            color: context.theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
