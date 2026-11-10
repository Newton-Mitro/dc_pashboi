import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pashboi/core/extensions/app_context.dart';

class AppTextInput extends StatefulWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final String label;
  final String? errorText;
  final Icon? prefixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final void Function(String)? onChanged;

  const AppTextInput({
    super.key,
    this.controller,
    this.initialValue,
    required this.label,
    this.errorText,
    this.prefixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.enabled = true,
    this.onChanged,
  });

  @override
  State<AppTextInput> createState() => _AppTextInputState();
}

class _AppTextInputState extends State<AppTextInput> {
  late bool isObscured;
  late final TextEditingController _internalController;

  TextEditingController get effectiveController =>
      widget.controller ?? _internalController;

  @override
  void initState() {
    super.initState();
    isObscured = widget.obscureText;
    _internalController = widget.controller ?? TextEditingController();

    if (widget.controller == null && widget.initialValue != null) {
      _internalController.text = widget.initialValue!;
    }
  }

  @override
  void didUpdateWidget(covariant AppTextInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null &&
        widget.initialValue != null &&
        widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _internalController.text) {
      _internalController.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 50,
          child: TextField(
            controller: effectiveController,
            obscureText: isObscured,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.inputFormatters,
            enabled: widget.enabled,
            onChanged: widget.onChanged,
            style: TextStyle(
              color:
                  widget.enabled ? colorScheme.onSurface : theme.disabledColor,
            ),
            decoration: InputDecoration(
              labelText: widget.label,
              labelStyle: TextStyle(
                color:
                    widget.enabled
                        ? colorScheme.onSurface
                        : theme.disabledColor,
              ),
              prefixIcon: widget.prefixIcon,
              filled: true,
              hintStyle: TextStyle(color: colorScheme.onSurface),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 10,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colorScheme.secondary, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colorScheme.primary, width: 1),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: colorScheme.primary.withOpacity(0.3),
                  width: 1,
                ),
              ),
              suffixIcon:
                  widget.obscureText
                      ? IconButton(
                        icon: Icon(
                          isObscured ? Icons.visibility_off : Icons.visibility,
                          color: colorScheme.onSurface,
                        ),
                        onPressed:
                            widget.enabled
                                ? () {
                                  setState(() {
                                    isObscured = !isObscured;
                                  });
                                }
                                : null,
                      )
                      : null,
            ),
          ),
        ),
        const SizedBox(height: 2),
        if (widget.errorText != null && widget.errorText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              widget.errorText!,
              style: TextStyle(color: colorScheme.error, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
