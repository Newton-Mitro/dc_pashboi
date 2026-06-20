import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/core/extensions/string_casing_extension.dart';
import 'package:pashboi/features/authenticated/family_and_friends/presentation/pages/bloc/family_and_relatives_bloc/family_and_relatives_bloc.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/entities/nominee_entity.dart';
import 'package:pashboi/shared/widgets/app_dropdown_select.dart';
import 'package:pashboi/shared/widgets/buttons/app_primary_button.dart';

class AccountNomineeSection extends StatefulWidget {
  const AccountNomineeSection({
    super.key,
    required this.onAddNominee,
    required this.onRemoveNominee,
    required this.nominees,
    this.sectionError,
  });

  final void Function(NomineeEntity nominee) onAddNominee;
  final void Function(NomineeEntity nominee) onRemoveNominee;
  final List<NomineeEntity> nominees;
  final String? sectionError;

  @override
  State<AccountNomineeSection> createState() => _AccountNomineeSectionState();
}

class _AccountNomineeSectionState extends State<AccountNomineeSection> {
  String? nomineeName;
  int? personId;
  double sharePercentage = 0;
  List<dynamic> _familyFriends = [];

  double get remainingPercentage {
    final totalUsed = widget.nominees.fold<double>(
      0,
      (sum, n) => sum + (n.percentage),
    );
    return 100 - totalUsed;
  }

  // void onNomineeChanged(String? name) {
  //   setState(() => nomineeName = name);
  // }

  void onNomineeChanged(String? name) {
    final matches =
        _familyFriends.where((e) => e.familyMemberName == name).toList();

    if (matches.isEmpty) return;

    final selected = matches.first;

    setState(() {
      nomineeName = selected.familyMemberName;
      personId = selected.userPersonId;
    });
  }

  void onSharePercentageChanged(double? value) {
    setState(() => sharePercentage = value!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildNomineeSelectionCard(context),
        const SizedBox(height: 25),
        _buildAppointedNomineesCard(context),
      ],
    );
  }

  Widget _buildNomineeSelectionCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        border: Border.all(color: context.theme.colorScheme.primary),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(
            context,
            Locales.string(context, 'select_account_nominee'),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                BlocBuilder<FamilyAndRelativesBloc, FamilyAndRelativesState>(
                  builder: (context, state) {
                    final List<String> names;

                    if (state is FamilyAndRelativesLoading) {
                      return const CircularProgressIndicator();
                    }
                    if (state is FamilyAndRelativesFailure) {
                      return Text(
                        Locales.string(
                          context,
                          'failed_to_load_family_or_relative',
                        ),
                        style: TextStyle(
                          color: context.theme.colorScheme.error,
                        ),
                      );
                    }

                    if (state is FamilyAndRelativesLoaded) {
                      _familyFriends = state.familyAndFriends;

                      names =
                          state.familyAndFriends
                              .map((e) => e.familyMemberName)
                              .toList();
                    } else {
                      names = [];
                    }

                    // if (state is FamilyAndRelativesLoaded) {
                    //   _familyFriends = state.familyAndFriends;

                    //   names =
                    //       state.familyAndFriends
                    //           .map((e) => e.familyMemberName)
                    //           .toList();
                    // } else {
                    //   names = [];
                    // }

                    return AppDropdownSelect<String>(
                      label: Locales.string(context, 'nominee'),
                      prefixIcon: FontAwesomeIcons.user,
                      value: nomineeName,
                      enabled: names.isNotEmpty,
                      onChanged: onNomineeChanged,
                      items:
                          names
                              .map(
                                (name) => DropdownMenuItem(
                                  value: name,
                                  child: Text(name),
                                ),
                              )
                              .toList(),
                    );
                  },
                ),
                const SizedBox(height: 12),
                AppDropdownSelect<double>(
                  label: Locales.string(context, 'share_percentage'),
                  prefixIcon: FontAwesomeIcons.percent,
                  value: sharePercentage,
                  onChanged: onSharePercentageChanged,
                  items: List.generate(10, (i) {
                    final percent = (i + 1) * 10;
                    return DropdownMenuItem(
                      value: percent.toDouble(),
                      child: Text("$percent %"),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                AppPrimaryButton(
                  iconBefore: const Icon(FontAwesomeIcons.userPlus),
                  label: Locales.string(context, 'add_nominee'),
                  enabled:
                      nomineeName != null &&
                      sharePercentage != 0 &&
                      sharePercentage <= remainingPercentage,
                  onPressed: () {
                    final nominee = NomineeEntity(
                      id: Random().nextInt(999999999),
                      name: nomineeName!.trim().toTitleCase(),
                      personId: personId,
                      relation: "Brother",
                      phone: '',
                      nationalId: '',
                      percentage: sharePercentage,
                    );
                    widget.onAddNominee(nominee);
                    setState(() {
                      nomineeName = null;
                      sharePercentage = 0;
                    });
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  "${Locales.string(context, 'remaining')}: ${remainingPercentage.toStringAsFixed(1)}%",
                  style: TextStyle(
                    color:
                        widget.sectionError != null
                            ? context.theme.colorScheme.error
                            : context.theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointedNomineesCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        border: Border.all(
          color:
              widget.sectionError != null
                  ? context.theme.colorScheme.error
                  : context.theme.colorScheme.primary,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, Locales.string(context, 'appointed_nominees')),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 120,
              child:
                  widget.nominees.isEmpty
                      ? Center(
                        child: Text(
                          Locales.string(context, 'no_nominees_added_yet'),
                          style: TextStyle(
                            color: context.theme.colorScheme.onSurface
                                .withOpacity(0.6),
                          ),
                        ),
                      )
                      : Scrollbar(
                        thumbVisibility: true,
                        child: ListView.builder(
                          itemCount: widget.nominees.length,
                          itemBuilder: (context, index) {
                            final nominee = widget.nominees[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 10,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color:
                                              context.theme.colorScheme.primary,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  FontAwesomeIcons.user,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Text(
                                                    nominee.name,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                    overflow:
                                                        TextOverflow.visible,
                                                    softWrap: true,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                nominee.percentage
                                                    .toStringAsFixed(1),
                                              ),
                                              const SizedBox(width: 4),
                                              const Icon(
                                                FontAwesomeIcons.percent,
                                                size: 12,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      icon: const Icon(FontAwesomeIcons.trash),
                                      onPressed:
                                          () => widget.onRemoveNominee(nominee),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: context.theme.colorScheme.onPrimary,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
