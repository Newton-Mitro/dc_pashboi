import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickedImagePreview extends StatefulWidget {
  final XFile file;
  final BoxFit fit;

  const PickedImagePreview({
    super.key,
    required this.file,
    this.fit = BoxFit.contain,
  });

  @override
  State<PickedImagePreview> createState() => _PickedImagePreviewState();
}

class _PickedImagePreviewState extends State<PickedImagePreview> {
  late Future<Uint8List> _imageBytes;

  @override
  void initState() {
    super.initState();
    _imageBytes = widget.file.readAsBytes();
  }

  @override
  void didUpdateWidget(covariant PickedImagePreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.file != widget.file) {
      _imageBytes = widget.file.readAsBytes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: _imageBytes,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          FlutterError.reportError(
            FlutterErrorDetails(
              exception: snapshot.error!,
              stack: snapshot.stackTrace,
              library: 'picked image preview',
              context: ErrorDescription('while loading the selected image'),
            ),
          );
          return const Center(child: Icon(Icons.broken_image_outlined));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return Image.memory(snapshot.data!, fit: widget.fit);
      },
    );
  }
}
