import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:pashboi/features/auth/domain/entities/user_entity.dart';
import 'package:pashboi/routes/auth_routes_name.dart';
import 'package:pashboi/shared/menu_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PersonnelMenusView extends StatefulWidget {
  final UserEntity authUser;

  const PersonnelMenusView({super.key, required this.authUser});

  @override
  State<PersonnelMenusView> createState() => _PersonnelMenusViewState();
}

class _PersonnelMenusViewState extends State<PersonnelMenusView> {
  List<Map<String, dynamic>> getInfoMenus(BuildContext context) {
    final color = Theme.of(context).colorScheme.onPrimary;

    return [
      {
        "icon": Icon(FontAwesomeIcons.helmetSafety, color: color, size: 30),
        "menuName": Locales.string(
          context,
          "personnel_menu_employee_profile_title",
        ),
        "route": AuthRoutesName.employeeProfile,
        "controllerName": "My Info",
        "menuDescription": Locales.string(
          context,
          "personnel_menu_employee_profile_description",
        ),
      },
      {
        "icon": Icon(FontAwesomeIcons.calendarDays, color: color, size: 30),
        "menuName": Locales.string(
          context,
          "personnel_menu_leave_application_title",
        ),
        "route": AuthRoutesName.leaveInformation,
        "controllerName": "Leave Application",
        "menuDescription": Locales.string(
          context,
          "personnel_menu_leave_application_description",
        ),
      },
      {
        "icon": Icon(FontAwesomeIcons.circleCheck, color: color, size: 30),
        "menuName": Locales.string(
          context,
          "personnel_menu_fallback_acceptance_title",
        ),
        "route": AuthRoutesName.fallbackAcceptancePage,
        "controllerName": "Fallback Acceptance",
        "menuDescription": Locales.string(
          context,
          "personnel_menu_fallback_acceptance_description",
        ),
      },
      {
        "icon": Icon(FontAwesomeIcons.thumbsUp, color: color, size: 30),
        "menuName": Locales.string(
          context,
          "personnel_menu_leave_approval_title",
        ),

        "route": AuthRoutesName.leaveApprovalPage,
        "controllerName": "Leave Approval",
        "menuDescription": Locales.string(
          context,
          "personnel_menu_leave_approval_description",
        ),
      },
      {
        "icon": Icon(FontAwesomeIcons.clockRotateLeft, color: color, size: 30),
        "menuName": Locales.string(
          context,
          "personnel_menu_leave_history_title",
        ),
        "route": AuthRoutesName.leaveHistoryPage,
        "controllerName": "Leave History",
        "menuDescription": Locales.string(
          context,
          "personnel_menu_leave_history_description",
        ),
      },
      {
        "icon": Icon(FontAwesomeIcons.clock, color: color, size: 30),
        "menuName": Locales.string(context, "personnel_menu_attendance_title"),
        "route": AuthRoutesName.attendancesPage,
        "controllerName": "Attendances",
        "menuDescription": Locales.string(
          context,
          "personnel_menu_attendance_description",
        ),
      },
      {
        "icon": Icon(FontAwesomeIcons.houseLaptop, color: color, size: 30),
        "menuName": Locales.string(
          context,
          "personnel_menu_working_out_of_office_application_title",
        ),
        "route": AuthRoutesName.workingOutOfOfficeApplication,

        "controllerName": "Working Out of Office Application",
        "menuDescription": Locales.string(
          context,
          "personnel_menu_working_out_of_office_application_description",
        ),
      },
      {
        "icon": Icon(FontAwesomeIcons.squareCheck, color: color, size: 30),
        "menuName": Locales.string(
          context,
          "personnel_menu_working_out_of_office_approval_title",
        ),
        "route": AuthRoutesName.workingOutOfOfficeApproval,

        "controllerName": "Working Out of Office Approval",
        "menuDescription": Locales.string(
          context,
          "personnel_menu_working_out_of_office_approval_description",
        ),
      },
      {
        "icon": Icon(Icons.file_copy, color: color, size: 30),
        "menuName": Locales.string(
          context,
          "personnel_menu_working_out_of_office_history_title",
        ),
        "route": AuthRoutesName.workingOutOfOfficeHistory,

        "controllerName": "Working Out of Office History",
        "menuDescription": Locales.string(
          context,
          "personnel_menu_working_out_of_office_history_description",
        ),
      },
      {
        "icon": Icon(Icons.fingerprint, color: color, size: 30),
        "menuName": Locales.string(
          context,
          "personnel_menu_todays_punch_title",
        ),
        "route": AuthRoutesName.todaysPunch,

        "controllerName": "Todays Punch",
        "menuDescription": Locales.string(
          context,
          "personnel_menu_todays_punch_description",
        ),
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
