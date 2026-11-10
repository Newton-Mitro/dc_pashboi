import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pashboi/shared/widgets/app_text_input.dart';
import 'package:pashboi/shared/widgets/buttons/app_primary_button.dart';

void main() {
  testWidgets('text input remains visible at large text scale', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(2)),
            child: child!,
          );
        },
        home: const Scaffold(
          body: Padding(
            padding: EdgeInsets.all(8),
            child: AppTextInput(label: 'A long input label'),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('primary button handles a narrow viewport', (tester) async {
    await tester.binding.setSurfaceSize(const Size(180, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: AppPrimaryButton(
              label: 'Continue to next step',
              onPressed: () {},
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Continue to next step'), findsOneWidget);
  });
}
