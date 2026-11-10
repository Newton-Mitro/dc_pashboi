import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppNetworkImage extends StatelessWidget {
  final String? url;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final int? cacheWidth;
  final int? cacheHeight;

  const AppNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.cacheWidth,
    this.cacheHeight,
  });

  @override
  Widget build(BuildContext context) {
    final fallback =
        errorWidget ??
        Icon(
          Icons.broken_image_outlined,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );

    if (url == null || url!.isEmpty) {
      return Center(child: fallback);
    }

    return Image.network(
      url!,
      fit: fit,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      webHtmlElementStrategy:
          kIsWeb
              ? WebHtmlElementStrategy.fallback
              : WebHtmlElementStrategy.never,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Center(
          child: placeholder ?? const CircularProgressIndicator(strokeWidth: 2),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: error,
            stack: stackTrace,
            library: 'network image',
            context: ErrorDescription('while loading $url'),
          ),
        );
        return Center(child: fallback);
      },
    );
  }
}
