import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:pashboi/routes/public_routes_name.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/shared/widgets/buttons/app_primary_button.dart';
import 'package:pashboi/shared/widgets/language_switch/language_switch.dart';
import 'package:pashboi/shared/widgets/theme_selector/theme_selector.dart';
import 'package:pashboi/features/onboarding/data/constants/onboarding_list_items.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:pashboi/features/onboarding/presentation/bloc/onboarding_page_bloc.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final onboardingItems = OnboardingListItems.getListItems(context);

    return BlocConsumer<OnboardingPageBloc, OnboardingPageState>(
      listener: (context, state) {
        if (state is OnboardingSeenSetSuccess) {
          Navigator.popAndPushNamed(context, PublicRoutesName.landingPage);
        } else if (state is OnboardingError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              PageView.builder(
                itemCount: onboardingItems.length,
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Image.asset(
                        onboardingItems[index].imagePath,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: const Color.fromARGB(169, 1, 0, 5),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 80,
                          horizontal: 20,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              onboardingItems[index].title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              onboardingItems[index].description,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),

              Positioned(
                top: 16,
                left: 16,
                child: const SafeArea(child: LanguageSwitch()),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: const SafeArea(child: ThemeSelector()),
              ),

              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (currentPage > 0)
                        AppPrimaryButton(
                          label: Locales.string(
                            context,
                            'previous_button_text',
                          ),
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          },
                          iconBefore: Icon(
                            Icons.arrow_back,
                            color: context.theme.colorScheme.onPrimary,
                          ),
                          horizontalPadding: 0,
                        )
                      else
                        const SizedBox(width: 88),

                      SmoothPageIndicator(
                        controller: _pageController,
                        count: onboardingItems.length,
                        effect: ExpandingDotsEffect(
                          dotColor: context.theme.colorScheme.primary,
                          activeDotColor: context.theme.colorScheme.error,
                          dotHeight: 10,
                          dotWidth: 10,
                          spacing: 5,
                        ),
                      ),

                      (currentPage == onboardingItems.length - 1)
                          ? AppPrimaryButton(
                            label: Locales.string(
                              context,
                              'onboarding_get_started_button',
                            ),
                            onPressed: () {
                              context.read<OnboardingPageBloc>().add(
                                SetOnboardingSeenEvent(seen: true),
                              );
                              Navigator.popAndPushNamed(
                                context,
                                PublicRoutesName.landingPage,
                              );
                            },
                            iconAfter: Icon(
                              Icons.rocket_launch,
                              color: context.theme.colorScheme.onPrimary,
                            ),
                            horizontalPadding: 0,
                          )
                          : AppPrimaryButton(
                            label: Locales.string(context, 'next_button_text'),
                            onPressed: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                              );
                            },
                            iconAfter: Icon(
                              Icons.arrow_forward,
                              color: context.theme.colorScheme.onPrimary,
                            ),
                            horizontalPadding: 0,
                          ),
                    ],
                  ),
                ),
              ),
              if (state is OnboardingLoading)
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        );
      },
    );
  }
}
