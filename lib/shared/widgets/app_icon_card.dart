import 'package:flutter/material.dart';
import 'package:pashboi/core/extensions/app_context.dart';

class AppIconCard extends StatelessWidget {
  const AppIconCard({
    super.key,
    required this.leftIcon,
    required this.cardBody,
    this.onTap,
    required this.boarderColor,
    this.rightIcon,
  });

  final IconData leftIcon;
  final Widget cardBody;
  final VoidCallback? onTap;
  final Color boarderColor;
  final IconData? rightIcon;

  @override
  Widget build(BuildContext context) {
    final leftSectionFlex = rightIcon != null ? 4 : 3;
    final bodyFlex = rightIcon != null ? 7 : 8;
    final rightSectionFlex = rightIcon != null ? 2 : 0;
    final leftSectionFraction =
        leftSectionFlex / (leftSectionFlex + bodyFlex + rightSectionFlex);

    return Card(
      color: context.theme.colorScheme.surface,
      elevation: 3,
      shadowColor: context.theme.colorScheme.shadow,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                context.theme.colorScheme.primary,
                context.theme.colorScheme.primary,
                context.theme.colorScheme.surface,
                context.theme.colorScheme.surface,
              ],
              stops: [0, leftSectionFraction, leftSectionFraction, 1],
            ),
            border: Border.all(color: boarderColor, width: 2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left Icon Area
              Expanded(
                flex: rightIcon != null ? 4 : 3,
                child: Center(
                  child: Icon(
                    leftIcon,
                    size: 30,
                    color: context.theme.colorScheme.onPrimary,
                  ),
                ),
              ),

              // Body
              Expanded(
                flex: rightIcon != null ? 7 : 8,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: cardBody,
                ),
              ),

              // Optional Right Icon
              if (rightIcon != null)
                Expanded(
                  flex: 2,
                  child: Icon(
                    rightIcon,
                    size: 15,
                    color: context.theme.colorScheme.onSurface,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
