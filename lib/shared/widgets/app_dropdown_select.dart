import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/shared/widgets/language_switch/bloc/language_switch_bloc.dart';

class AppDropdownSelect<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?) onChanged;
  final String label;
  final String? errorText;
  final IconData? prefixIcon;
  final bool enabled;

  const AppDropdownSelect({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.label,
    this.errorText,
    this.prefixIcon,
    this.enabled = true,
  });

  void _showBottomSheet(BuildContext context) {
    if (!enabled) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (_) {
        final sheetHeight = MediaQuery.of(context).size.height * 0.5;
        return SizedBox(
          height: sheetHeight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              BlocBuilder<LanguageSwitchBloc, LanguageSwitchState>(
                builder: (context, state) {
                  if (state.language == 'bn') {
                    return Text(
                      "$label ${Locales.string(context, 'select')}",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: context.theme.colorScheme.onSurface,
                      ),
                    );
                  } else {
                    return Text(
                      "${Locales.string(context, 'select')} $label",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: context.theme.colorScheme.onSurface,
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 3),
              // 👇 The top horizontal line
              Container(
                width: 40,
                height: 3,
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.onSurface,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 5),
              // 👇 The actual dropdown list
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 20,
                  ),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Container(
                      padding: const EdgeInsets.only(left: 16),
                      decoration:
                          value == item.value
                              ? BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: context.theme.colorScheme.primary,
                                border: Border(
                                  left: BorderSide(
                                    color: context.theme.colorScheme.onSurface,
                                    width: 3,
                                  ),
                                  right: BorderSide(
                                    color: context.theme.colorScheme.onSurface,
                                    width: 3,
                                  ),
                                ),
                              )
                              : BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border(
                                  bottom: BorderSide(
                                    color: context.theme.colorScheme.onSurface
                                        .withAlpha(360),
                                    width: 1,
                                  ),
                                ),
                              ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          radioTheme: RadioThemeData(
                            fillColor: WidgetStateProperty.resolveWith<Color>((
                              states,
                            ) {
                              if (states.contains(WidgetState.selected)) {
                                return context.theme.colorScheme.onPrimary;
                              }
                              return context.theme.colorScheme.onSurface;
                            }),
                          ),
                        ),
                        child: RadioListTile(
                          value: item.value,
                          groupValue: value,
                          onChanged: (selectedValue) {
                            Navigator.of(context).pop();
                            onChanged(selectedValue);
                          },
                          title: DefaultTextStyle(
                            style: TextStyle(
                              color:
                                  value == item.value
                                      ? context.theme.colorScheme.onPrimary
                                      : context.theme.colorScheme.onSurface,
                            ),
                            child: item.child,
                          ),
                          selected: value == item.value,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: context.theme.colorScheme.primary,
        width: 1.0,
      ),
    );

    final selectedItem = items.firstWhere(
      (element) => element.value == value,
      orElse:
          () => DropdownMenuItem<T>(
            value: null,
            child: BlocBuilder<LanguageSwitchBloc, LanguageSwitchState>(
              builder: (context, state) {
                if (state.language == 'bn') {
                  return Text("$label ${Locales.string(context, 'select')}");
                } else {
                  return Text("${Locales.string(context, 'select')} $label");
                }
              },
            ),
          ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _showBottomSheet(context),
          child: AbsorbPointer(
            absorbing: !enabled,
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(
                  color:
                      enabled
                          ? context.theme.colorScheme.onSurface
                          : context.theme.disabledColor,
                ),
                filled: true,
                isDense: true,
                prefixIcon:
                    prefixIcon != null
                        ? Icon(
                          prefixIcon,
                          color:
                              enabled
                                  ? context.theme.colorScheme.onSurface
                                  : context.theme.disabledColor,
                        )
                        : null,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12,
                ),
                focusedBorder: border.copyWith(
                  borderSide: BorderSide(
                    color: context.theme.colorScheme.secondary,
                    width: 2,
                  ),
                ),
                enabledBorder: border,
                disabledBorder: border.copyWith(
                  borderSide: BorderSide(
                    color: context.theme.colorScheme.primary.withOpacity(0.3),
                  ),
                ),
                errorBorder: border.copyWith(
                  borderSide: const BorderSide(color: Colors.red),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: selectedItem.child),
                  Icon(
                    Icons.arrow_drop_down,
                    color:
                        enabled
                            ? context.theme.colorScheme.onSurface
                            : context.theme.disabledColor,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (errorText != null && errorText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 1.0, left: 8),
            child: Text(
              errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
