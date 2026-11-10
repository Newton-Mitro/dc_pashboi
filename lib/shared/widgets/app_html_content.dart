import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class AppHtmlContent extends StatelessWidget {
  const AppHtmlContent({super.key, required this.data});

  final String data;

  static final _embeddedImagePattern = RegExp(
    r'''<img\b[^>]*\bsrc\s*=\s*["']data:image/[^;]+;base64,([^"']+)["'][^>]*>''',
    caseSensitive: false,
  );

  @override
  Widget build(BuildContext context) {
    final matches = _embeddedImagePattern.allMatches(data).toList();
    if (matches.isEmpty) return Html(data: data);

    final content = <Widget>[];
    var cursor = 0;
    for (final match in matches) {
      final precedingHtml = data.substring(cursor, match.start);
      if (precedingHtml.trim().isNotEmpty) {
        content.add(Html(data: precedingHtml));
      }

      content.add(
        Image.memory(
          base64Decode(match.group(1)!),
          fit: BoxFit.contain,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            FlutterError.reportError(
              FlutterErrorDetails(
                exception: error,
                stack: stackTrace,
                library: 'app html content',
                context: ErrorDescription(
                  'while loading an embedded HTML image',
                ),
              ),
            );
            return const SizedBox.shrink();
          },
        ),
      );
      cursor = match.end;
    }

    final remainingHtml = data.substring(cursor);
    if (remainingHtml.trim().isNotEmpty) {
      content.add(Html(data: remainingHtml));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: content,
    );
  }
}
