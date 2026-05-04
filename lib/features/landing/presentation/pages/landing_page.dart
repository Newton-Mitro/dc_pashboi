import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:pashboi/routes/public_routes_name.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/shared/widgets/page_container.dart';
import 'package:pashboi/shared/widgets/app_tooltip.dart';
import 'package:pashboi/shared/widgets/buttons/app_primary_button.dart';
import 'package:pashboi/shared/widgets/app_logo.dart';
import 'package:pashboi/shared/widgets/language_switch/language_switch.dart';
import 'package:pashboi/shared/widgets/theme_selector/theme_selector.dart';
import 'package:pashboi/features/terms_and_condition/presentation/pages/terms_and_conditions_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          const SizedBox(width: 20),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: context.theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: const Center(child: ThemeSelector()),
          ),
          Spacer(),
          LanguageSwitch(),
          const SizedBox(width: 20),
        ],
      ),
      body: PageContainer(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.10,
              vertical: MediaQuery.of(context).size.height * 0.05,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const AppLogo(width: 150),
                Spacer(),
                Column(
                  children: [
                    Text(
                      Locales.string(context, 'landing_page_welcome_text'),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: context.theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          Locales.string(
                            context,
                            'landing_page_already_have_account_text',
                          ),
                          style: TextStyle(
                            fontSize: 14,
                            color: context.theme.colorScheme.onSurface,
                          ),
                        ),
                        TooltipComponent(
                          tooltipMessage: Locales.string(
                            context,
                            'landing_page_login_instruction',
                          ),
                          child: Icon(
                            Icons.info_outline,
                            color: context.theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    AppPrimaryButton(
                      label: Locales.string(
                        context,
                        'landing_page_login_button',
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          PublicRoutesName.loginPage,
                        );
                      },
                      iconBefore: Icon(
                        Icons.login,
                        color: context.theme.colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          Locales.string(
                            context,
                            'landing_page_dont_have_account_text',
                          ),
                          style: TextStyle(
                            fontSize: 14,
                            color: context.theme.colorScheme.onSurface,
                          ),
                        ),
                        TooltipComponent(
                          tooltipMessage: Locales.string(
                            context,
                            'landing_page_create_account_instruction',
                          ),
                          child: Icon(
                            Icons.info_outline,
                            color: context.theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    AppPrimaryButton(
                      horizontalPadding: 5,
                      label: Locales.string(
                        context,
                        'landing_page_create_account_button',
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => const TermsAndConditionsPage(),
                          ),
                        );
                      },
                      iconBefore: Icon(
                        Icons.person_add,
                        color: context.theme.colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildInfoText(
                      context,
                      Locales.string(
                        context,
                        'landing_page_product_and_service_instruction',
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 36,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            PublicRoutesName.publicRoot,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 26.0),
                          child: Text(
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: context.theme.colorScheme.onSurface,
                              decoration: TextDecoration.underline,
                            ),
                            Locales.string(
                              context,
                              'landing_page_product_and_service_button',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoText(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        color: context.theme.colorScheme.onSurface,
      ),
      textAlign: TextAlign.center,
    );
  }
}
