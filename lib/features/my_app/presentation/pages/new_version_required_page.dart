import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/shared/widgets/page_container.dart';
import 'package:pashboi/shared/widgets/app_logo.dart';
import 'package:url_launcher/url_launcher.dart';

class NewVersionRequiredPage extends StatelessWidget {
  final String message;

  const NewVersionRequiredPage({super.key, required this.message});

  Future<void> _launchUpdateUrl() async {
    const url = 'https://your-app-update-link.com'; // Replace with real link
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageContainer(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppLogo(width: 150),

                  const SizedBox(height: 32),

                  Text(
                    Locales.string(context, 'update_required'),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: context.theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 16,
                      color: context.theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: context.theme.colorScheme.primary,
                      foregroundColor: context.theme.colorScheme.onPrimary,
                    ),
                    onPressed: _launchUpdateUrl,
                    child: Text(Locales.string(context, 'update_now')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
