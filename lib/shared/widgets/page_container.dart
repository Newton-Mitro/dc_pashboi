import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pashboi/core/constants/app_images.dart';
import 'package:pashboi/shared/widgets/responsive_content.dart';
import 'package:pashboi/shared/widgets/theme_selector/bloc/theme_selector_bloc.dart';

class PageContainer extends StatelessWidget {
  final Widget child;

  const PageContainer({super.key, required this.child});

  String _backgroundFor(ThemeSelectorState state) {
    return switch (state) {
      DarkAbyssTheme() => AppImages.darkAbyssThemeBackground,
      BlueOceanDarkTheme() => AppImages.blueOceanDarkThemeBackground,
      BlueOceanTheme() => AppImages.blueOceanThemeBackground,
      EleganceDarkTheme() => AppImages.eleganceDarkThemeBackground,
      EleganceTheme() => AppImages.eleganceThemeBackground,
      OliverPetalDarkTheme() => AppImages.oliverPetalDarkThemeBackground,
      OliverPetalTheme() => AppImages.oliverPetalThemeBackground,
      _ => AppImages.blueOceanThemeBackground,
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeSelectorBloc, ThemeSelectorState>(
      builder: (context, state) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.2,
                child: Image.asset(
                  _backgroundFor(state),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    FlutterError.reportError(
                      FlutterErrorDetails(
                        exception: error,
                        stack: stackTrace,
                        library: 'page container',
                        context: ErrorDescription(
                          'while loading the theme background image',
                        ),
                      ),
                    );
                    return ColoredBox(
                      color: state.themeData.colorScheme.surface,
                    );
                  },
                ),
              ),
            ),
            ResponsiveContent(child: child),
          ],
        );
      },
    );
  }
}
