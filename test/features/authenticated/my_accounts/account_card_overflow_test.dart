import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pashboi/features/authenticated/my_accounts/presentation/widgets/account_card_body.dart';
import 'package:pashboi/shared/widgets/app_icon_card.dart';

void main() {
  testWidgets('account card has no bottom overflow at default text scale', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: AppIconCard(
              leftIcon: Icons.account_balance,
              rightIcon: Icons.chevron_right,
              boarderColor: Colors.blue,
              cardBody: const AccountCardBody(
                accountName: 'Regular account',
                accountNumber: '123456789012345',
                balance: 123456.78,
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('account card fits long values on narrow screens', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(1.5)),
            child: child!,
          );
        },
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: AppIconCard(
              leftIcon: Icons.account_balance,
              rightIcon: Icons.chevron_right,
              boarderColor: Colors.blue,
              cardBody: const AccountCardBody(
                accountName: 'Long term deposit account name',
                accountNumber: '12345678901234567890',
                balance: 123456789.12,
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
