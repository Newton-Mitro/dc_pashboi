import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/bloc/authenticated_home_bloc.dart';

class AuthenticatedBottomSheet extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems;

  const AuthenticatedBottomSheet({super.key, required this.menuItems});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return BlocBuilder<AuthenticatedHomeBloc, AuthenticatedHomeState>(
      builder: (context, state) {
        final int currentIndex =
            state is PageChangedState ? state.selectedPage : -1;

        final Color activeIconColor = context.theme.colorScheme.onPrimary;
        final Color activeBgColor = context.theme.colorScheme.primary;
        final Color inactiveIconColor = context.theme.colorScheme.onSurface
            .withAlpha(180);
        final Color inactiveBgColor = context.theme.colorScheme.surface;

        return Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.4,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: context.theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(
              color: context.theme.colorScheme.primary,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                Locales.string(
                  context,
                  'auth_bottom_nav_menu_title',
                ).toUpperCase(),
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 2),
              // Top handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              SizedBox(height: 20),

              // Divider(
              //   height: 24,
              //   thickness: 1,
              //   color: context.theme.colorScheme.secondary.withAlpha(360),
              // ),

              // Scrollable icon grid
              Expanded(
                child: Scrollbar(
                  controller: scrollController,
                  thumbVisibility: true,
                  thickness: 1,
                  radius: const Radius.circular(8),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Wrap(
                      spacing: 10, // Slightly tighter horizontal spacing
                      runSpacing: 10,
                      children:
                          menuItems.skip(4).map((item) {
                            final int index = item['index'] as int;
                            final bool isActive = index == currentIndex;

                            return InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                Navigator.pop(context);
                                context.read<AuthenticatedHomeBloc>().add(
                                  ChangePageEvent(index),
                                );
                              },
                              child: Container(
                                width: 76,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 2,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isActive
                                          ? activeBgColor
                                          : inactiveBgColor,
                                  borderRadius: BorderRadius.circular(25),
                                  border:
                                      isActive
                                          ? Border.all(
                                            color:
                                                context
                                                    .theme
                                                    .colorScheme
                                                    .primary,
                                            width: 2,
                                          )
                                          : null,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 8,
                                  children: [
                                    Icon(
                                      item['icon'] as IconData,
                                      color:
                                          isActive
                                              ? activeIconColor
                                              : inactiveIconColor,
                                      size: 24,
                                    ),

                                    Text(
                                      item['label'] as String,
                                      textAlign: TextAlign.center,
                                      style: context.theme.textTheme.bodySmall
                                          ?.copyWith(
                                            fontSize: 12,
                                            color:
                                                isActive
                                                    ? context
                                                        .theme
                                                        .colorScheme
                                                        .onPrimary
                                                    : context
                                                        .theme
                                                        .colorScheme
                                                        .onSurface,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
