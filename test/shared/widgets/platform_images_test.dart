import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pashboi/shared/widgets/app_network_image.dart';
import 'package:pashboi/shared/widgets/picked_image_preview.dart';

void main() {
  testWidgets('picked image preview renders bytes without a filesystem path', (
    tester,
  ) async {
    final image = XFile.fromData(
      base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAADUlEQVR4nGP4z8AAAAMBAQDJ/pLvAAAAAElFTkSuQmCC',
      ),
      name: 'receipt.png',
      mimeType: 'image/png',
    );

    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: PickedImagePreview(file: image))),
    );
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump();

    expect(find.byType(Image), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('network image gives a placeholder when url is missing', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: AppNetworkImage(url: null))),
    );

    expect(find.byIcon(Icons.broken_image_outlined), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
