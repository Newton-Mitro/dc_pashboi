import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/features/public/contact_us/presentation/contact_us_page.dart';
import 'package:pashboi/features/public/deposit_policies/presentation/pages/deposit_policies_page.dart';
import 'package:pashboi/features/public/loan_policies/presentation/pages/loan_policies_page.dart';
import 'package:pashboi/features/public/notice/presentation/pages/notice_page.dart';
import 'package:pashboi/features/public/public_home/bloc/home_screen_bloc.dart';
import 'package:pashboi/features/public/public_home/widgets/public_home_drawer.dart';
import 'package:pashboi/features/public/service_centers/presentation/pages/service_center_page.dart';
import 'package:pashboi/routes/public_routes_name.dart';
import 'package:pashboi/shared/widgets/page_container.dart';
import 'package:pashboi/shared/widgets/theme_selector/theme_selector.dart';

class PublicHomeScreen extends StatefulWidget {
  const PublicHomeScreen({super.key});

  @override
  State<PublicHomeScreen> createState() => _PublicHomeScreenState();
}

class _PublicHomeScreenState extends State<PublicHomeScreen>
    with TickerProviderStateMixin {
  late final AnimationController _fabAnimationController;
  late final AnimationController _borderRadiusAnimationController;
  late final AnimationController _hideBottomBarAnimationController;

  late final Animation<double> fabAnimation;
  late final Animation<double> borderRadiusAnimation;

  late final CurvedAnimation fabCurve;
  late final CurvedAnimation borderRadiusCurve;

  final List<IconData> tabItems = [
    FontAwesomeIcons.piggyBank,
    FontAwesomeIcons.sackDollar,
    FontAwesomeIcons.bell,
    FontAwesomeIcons.mapLocation,
  ];

  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();

    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _borderRadiusAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _hideBottomBarAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    fabCurve = CurvedAnimation(
      parent: _fabAnimationController,
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );
    borderRadiusCurve = CurvedAnimation(
      parent: _borderRadiusAnimationController,
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );

    fabAnimation = Tween<double>(begin: 0, end: 1).animate(fabCurve);
    borderRadiusAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(borderRadiusCurve);

    Future.delayed(const Duration(milliseconds: 500), () {
      _fabAnimationController.forward();
      _borderRadiusAnimationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> titles = [
      Locales.string(context, 'public_bottom_nav_menu_savings'),
      Locales.string(context, 'public_bottom_nav_menu_loans'),
      Locales.string(context, 'public_bottom_nav_menu_notices'),
      Locales.string(context, 'public_bottom_nav_menu_service_centers'),
    ];

    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => HomeScreenBloc())],
      child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
        builder: (context, homeScreenState) {
          final isForward = homeScreenState.selectedIndex >= _previousIndex;
          _previousIndex = homeScreenState.selectedIndex;

          return Scaffold(
            appBar: AppBar(
              title: Text(titles[homeScreenState.selectedIndex]),
              actions: [
                ThemeSelector(),
                IconButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pushNamed(PublicRoutesName.landingPage);
                  },
                  icon: const Icon(FontAwesomeIcons.houseFlag, size: 18),
                ),
              ],
            ),
            body: SafeArea(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  final offsetTween = Tween<Offset>(
                    begin: isForward ? const Offset(1, 0) : const Offset(-1, 0),
                    end: Offset.zero,
                  );
                  return SlideTransition(
                    position: offsetTween.animate(animation),
                    child: child,
                  );
                },
                child: KeyedSubtree(
                  key: ValueKey<int>(homeScreenState.selectedIndex),
                  child: PageContainer(
                    child: _getScreen(homeScreenState.selectedIndex),
                  ),
                ),
              ),
            ),
            drawer: const PublicHomeDrawer(),
            floatingActionButton: ScaleTransition(
              scale: fabAnimation,
              child: FloatingActionButton(
                shape: const CircleBorder(),
                elevation: 6,
                backgroundColor: context.theme.colorScheme.primary,
                onPressed: () {
                  // Navigator.of(context).pushNamed(PublicRoutesName.homePage);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContactUsPage()),
                  );
                },
                child: Icon(
                  Icons.phone,
                  size: 28,
                  color: context.theme.colorScheme.onPrimary,
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: AnimatedBottomNavigationBar.builder(
              itemCount: tabItems.length,
              tabBuilder: (index, isActive) {
                final color =
                    isActive
                        ? context.theme.colorScheme.onPrimary
                        : context.theme.colorScheme.tertiary;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(tabItems[index], size: 24, color: color)],
                );
              },
              backgroundColor: context.theme.colorScheme.primary,
              activeIndex: homeScreenState.selectedIndex,
              gapLocation: GapLocation.center,
              notchSmoothness: NotchSmoothness.softEdge,
              leftCornerRadius: 32,
              rightCornerRadius: 32,
              onTap: (index) {
                context.read<HomeScreenBloc>().add(TabChanged(index));
              },
              hideAnimationController: _hideBottomBarAnimationController,
            ),
          );
        },
      ),
    );
  }

  Widget _getScreen(int index) {
    final List<Widget> screens = [
      const DepositPoliciesPage(),
      const LoanPoliciesPage(),
      const NoticesPage(),
      const ServiceCenterPage(),
    ];
    return screens[index];
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _borderRadiusAnimationController.dispose();
    _hideBottomBarAnimationController.dispose();
    super.dispose();
  }
}
