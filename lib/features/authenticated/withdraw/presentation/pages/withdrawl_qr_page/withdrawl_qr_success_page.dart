import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:pashboi/shared/widgets/buttons/app_primary_button.dart';
import 'package:pashboi/shared/widgets/page_container.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class WithdrawQrSuccessPage extends StatelessWidget {
  final String successMessage;

  const WithdrawQrSuccessPage({super.key, required this.successMessage});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(Locales.string(context, "otqr_generated_successfully")),
      ),
      body: SafeArea(
        child: PageContainer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 📷 QR Code image section
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outlineVariant,
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: QrImageView(
                  data: successMessage,
                  version: QrVersions.auto,
                  size: 250.0,
                  backgroundColor: Colors.white,
                ),
              ),

              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.share),
                label: Text(Locales.string(context, 'share_qr_code')),
                onPressed: () async {
                  await _shareQrCode(successMessage);
                },
              ),

              const SizedBox(height: 20),
              // ✅ Main title
              Text(
                Locales.string(context, 'withdrawl_qr_generated'),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // 🚀 CTA Button
              AppPrimaryButton(
                label: Locales.string(context, 'back_to_home'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                iconBefore: Icon(
                  Icons.home,
                  color: context.theme.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Uint8List> _generateQrCodeBytes(String data) async {
    final painter = QrPainter(
      data: data,
      version: QrVersions.auto,
      gapless: true,
      eyeStyle: const QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: Colors.black,
      ),
      dataModuleStyle: const QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: Colors.black,
      ),
    );

    final uiImage = await painter.toImage(300);
    final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<void> _shareQrCode(String data) async {
    final bytes = await _generateQrCodeBytes(data);

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/qr_code.png');
    await file.writeAsBytes(bytes);

    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)], text: 'Here is your QR code!'),
    );
  }
}
