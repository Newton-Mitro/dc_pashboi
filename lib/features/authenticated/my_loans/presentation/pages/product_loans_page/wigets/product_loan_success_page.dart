import 'package:flutter/material.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/shared/widgets/buttons/app_primary_button.dart';
import 'package:pashboi/shared/widgets/page_container.dart';

class ProductLoanSuccessPage extends StatelessWidget {
  final String successMessage;
  const ProductLoanSuccessPage({super.key, required this.successMessage});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text("Product Loan Success")),
      body: PageContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primary.withOpacity(0.1),
              ),
              padding: const EdgeInsets.all(24),
              child: Icon(
                Icons.check_circle_rounded,
                size: 80,
                color: colorScheme.primary,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              "Your Product Loan Has Been Successfully Applied!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            Text(
              successMessage,
              style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            AppPrimaryButton(
              label: "Back To Home",
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
