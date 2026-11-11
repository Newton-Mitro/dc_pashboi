import 'package:flutter/material.dart';
import 'package:pashboi/core/extensions/app_context.dart';

class MenuCard extends StatelessWidget {
  const MenuCard({
    super.key,
    required this.icon,
    required this.menuName,
    required this.menuDescription,
    this.onTap,
    this.isEnabled = true, // new property
  });

  final Widget icon;
  final String menuName;
  final String menuDescription;
  final VoidCallback? onTap;
  final bool isEnabled; // true by default

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final textColor =
        isEnabled
            ? theme.colorScheme.onSurface
            : theme.colorScheme.onSurface.withValues(alpha: 0.4);
    final iconWidget =
        isEnabled
            ? icon
            : Opacity(opacity: 0.4, child: icon); // greyed out icon

    return Card(
      elevation: 3,
      borderOnForeground: true,
      shadowColor: const Color.fromARGB(169, 0, 0, 0),
      color: theme.colorScheme.surface,
      child: InkWell(
        onTap: isEnabled ? onTap : null, // disable tap if not enabled
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.primary, width: 2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(color: theme.colorScheme.primary),
                    child: SizedBox.expand(child: Center(child: iconWidget)),
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          menuName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        Text(
                          menuDescription,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.normal,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
