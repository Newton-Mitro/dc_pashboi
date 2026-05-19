import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pashboi/core/constants/app_images.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/shared/widgets/theme_selector/bloc/theme_selector_bloc.dart';

class AppLogo extends StatefulWidget {
  final double width;
  final bool showOrganizationName;
  const AppLogo({super.key, this.showOrganizationName = true, this.width = 25});

  @override
  State<AppLogo> createState() => AppLogoState();
}

class AppLogoState extends State<AppLogo> with SingleTickerProviderStateMixin {
  String version = '';

  @override
  void initState() {
    super.initState();
    loadVersion();
  }

  Future<void> loadVersion() async {
    final info = await PackageInfo.fromPlatform();

    setState(() {
      version = '${info.version}+${info.buildNumber}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeSelectorBloc, ThemeSelectorState>(
      builder: (context, state) {
        return Column(
          children: [
            Image.asset(
              state is DarkAbyssTheme ||
                      state is BlueOceanDarkTheme ||
                      state is OliverPetalDarkTheme ||
                      state is EleganceDarkTheme
                  ? AppImages.pathLogoDark
                  : AppImages.pathLogo,
              width: widget.width,
            ),
            widget.showOrganizationName
                ? Column(
                  children: [
                    Text(
                      Locales.string(context, 'organization_name'),
                      style: TextStyle(
                        fontSize: 16,
                        color: context.theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      Locales.string(context, 'orgainzation_short_name'),
                      style: TextStyle(
                        fontSize: 14,
                        color: context.theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${Locales.string(context, 'version')}: $version',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                )
                : const SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
