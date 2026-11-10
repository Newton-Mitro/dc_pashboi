import 'package:flutter/material.dart';
import 'package:pashboi/core/extensions/app_context.dart';

class PrefixedMobileNumberInput extends StatefulWidget {
  final String prefix;
  final String label;
  final String? errorText;
  final Icon? prefixIcon;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final String? initialValue;
  final bool readOnly;

  const PrefixedMobileNumberInput({
    super.key,
    required this.prefix,
    required this.label,
    this.errorText,
    this.prefixIcon,
    this.onChanged,
    this.controller,
    this.initialValue,
    this.readOnly = false,
  });

  @override
  State<PrefixedMobileNumberInput> createState() =>
      _PrefixedMobileNumberInputState();
}

class _PrefixedMobileNumberInputState extends State<PrefixedMobileNumberInput> {
  late final TextEditingController _controller;
  String _lastValue = '';

  @override
  void initState() {
    super.initState();
    final initialText =
        widget.initialValue != null
            ? (widget.initialValue!.startsWith(widget.prefix)
                ? widget.initialValue!
                : widget.prefix + widget.initialValue!)
            : widget.prefix;

    _controller = widget.controller ?? TextEditingController(text: initialText);
    _lastValue = _controller.text;

    _controller.addListener(_handleTextChanged);
  }

  void _handleTextChanged() {
    if (widget.readOnly) return;

    String text = _controller.text;

    if (!text.startsWith(widget.prefix)) {
      text = widget.prefix;
      _controller.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    } else {
      final suffix = text.substring(widget.prefix.length);
      final filteredSuffix = suffix.replaceAll(RegExp(r'[^\d]'), '');
      final newText = widget.prefix + filteredSuffix;

      if (newText != _lastValue) {
        _lastValue = newText;
        _controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length),
        );

        widget.onChanged?.call(filteredSuffix);
      }
    }

    // Ensure cursor doesn't go before prefix
    if (_controller.selection.start < widget.prefix.length) {
      _controller.selection = TextSelection.collapsed(
        offset: widget.prefix.length,
      );
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 50,
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.phone,
            readOnly: widget.readOnly,
            decoration: InputDecoration(
              labelText: widget.label,
              labelStyle: TextStyle(color: context.theme.colorScheme.onSurface),
              prefixIcon: widget.prefixIcon,
              filled: true,
              hintStyle: TextStyle(color: context.theme.colorScheme.onSurface),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: context.theme.colorScheme.secondary,
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: context.theme.colorScheme.secondary,
                  width: 1.0,
                ),
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 10,
              ),
            ),
            style: TextStyle(color: context.theme.colorScheme.onSurface),
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 1.0, left: 8),
            child: Text(
              widget.errorText!,
              style: TextStyle(
                color: context.theme.colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
