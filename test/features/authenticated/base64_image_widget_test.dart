import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/widgets/base64_image_widget.dart';

void main() {
  testWidgets('decodes base64 image asynchronously', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 100,
            height: 100,
            child: Base64ImageWidget(
              base64String:
                  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAADUlEQVR4nGP4z8AAAAMBAQDJ/pLvAAAAAElFTkSuQmCC',
            ),
          ),
        ),
      ),
    );
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump();

    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('shows placeholder when there is no image', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Base64ImageWidget(base64String: '')),
      ),
    );
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump();

    expect(find.byIcon(Icons.person), findsOneWidget);
  });
}
