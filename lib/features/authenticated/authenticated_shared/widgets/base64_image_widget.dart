import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Base64ImageWidget extends StatefulWidget {
  final String base64String;
  final BoxFit fit;
  final Widget? placeholder;
  final int cacheSize;

  const Base64ImageWidget({
    super.key,
    required this.base64String,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.cacheSize = 256,
  });

  @override
  State<Base64ImageWidget> createState() => _Base64ImageWidgetState();
}

class _Base64ImageWidgetState extends State<Base64ImageWidget> {
  late Future<Uint8List?> _imageBytes;

  @override
  void initState() {
    super.initState();
    _imageBytes = _decode(widget.base64String);
  }

  @override
  void didUpdateWidget(covariant Base64ImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.base64String != widget.base64String) {
      _imageBytes = _decode(widget.base64String);
    }
  }

  Future<Uint8List?> _decode(String encodedImage) {
    return compute<String, Uint8List?>(_decodeBase64Image, encodedImage);
  }

  @override
  Widget build(BuildContext context) {
    final size =
        (widget.cacheSize * MediaQuery.devicePixelRatioOf(context)).round();
    final fallback = widget.placeholder ?? const Icon(Icons.person);

    return FutureBuilder<Uint8List?>(
      future: _imageBytes,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          );
        }
        if (snapshot.hasError || snapshot.data == null) {
          return Center(child: fallback);
        }
        return Image.memory(
          snapshot.data!,
          fit: widget.fit,
          cacheWidth: size,
          cacheHeight: size,
          errorBuilder: (context, error, stackTrace) => Center(child: fallback),
        );
      },
    );
  }
}

Uint8List? _decodeBase64Image(String encodedImage) {
  var normalized = encodedImage.trim();
  if (normalized.isEmpty ||
      normalized.toLowerCase() == 'null' ||
      normalized.toLowerCase() == 'n/a') {
    return null;
  }
  if (normalized.toLowerCase().startsWith('data:')) {
    final separator = normalized.indexOf(',');
    if (separator < 0) return null;
    normalized = normalized.substring(separator + 1);
  }
  return base64Decode(normalized);
}
