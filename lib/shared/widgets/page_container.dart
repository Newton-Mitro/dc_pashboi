import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pashboi/core/constants/app_images.dart';
import 'package:pashboi/shared/widgets/theme_selector/bloc/theme_selector_bloc.dart';

class PageContainer extends StatelessWidget {
  final Widget child;

  const PageContainer({super.key, required this.child});

  String _getBackgroundImage(ThemeSelectorState state) {
    if (state is DarkAbyssTheme) {
      return AppImages.darkAbyssThemeBackground;
    } else if (state is OliverPetalTheme) {
      return AppImages.oliverPetalThemeBackground;
    } else if (state is OliverPetalDarkTheme) {
      return AppImages.oliverPetalDarkThemeBackground;
    } else if (state is EleganceTheme) {
      return AppImages.eleganceThemeBackground;
    } else if (state is EleganceDarkTheme) {
      return AppImages.eleganceDarkThemeBackground;
    } else if (state is BlueOceanTheme) {
      return AppImages.blueOceanThemeBackground;
    } else if (state is BlueOceanDarkTheme) {
      return AppImages.blueOceanDarkThemeBackground;
    } else {
      return AppImages.blueOceanThemeBackground;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeSelectorBloc, ThemeSelectorState>(
      builder: (context, state) {
        final backgroundImage = _getBackgroundImage(state);

        return Stack(
          children: [
            // Positioned.fill(
            //   child: Image.asset(backgroundImage, fit: BoxFit.cover),
            // ),
            child,
          ],
        );
      },
    );
  }
}
