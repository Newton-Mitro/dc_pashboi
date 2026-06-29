import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/core/injection.dart';
import 'package:pashboi/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/bloc/authenticated_home_bloc.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/views/menus/accounts_menus_view.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/views/menus/beneficiary_menus_view.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/views/menus/dependents_menus_view.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/views/menus/deposit_menus_view.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/views/menus/family_menus_view.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/views/menus/info_menus_view.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/views/menus/loans_menus_view.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/views/menus/payment_menus_view.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/views/menus/personnel_menus_view.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/views/menus/surety_menus_view.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/views/menus/transfer_menus_view.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/views/menus/withdraw_menus_view.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/widgets/authenticated_bottom_sheet.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/widgets/base64_image_widget.dart';
import 'package:pashboi/features/authenticated/cards/presentation/pages/bloc/debit_card_bloc.dart';
import 'package:pashboi/routes/auth_routes_name.dart';
import 'package:pashboi/routes/public_routes_name.dart';
import 'package:pashboi/shared/widgets/page_container.dart';
import 'package:pashboi/shared/widgets/app_dialog.dart';
import 'package:pashboi/shared/widgets/language_switch/language_switch.dart';
import 'package:pashboi/shared/widgets/theme_selector/bloc/theme_selector_bloc.dart';
import 'package:pashboi/shared/widgets/theme_selector/theme_selector.dart';
import 'package:r_nav_n_sheet/r_nav_n_sheet.dart';

class AuthenticatedHome extends StatefulWidget {
  const AuthenticatedHome({super.key});

  @override
  State<AuthenticatedHome> createState() => _AuthenticatedHomeState();
}

class _AuthenticatedHomeState extends State<AuthenticatedHome> {
  int _previousPage = 0;

