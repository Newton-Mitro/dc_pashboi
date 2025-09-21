import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/core/extensions/string_casing_extension.dart';
import 'package:pashboi/core/utils/my_date_utils.dart';
import 'package:pashboi/features/authenticated/personnel/employee_profile/presentation/pages/employee_profile_page/bloc/employees_profile_bloc.dart';
import 'package:pashboi/shared/widgets/page_container.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EmployeesProfilePage extends StatefulWidget {
  const EmployeesProfilePage({super.key});

  @override
  State<EmployeesProfilePage> createState() => _EmployeesProfilePageState();
}

class _EmployeesProfilePageState extends State<EmployeesProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<EmployeesProfileBloc>().add(FetchEmployeeDetailsEvent());
  }

  Widget buildInfoRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.theme.colorScheme.primary.withOpacity(0.8),
          ),
          child: Icon(
            icon,
            size: 18,
            color: context.theme.colorScheme.onPrimary,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 14)),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Locales.string(context, 'employee_profile_details')),
      ),
      body: BlocBuilder<EmployeesProfileBloc, EmployeesProfileState>(
        builder: (context, state) {
          if (state is EmployeesProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is EmployeesProfileError) {
            return Center(child: Text(state.message));
          }

          if (state is EmployeesProfileLoaded) {
            final person = state.employeeDetails;

            return PageContainer(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 25,
                ),
                height: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: context.theme.colorScheme.surface,
                                border: Border.all(
                                  color: context.theme.colorScheme.secondary,
                                  width: 5,
                                ),
                              ),
                              child: ClipOval(
                                child: Image.memory(
                                  person.personPhoto.isNotEmpty
                                      ? base64Decode(person.personPhoto)
                                      : Uint8List(0),
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          const Icon(Icons.error),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        person.fullName.trim().toTitleCase(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),
                      Text(
                        person.designationName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        person.departmentName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: context.theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 5),

                      Chip(
                        label: Text(
                          person.employeeCategoryName,
                          style: TextStyle(
                            fontSize: 12,
                            color: context.theme.colorScheme.onPrimary,
                          ),
                        ),
                        backgroundColor: context.theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: context.theme.colorScheme.primary,
                          width: 1,
                        ),
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      const SizedBox(height: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          buildInfoRow(
                            FontAwesomeIcons.userTie,
                            Locales.string(context, 'supervisor_name'),
                            person.supervisorName.trim().toTitleCase(),
                          ),
                          const SizedBox(height: 10),
                          buildInfoRow(
                            FontAwesomeIcons.idCard,
                            Locales.string(context, 'employee_code'),
                            person.employeeCode,
                          ),

                          const SizedBox(height: 10),

                          buildInfoRow(
                            FontAwesomeIcons.person,
                            Locales.string(context, 'gender'),
                            person.gender,
                          ),

                          const SizedBox(height: 10),

                          buildInfoRow(
                            FontAwesomeIcons.at,
                            Locales.string(context, 'official_email'),
                            person.employeeEmail,
                          ),
                          const SizedBox(height: 10),
                          buildInfoRow(
                            FontAwesomeIcons.at,
                            Locales.string(context, 'personal_email'),
                            person.email,
                          ),
                          const SizedBox(height: 10),

                          buildInfoRow(
                            FontAwesomeIcons.calendar,
                            Locales.string(context, 'joining_date'),
                            MyDateUtils.formatDate(
                              DateTime.tryParse(person.joiningDate),
                            ),
                          ),

                          const SizedBox(height: 10),

                          buildInfoRow(
                            FontAwesomeIcons.droplet,
                            Locales.string(context, 'profile_pae_blood_group'),
                            person.bloodGroup,
                          ),
                          const SizedBox(height: 10),
                          buildInfoRow(
                            FontAwesomeIcons.idCard,
                            Locales.string(context, 'profile_pae_nid'),
                            person.nid,
                          ),
                          const SizedBox(height: 10),
                          buildInfoRow(
                            FontAwesomeIcons.phoneVolume,
                            Locales.string(
                              context,
                              'profile_pae_mobile_number',
                            ),
                            person.mobileNumber,
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return const SizedBox(); // Fallback for initial or unknown state
        },
      ),
    );
  }
}
