import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pashboi/shared/widgets/responsive_content.dart';

void main() {
  testWidgets('fills narrow phone width', (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ResponsiveContent(
            child: SizedBox(key: ValueKey('content'), height: 100),
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byKey(const ValueKey('content'))).width, 360);
  });

  testWidgets('centers content and caps width on wide screens', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1600, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ResponsiveContent(
            maxWidth: 1024,
            child: SizedBox(key: ValueKey('content'), height: 100),
          ),
        ),
      ),
    );

    final contentRect = tester.getRect(find.byKey(const ValueKey('content')));
    expect(contentRect.width, 1024);
    expect(contentRect.center.dx, 800);
  });
}
