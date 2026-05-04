import 'package:flutter/material.dart';

class AppSuccessButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Widget? iconBefore;
  final Widget? iconAfter;
  final double horizontalPadding;
  final bool enabled;

  const AppSuccessButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.iconBefore,
    this.iconAfter,
    this.horizontalPadding = 30.0,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 36,
          child: ElevatedButton(
            onPressed: enabled ? onPressed : null,
            style: ButtonStyle(
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(color: theme.colorScheme.secondary),
                ),
              ),
              backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.disabled)) {
                  return theme.disabledColor.withOpacity(0.12);
                }
                return Colors.green;
              }),
              foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.disabled)) {
                  return theme.disabledColor.withOpacity(0.38);
                }
                return Colors.white;
              }),
              textStyle: WidgetStateProperty.all<TextStyle>(
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(horizontal: 16),
              ),
              overlayColor: WidgetStateProperty.resolveWith<Color?>(
                (states) =>
                    states.contains(WidgetState.pressed)
                        ? theme.colorScheme.primary.withOpacity(0.1)
                        : null,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (iconBefore != null) ...[
                    iconBefore!,
                    const SizedBox(width: 8),
                  ],
                  Text(label),
                  if (iconAfter != null) ...[
                    const SizedBox(width: 8),
                    iconAfter!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
