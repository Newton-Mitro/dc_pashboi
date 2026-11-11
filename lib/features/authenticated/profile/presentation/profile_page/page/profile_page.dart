import 'dart:convert';

import 'package:flutter/foundation.dart';
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

  Future<void> _pickImage() async {
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked == null) return;

      final bytes = await picked.readAsBytes();
      if (!mounted) return;
      context.read<ProfileBloc>().add(
        UpdateProfileImageEvent(imageData: base64Encode(bytes)),
      );
    } on Exception catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'profile image picker',
        ),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(Locales.string(context, 'an_error_occurred'))),
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
            color: context.theme.colorScheme.primary.withValues(alpha: 0.8),
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
      body: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewPadding.bottom,
        ),
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state.error != null && state.personEntity != null) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(state.error!)));
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.error != null && state.personEntity == null) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.error!),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed:
                          () => context.read<ProfileBloc>().add(
                            const FetchProfileEvent(),
                          ),
                      child: Text(
                        Locales.string(
                          context,
                          'terms_and_conditions_page_retry_button',
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            final person = state.personEntity;

            if (person == null) {
              return Center(
                child: Text(
                  Locales.string(context, 'no_profile_data_available'),
                ),
              );
            }

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
                                child: _ProfilePhoto(photo: person.photo),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              right: 5,
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: context.theme.colorScheme.primary,
                                    border: Border.all(
                                      color:
                                          context.theme.colorScheme.secondary,
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
                            Locales.string(
                              context,
                              'profile_pae_date_of_birth',
                            ),
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
                            Locales.string(
                              context,
                              'profile_pae_mobile_number',
                            ),
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
      ),
    );
  }
}

class _ProfilePhoto extends StatefulWidget {
  final String photo;

  const _ProfilePhoto({required this.photo});

  @override
  State<_ProfilePhoto> createState() => _ProfilePhotoState();
}

class _ProfilePhotoState extends State<_ProfilePhoto> {
  late Future<Uint8List> _imageBytes;

  @override
  void initState() {
    super.initState();
    _imageBytes = _decodePhoto(widget.photo);
  }

  @override
  void didUpdateWidget(covariant _ProfilePhoto oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.photo != widget.photo) {
      _imageBytes = _decodePhoto(widget.photo);
    }
  }

  Future<Uint8List> _decodePhoto(String photo) {
    if (photo.isEmpty) {
      return Future.value(Uint8List(0));
    }
    return compute(base64Decode, photo).catchError((
      Object error,
      StackTrace stackTrace,
    ) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'profile photo decoding',
        ),
      );
      Error.throwWithStackTrace(error, stackTrace);
    });
  }

  @override
  Widget build(BuildContext context) {
    final targetSize = (150 * MediaQuery.devicePixelRatioOf(context)).round();

    return FutureBuilder<Uint8List>(
      future: _imageBytes,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Icon(Icons.account_circle);
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.expand();
        }
        return Image.memory(
          snapshot.data!,
          fit: BoxFit.cover,
          cacheWidth: targetSize,
          cacheHeight: targetSize,
          errorBuilder: (context, error, stackTrace) {
            FlutterError.reportError(
              FlutterErrorDetails(
                exception: error,
                stack: stackTrace,
                library: 'profile photo rendering',
              ),
            );
            return const Icon(Icons.account_circle);
          },
        );
      },
    );
  }
}
