import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/core/theme/values/dimensions/app_dimensions.dart';

void main() {
  for (final (width, containerWidth) in [
    (390.0, 425.0),
    (800.0, 768.0),
    (1440.0, 1024.0),
  ]) {
    testWidgets('provides usable dimensions at $width px', (tester) async {
      late AppDimensions dimensions;
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(width, 800)),
            child: Builder(
              builder: (context) {
                dimensions = context.appDimensions;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(dimensions.containerWidth, containerWidth);
      expect(dimensions.buttonHeight, greaterThan(0));
      expect(dimensions.inputHeight, greaterThan(0));
      expect(dimensions.cardContentIconSize, greaterThan(0));
    });
  }
}
