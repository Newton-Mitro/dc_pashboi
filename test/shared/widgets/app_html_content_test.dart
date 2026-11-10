import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pashboi/shared/widgets/app_html_content.dart';

void main() {
  testWidgets('renders embedded base64 images outside the HTML parser', (
    tester,
  ) async {
    const image =
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+/lWQAAAAASUVORK5CYII=';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppHtmlContent(
            data:
                '<p>Before</p><img src="data:image/png;base64,$image"><p>After</p>',
          ),
        ),
      ),
    );

    expect(find.byType(Image), findsOneWidget);
    expect(find.text('Before'), findsOneWidget);
    expect(find.text('After'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
