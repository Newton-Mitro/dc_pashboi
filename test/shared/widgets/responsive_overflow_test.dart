import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pashboi/shared/widgets/app_dialog.dart';
import 'package:pashboi/shared/widgets/responsive_key_value_row.dart';

void main() {
  testWidgets('long key/value text wraps on a narrow screen', (tester) async {
    await tester.binding.setSurfaceSize(const Size(280, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: EdgeInsets.all(12),
            child: ResponsiveKeyValueRow(
              label: 'Long account label that should wrap',
              value: 'A very long account value 12345678901234567890',
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('dialog actions wrap and content scrolls on short screens', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 420));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder:
                (context) => Center(
                  child: AppDialog(
                    title: 'Confirm action',
                    content: List.filled(
                      14,
                      'A long confirmation message',
                    ).join(' '),
                    icon: const Icon(Icons.info),
                    positiveButtonLabel: 'Proceed with this action',
                    negativeButtonLabel: 'Cancel this action',
                    onPositiveButtonTap: () {},
                  ),
                ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
