import 'package:flutter/material.dart';
import 'package:pashboi/shared/widgets/buttons/app_primary_button.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
    required this.onPositiveButtonTap,
    required this.positiveButtonLabel,
    required this.negativeButtonLabel,
  });

  final String title;
  final String content;
  final Icon icon;
  final Function onPositiveButtonTap;
  final String positiveButtonLabel;
  final String negativeButtonLabel;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Expanded(flex: 12, child: icon)],
                  ),
                ],
              ),
              // Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Content
              Text(content, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              // Close button
              Row(
                children: [
                  Expanded(
                    child: AppPrimaryButton(
                      label: positiveButtonLabel,
                      horizontalPadding: 0,
                      onPressed: () {
                        onPositiveButtonTap();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppPrimaryButton(
                      label: negativeButtonLabel,
                      horizontalPadding: 0,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
