import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/core/extensions/string_casing_extension.dart';
import 'package:pashboi/core/utils/my_date_utils.dart';
import 'package:pashboi/features/authenticated/personnel/employee_profile/presentation/pages/employee_profile_page/bloc/employees_profile_bloc.dart';
import 'package:pashboi/shared/widgets/page_container.dart';

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

  Uint8List? getImageBytes(String? photo) {
    if (photo == null) return null;

    photo = photo.trim();

    if (photo.isEmpty ||
        photo.toLowerCase() == 'n/a' ||
        photo.toLowerCase() == 'null') {
      return null;
    }

    try {
      // Handle data:image/jpeg;base64,...
      if (photo.contains(',')) {
        photo = photo.split(',').last;
      }

      return base64Decode(photo);
    } catch (e) {
      debugPrint('Invalid Base64 Image: $e');
      return null;
    }
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

  Widget buildProfileImage(String? photo) {
    final imageBytes = getImageBytes(photo);

    if (imageBytes == null) {
      return Container(
        color: Colors.grey.shade200,
        child: const Center(
          child: Icon(Icons.person, size: 80, color: Colors.grey),
        ),
      );
    }

    return Image.memory(
      imageBytes,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Center(
          child: Icon(Icons.person, size: 80, color: Colors.grey),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Locales.string(context, 'employee_profile_title')),
      ),
      body: SafeArea(
        child: BlocBuilder<EmployeesProfileBloc, EmployeesProfileState>(
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: context.theme.colorScheme.secondary,
                                width: 5,
                              ),
                            ),
                            child: ClipOval(
                              child: buildProfileImage(person.personPhoto),
                            ),
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
                          style: const TextStyle(fontSize: 18),
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
                        ),

                        const SizedBox(height: 30),

                        Column(
                          children: [
                            buildInfoRow(
                              FontAwesomeIcons.userTie,
                              Locales.string(
                                context,
                                'employee_profile_supervisor_name',
                              ),
                              person.supervisorName.trim().toTitleCase(),
                            ),

                            const SizedBox(height: 10),

                            buildInfoRow(
                              FontAwesomeIcons.idCard,
                              Locales.string(
                                context,
                                'employee_profile_employee_code',
                              ),
                              person.employeeCode,
                            ),

                            const SizedBox(height: 10),

                            buildInfoRow(
                              FontAwesomeIcons.person,
                              Locales.string(
                                context,
                                'employee_profile_gender',
                              ),
                              person.gender,
                            ),

                            const SizedBox(height: 10),

                            buildInfoRow(
                              FontAwesomeIcons.at,
                              Locales.string(
                                context,
                                'employee_profile_official_email',
                              ),
                              person.employeeEmail,
                            ),

                            const SizedBox(height: 10),

                            buildInfoRow(
                              FontAwesomeIcons.at,
                              Locales.string(
                                context,
                                'employee_profile_personal_email',
                              ),
                              person.email,
                            ),

                            const SizedBox(height: 10),

                            buildInfoRow(
                              FontAwesomeIcons.calendar,
                              Locales.string(
                                context,
                                'employee_profile_joining_date',
                              ),
                              MyDateUtils.formatDate(
                                DateTime.tryParse(person.joiningDate),
                              ),
                            ),

                            const SizedBox(height: 10),

                            buildInfoRow(
                              FontAwesomeIcons.droplet,
                              Locales.string(
                                context,
                                'employee_profile_blood_group',
                              ),
                              person.bloodGroup,
                            ),

                            const SizedBox(height: 10),

                            buildInfoRow(
                              FontAwesomeIcons.idCard,
                              Locales.string(context, 'employee_profile_nid'),
                              person.nid,
                            ),

                            const SizedBox(height: 10),

                            buildInfoRow(
                              FontAwesomeIcons.phoneVolume,
                              Locales.string(
                                context,
                                'employee_profile_mobile_number',
                              ),
                              person.mobileNumber,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
