import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/core/extensions/string_casing_extension.dart';
import 'package:pashboi/core/utils/my_date_utils.dart';
import 'package:pashboi/features/authenticated/profile/presentation/profile_page/bloc/profile_bloc.dart';
import 'package:pashboi/shared/widgets/page_container.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(FetchProfileEvent());
  }

  void _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final bytes = await picked.readAsBytes();
      context.read<ProfileBloc>().add(
        UpdateProfileImageEvent(imageData: base64Encode(bytes)),
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Locales.string(context, 'profile_pae_title'))),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(child: Text(state.error!));
          }

          final person = state.personEntity;

          if (person == null) {
            return Center(
              child: Text(Locales.string(context, 'no_profile_data_available')),
            );
          }

          return PageContainer(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
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
                                person.photo.isNotEmpty
                                    ? base64Decode(person.photo)
                                    : Uint8List(0),
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                        const Icon(Icons.error),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 5,
                            child: GestureDetector(
                              onTap: () => _pickImage(context),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: context.theme.colorScheme.primary,
                                  border: Border.all(
                                    color: context.theme.colorScheme.secondary,
                                    width: 3,
                                  ),
                                ),
                                child: Icon(
                                  FontAwesomeIcons.camera,
                                  size: 18,
                                  color: context.theme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      person.name.toTitleCase(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      person.email,
                      style: TextStyle(
                        fontSize: 14,
                        color: context.theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildInfoRow(
                          FontAwesomeIcons.baby,
                          Locales.string(context, 'profile_pae_date_of_birth'),
                          MyDateUtils.formatDate(person.dateOfBirth),
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
                          Locales.string(context, 'profile_pae_mobile_number'),
                          person.mobileNumber,
                        ),
                        const SizedBox(height: 10),
                        buildInfoRow(
                          FontAwesomeIcons.locationPin,
                          Locales.string(
                            context,
                            'profile_pae_present_address',
                          ),
                          person.presentAddress.toTitleCase(),
                        ),
                        const SizedBox(height: 10),
                        buildInfoRow(
                          FontAwesomeIcons.locationPinLock,
                          Locales.string(
                            context,
                            'profile_pae_permanent_address',
                          ),
                          person.permanentAddress.toTitleCase(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
