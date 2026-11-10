import 'package:flutter/material.dart';

class ResponsiveKeyValueRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget? leading;
  final Widget? valueSuffix;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final EdgeInsetsGeometry padding;

  const ResponsiveKeyValueRow({
    super.key,
    required this.label,
    required this.value,
    this.leading,
    this.valueSuffix,
    this.labelStyle,
    this.valueStyle,
    this.padding = const EdgeInsets.symmetric(vertical: 6),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 380;
        final labelWidget = Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 8)],
            Expanded(child: Text(label, style: labelStyle)),
          ],
        );
        final valueWidget = Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                value,
                style: valueStyle,
                textAlign: compact ? TextAlign.start : TextAlign.end,
              ),
            ),
            if (valueSuffix != null) ...[
              const SizedBox(width: 4),
              valueSuffix!,
            ],
          ],
        );

        return Padding(
          padding: padding,
          child:
              compact
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      labelWidget,
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: valueWidget,
                      ),
                    ],
                  )
                  : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: labelWidget),
                      const SizedBox(width: 12),
                      Flexible(child: valueWidget),
                    ],
                  ),
        );
      },
    );
  }
}
