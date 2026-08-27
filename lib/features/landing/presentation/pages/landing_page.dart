import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:pashboi/core/extensions/string_casing_extension.dart';
import 'package:pashboi/features/landing/presentation/bloc/advertisement_bloc.dart';
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
  final PageController _pageController = PageController();
  int currentIndex = 0;

  bool _popupShown = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdvertisementBloc>().add(FetchAdvertisementEvent());
    });
  }

  void _showAdsPopup(List ads) {
    if (_popupShown || ads.isEmpty) return;
    _popupShown = true;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final size = MediaQuery.of(context).size;

            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(12),
              child: SizedBox(
                width: size.width * 0.90,
                height: size.height * 0.90,
                child: Container(
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          /// IMAGE SLIDER
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(24),
                              ),
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: ads.length,
                                onPageChanged: (index) {
                                  setModalState(() {
                                    currentIndex = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  final ad = ads[index];

                                  return Image.network(
                                    ad.attachmentUrl,
                                    fit: BoxFit.contain,
                                    width: double.infinity,
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) return child;
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                    errorBuilder:
                                        (_, __, ___) => const Icon(
                                          Icons.broken_image_outlined,
                                          size: 60,
                                        ),
                                  );
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          /// TITLE
                          Text(
                            (ads[currentIndex].title ?? '')
                                .toString()
                                .toTitleCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: context.theme.colorScheme.onSurface,
                            ),
                          ),

                          const SizedBox(height: 12),

                          /// DOT INDICATOR
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              ads.length,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                width: currentIndex == index ? 18 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color:
                                      currentIndex == index
                                          ? context.theme.colorScheme.primary
                                          : Colors.grey.shade400,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            "Swipe to explore ads",
                            style: TextStyle(
                              fontSize: 12,
                              color: context.theme.colorScheme.onSurface
                                  .withOpacity(0.6),
                            ),
                          ),

                          const SizedBox(height: 16),
                        ],
                      ),

                      /// CLOSE BUTTON
                      Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, color: Colors.white),
                          ),
                        ),
                      ),

                      /// LEFT ARROW
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              if (currentIndex > 0) {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            icon: const Icon(Icons.arrow_back_ios),
                          ),
                        ),
                      ),

                      /// RIGHT ARROW
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              if (currentIndex < ads.length - 1) {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            icon: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdvertisementBloc, AdvertisementState>(
      listener: (context, state) {
        if (state is AdvertisementLoaded) {
          Future.delayed(const Duration(milliseconds: 300), () {
            _showAdsPopup(state.advertisements);
          });
        }
      },
      child: Scaffold(
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
        body: SafeArea(
          child: PageContainer(
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
                      const SizedBox(height: 8),
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 26.0,
                            ),
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
