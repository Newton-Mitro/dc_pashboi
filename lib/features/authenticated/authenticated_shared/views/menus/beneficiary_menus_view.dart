import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:pashboi/features/auth/domain/entities/user_entity.dart';
import 'package:pashboi/routes/auth_routes_name.dart';
import 'package:pashboi/shared/menu_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BeneficiaryMenusView extends StatefulWidget {
  final UserEntity authUser;

  const BeneficiaryMenusView({super.key, required this.authUser});

  @override
  State<BeneficiaryMenusView> createState() => _BeneficiaryMenusViewState();
}

class _BeneficiaryMenusViewState extends State<BeneficiaryMenusView> {
  List<Map<String, dynamic>> getInfoMenus(BuildContext context) {
    final color = Theme.of(context).colorScheme.onPrimary;

    return [
      {
        "icon": Icon(FontAwesomeIcons.users, color: color, size: 30),
        "menuName": Locales.string(
          context,
          "beneficiary_menu_beneficiaries_title",
        ),
        "controllerName": "Beneficiaries",
        "menuDescription": Locales.string(
          context,
          "beneficiary_menu_beneficiaries_description",
        ),
        "route": AuthRoutesName.beneficiariesPage,
      },
      {
        "icon": Icon(FontAwesomeIcons.userPlus, color: color, size: 30),
        "menuName": Locales.string(
          context,
          "beneficiary_menu_add_beneficiaries_title",
        ),
        "controllerName": "Add Beneficiary",
        "menuDescription": Locales.string(
          context,
          "beneficiary_menu_add_beneficiaries_description",
        ),
        "route": AuthRoutesName.addBeneficiaryPage,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final infoMenus = getInfoMenus(context);
    final rolePermissions = widget.authUser.rolePermissions;

    // Extract allowed controller names
    final allowedControllers =
        rolePermissions
            .map((p) => p.controllerName)
            .whereType<String>()
            .toSet();

    return SafeArea(
      child: ListView.separated(
        itemCount: infoMenus.length,
        padding: const EdgeInsets.all(12),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final menu = infoMenus[index];
          final controllerName = menu['controllerName'] as String?;
          final isEnabled =
              controllerName != null &&
              allowedControllers.contains(controllerName);

          return MenuCard(
            icon: menu['icon'],
            menuName: menu['menuName'],
            menuDescription: menu['menuDescription'],
            onTap:
                isEnabled
                    ? () => Navigator.pushNamed(context, menu['route'])
                    : null,
            isEnabled: isEnabled,
          );
        },
      ),
    );
  }
}