  @override
  void initState() {
    super.initState();
    context.read<DebitCardBloc>().add(DebitCardLoad());
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {
        "icon": FontAwesomeIcons.circleUser,
        "activeIcon": FontAwesomeIcons.userCheck,
        "label": Locales.string(context, 'auth_bottom_nav_menu_info'),
        "index": 0,
      },
      {
        "icon": FontAwesomeIcons.buildingColumns,
        "activeIcon": FontAwesomeIcons.buildingColumns,
        "label": Locales.string(context, 'auth_bottom_nav_menu_accounts'),
        "index": 1,
      },
      {
        "icon": FontAwesomeIcons.fileInvoiceDollar,
        "activeIcon": FontAwesomeIcons.fileCircleExclamation,
        "label": Locales.string(context, 'auth_bottom_nav_menu_loan'),
        "index": 2,
      },
      {
        "icon": FontAwesomeIcons.piggyBank,
        "activeIcon": FontAwesomeIcons.piggyBank,
        "label": Locales.string(context, 'auth_bottom_nav_menu_deposit'),
        "index": 3,
      },
      {
        "icon": FontAwesomeIcons.rightLeft,
        "activeIcon": FontAwesomeIcons.arrowsLeftRightToLine,
        "label": Locales.string(context, 'auth_bottom_nav_menu_transfer'),
        "index": 4,
      },
      {
        "icon": FontAwesomeIcons.moneyBill,
        "activeIcon": FontAwesomeIcons.moneyCheckDollar,
        "label": Locales.string(context, 'auth_bottom_nav_menu_withdraw'),
        "index": 5,
      },

      {
        "icon": FontAwesomeIcons.peopleRoof,
        "activeIcon": FontAwesomeIcons.houseChimneyUser,
        "label": Locales.string(context, 'auth_bottom_nav_menu_family'),
        "index": 6,
      },
      {
        "icon": FontAwesomeIcons.userGroup,
        "activeIcon": FontAwesomeIcons.userGroup,
        "label": Locales.string(context, 'auth_bottom_nav_menu_beneficiary'),
        "index": 7,
      },
      {
        "icon": FontAwesomeIcons.userShield,
        "activeIcon": FontAwesomeIcons.shieldHalved,
        "label": Locales.string(context, 'auth_bottom_nav_menu_surety'),
        "index": 8,
      },
      {
        "icon": FontAwesomeIcons.children,
        "activeIcon": FontAwesomeIcons.shieldHalved,
        "label": Locales.string(context, 'auth_bottom_nav_menu_dependent'),
        "index": 9,
      },
      {
        "icon": FontAwesomeIcons.helmetSafety,
        "activeIcon": FontAwesomeIcons.shieldHalved,
        "label": Locales.string(context, 'auth_bottom_nav_menu_personnel'),
        "index": 10,
      },
      // {
      //   "icon": FontAwesomeIcons.wallet,
      //   "activeIcon": FontAwesomeIcons.sackDollar,
      //   "label": Locales.string(context, 'auth_bottom_nav_menu_payment'),
      //   "index": 11,
      // },
    ];

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AuthenticatedHomeBloc>()),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, authState) {
          if (authState is UnAuthenticated) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              PublicRoutesName.landingPage,
              (_) => false,
            );
          }
        },
        child: BlocBuilder<AuthenticatedHomeBloc, AuthenticatedHomeState>(
          builder: (context, authHomeState) {
            int selectedPage =
                authHomeState is PageChangedState
                    ? authHomeState.selectedPage
                    : (authHomeState is AuthenticatedHomeInitial
                        ? authHomeState.selectedPage
                        : 0);

            final isForward = selectedPage >= _previousPage;
            _previousPage = selectedPage;

            return PopScope(
              canPop: false,
              onPopInvokedWithResult: (bool didPop, Object? result) async {
                if (!didPop) {
                  await showDialog(
                    context: context,
                    builder:
                        (_) => AppDialog(
                          title: Locales.string(context, 'logout_page_title'),
                          content: Locales.string(
                            context,
                            'logout_page_message',
                          ),
                          icon: const Icon(Icons.logout, size: 40),
                          onPositiveButtonTap: () {
                            Navigator.of(context).pop();
                            context.read<AuthBloc>().add(LogoutRequested());
                          },
                          negativeButtonLabel: Locales.string(
                            context,
                            'logout_page_no_button',
                          ),
                          positiveButtonLabel: Locales.string(
                            context,
                            'logout_page_yes_button',
                          ),
                        ),
                  );
                }
              },
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, authState) {
                  if (authState is! Authenticated) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final user = authState.authUser.user;

                  /// Build menu views only after user is available
                  final List<Widget> menuViews = [
                    InfoMenusView(authUser: user),
                    AccountsMenusView(authUser: user),
                    LoansMenusView(authUser: user),
                    DepositMenusView(authUser: user),
                    TransferMenusView(authUser: user),
                    WithdrawMenusView(authUser: user),
                    // PaymentMenusView(authUser: user),
                    FamilyMenusView(authUser: user),
                    BeneficiaryMenusView(authUser: user),
                    SuretyMenusView(authUser: user),
                    DependentsMenusView(authUser: user),
                    PersonnelMenusView(authUser: user),
                  ];

                  return Scaffold(
                    appBar: AppBar(
                      title: Text(menuItems[selectedPage]['label']),
                      automaticallyImplyLeading: false,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      elevation: 4,
                      actions: [
                        const ThemeSelector(),
                        const LanguageSwitch(),
                        const SizedBox(width: 10),
                        BlocBuilder<ThemeSelectorBloc, ThemeSelectorState>(
                          builder: (context, state) {
                            return PopupMenuButton<int>(
                              offset: const Offset(0, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              onSelected: (value) async {
                                if (value == 0) {
                                  Navigator.pushNamed(
                                    context,
                                    AuthRoutesName.profilePage,
                                  );
                                } else if (value == 1) {
                                  Navigator.pushNamed(
                                    context,
                                    AuthRoutesName.changePasswordPage,
                                  );
                                } else if (value == 2) {
                                  await showDialog(
                                    context: context,
                                    builder:
                                        (_) => AppDialog(
                                          title: Locales.string(
                                            context,
                                            'logout_page_title',
                                          ),
                                          content: Locales.string(
                                            context,
                                            'logout_page_message',
                                          ),
                                          icon: const Icon(
                                            Icons.logout,
                                            size: 40,
                                          ),
                                          onPositiveButtonTap:
                                              () => context
                                                  .read<AuthBloc>()
                                                  .add(LogoutRequested()),
                                          positiveButtonLabel: Locales.string(
                                            context,
                                            'logout_page_yes_button',
                                          ),
                                          negativeButtonLabel: Locales.string(
                                            context,
                                            'logout_page_no_button',
                                          ),
                                        ),
                                  );
                                }
                              },
                              itemBuilder:
                                  (context) => [
                                    PopupMenuItem(
                                      value: 0,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.person,
                                            size: 20,
                                            color:
                                                context
                                                    .theme
                                                    .colorScheme
                                                    .onSurface,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            Locales.string(
                                              context,
                                              'tool_profile_menu',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 1,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.lock_open_rounded,
                                            size: 20,
                                            color:
                                                context
                                                    .theme
                                                    .colorScheme
                                                    .onSurface,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            Locales.string(
                                              context,
                                              'tool_change_password_menu',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      enabled: false,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Divider(
                                        color: Colors.grey,
                                        thickness: 1.2,
                                        height: 8,
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 2,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.logout,
                                            size: 20,
                                            color:
                                                context
                                                    .theme
                                                    .colorScheme
                                                    .onSurface,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            Locales.string(
                                              context,
                                              'tool_logout_menu',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                          context.theme.colorScheme.onPrimary,
                                      width: 2,
                                    ),
                                    image: DecorationImage(
                                      image:
                                          user.userPicture != null
                                              ? Base64ImageWidget(
                                                base64String: user.userPicture!,
                                              ).imageProvider
                                              : const NetworkImage(
                                                'https://img.freepik.com/free-vector/illustration-businessman_53876-5856.jpg',
                                              ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    body: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        final offsetTween = Tween<Offset>(
                          begin:
                              isForward
                                  ? const Offset(1, 0)
                                  : const Offset(-1, 0),
                          end: Offset.zero,
                        );
                        return SlideTransition(
                          position: offsetTween.animate(animation),
                          child: child,
                        );
                      },
                      child: KeyedSubtree(
                        key: ValueKey<int>(selectedPage),
                        child: PageContainer(child: menuViews[selectedPage]),
                      ),
                    ),
                    bottomNavigationBar: RNavNSheet(
                      onTap: (index) {
                        context.read<AuthenticatedHomeBloc>().add(
                          ChangePageEvent(index),
                        );
                      },
                      initialSelectedIndex: 0,
                      backgroundColor: context.theme.colorScheme.primary,
                      borderColors: [
                        context.theme.colorScheme.primary,
                        context.theme.colorScheme.secondary,
                        context.theme.colorScheme.primary,
                      ],
                      sheetOpenIcon: FontAwesomeIcons.listUl,
                      sheetCloseIcon: FontAwesomeIcons.cross,
                      sheetOpenIconColor: context.theme.colorScheme.primary,
                      sheetOpenIconBoxColor:
                          context.theme.colorScheme.onPrimary,
                      unselectedItemColor: context.theme.colorScheme.onPrimary
                          .withAlpha(120),
                      selectedItemColor: context.theme.colorScheme.onPrimary,
                      sheet: AuthenticatedBottomSheet(menuItems: menuItems),
                      items: List.generate(
                        4,
                        (i) => RNavItem(
                          icon: menuItems[i]['icon'],
                          label: menuItems[i]['label'],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
