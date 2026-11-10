import 'package:flutter/material.dart';

class ResponsiveContent extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveContent({
    super.key,
    required this.child,
    this.maxWidth = 1200,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth =
            constraints.hasBoundedWidth ? constraints.maxWidth : maxWidth;
        final contentWidth = availableWidth.clamp(0.0, maxWidth);

        return Align(
          alignment: Alignment.topCenter,
          child: SizedBox(width: contentWidth, child: child),
        );
      },
    );
  }
}
