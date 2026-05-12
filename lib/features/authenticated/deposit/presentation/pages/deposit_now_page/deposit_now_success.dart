import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:pashboi/core/theme/values/colors/dark_blue_ocean_colors.dart';
import 'package:pashboi/shared/widgets/buttons/app_primary_button.dart';
import 'package:pashboi/shared/widgets/page_container.dart';
import 'package:pashboi/core/extensions/app_context.dart';

class DepositNowSuccessPage extends StatelessWidget {
  final String successMessage;

  const DepositNowSuccessPage({super.key, required this.successMessage});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Deposit Now Success")),
      body: PageContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🎯 Circle success icon
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: DarkBlueOceanColors().success.withOpacity(0.1),
              ),
              padding: const EdgeInsets.all(24),
              child: Icon(
                Icons.check_circle_rounded,
                size: 80,
                color: DarkBlueOceanColors().success,
              ),
            ),

            const SizedBox(height: 24),

            // ✅ Main title
            Text(
              Locales.string(context, 'transaction_successful'),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: DarkBlueOceanColors().success,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // 📝 Subtitle / Custom message
            Text(
              successMessage,
              style: TextStyle(fontSize: 16, color: colorScheme.tertiary),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // 🚀 CTA Button
            AppPrimaryButton(
              label: Locales.string(context, 'back_to_home'),
              // label: Locales.string(context, 'login_page_login_button'),
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
    );
  }
}
