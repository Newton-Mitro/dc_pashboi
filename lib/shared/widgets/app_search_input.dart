import 'package:flutter/material.dart';
import 'package:pashboi/core/extensions/app_context.dart';

class AppSearchTextInput extends StatefulWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final String label;
  final String? errorText;
  final Icon? prefixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool isSearch;
  final VoidCallback? onSearchPressed;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  const AppSearchTextInput({
    super.key,
    this.controller,
    this.initialValue,
    required this.label,
    this.errorText,
    this.prefixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.isSearch = false,
    this.onSearchPressed,
    this.onChanged,
    this.enabled = true,
  });

  @override
  State<AppSearchTextInput> createState() => _AppSearchTextInputState();
}

class _AppSearchTextInputState extends State<AppSearchTextInput> {
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
  void didUpdateWidget(covariant AppSearchTextInput oldWidget) {
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

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: colorScheme.primary, width: 1),
    );

    final textColor =
        widget.enabled ? colorScheme.onSurface : theme.disabledColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 50,
          child: TextField(
            controller: effectiveController,
            obscureText: isObscured,
            keyboardType: widget.keyboardType,
            enabled: widget.enabled,
            style: TextStyle(color: textColor),
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              labelText: widget.label,
              labelStyle: TextStyle(color: textColor),
              prefixIcon: widget.prefixIcon,
              filled: true,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 10,
              ),
              focusedBorder: border.copyWith(
                borderSide: BorderSide(color: colorScheme.secondary, width: 2),
              ),
              enabledBorder: border,
              disabledBorder: border.copyWith(
                borderSide: BorderSide(color: theme.disabledColor),
              ),
              errorBorder: border.copyWith(
                borderSide: BorderSide(color: colorScheme.error),
              ),
              suffixIcon: _buildSuffixIcon(),
            ),
          ),
        ),
        const SizedBox(height: 2),
        if (widget.errorText?.isNotEmpty ?? false)
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

  Widget? _buildSuffixIcon() {
    if (widget.obscureText) {
      return _buildIconButton(
        icon: isObscured ? Icons.visibility_off : Icons.visibility,
        onPressed:
            widget.enabled
                ? () => setState(() => isObscured = !isObscured)
                : null,
      );
    } else if (widget.isSearch) {
      return _buildIconButton(
        icon: Icons.search,
        onPressed:
            widget.enabled
                ? (widget.onSearchPressed ??
                    () => debugPrint("Searching: ${effectiveController.text}"))
                : null,
      );
    }
    return null;
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    final theme = context.theme;
    final disabled = onPressed == null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
      decoration: BoxDecoration(
        color:
            disabled
                ? theme.disabledColor.withValues(alpha: 0.2)
                : theme.colorScheme.primary,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: disabled ? theme.disabledColor : theme.colorScheme.onPrimary,
        ),
        onPressed: onPressed,
        splashRadius: 20,
      ),
    );
  }
}
