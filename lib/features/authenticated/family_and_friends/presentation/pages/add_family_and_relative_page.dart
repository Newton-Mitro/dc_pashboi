import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/presentation/bloc/collection_ledger_bloc.dart';
import 'package:pashboi/features/authenticated/family_and_friends/presentation/pages/bloc/add_family_and_relative_bloc/add_family_and_relative_bloc.dart';
import 'package:pashboi/features/authenticated/family_and_friends/presentation/pages/bloc/relationship_bloc/relationship_bloc.dart';
import 'package:pashboi/shared/widgets/app_dropdown_select.dart';
import 'package:pashboi/shared/widgets/app_search_input.dart';
import 'package:pashboi/shared/widgets/app_text_input.dart';
import 'package:pashboi/shared/widgets/page_container.dart';
import 'package:pashboi/shared/widgets/progress_submit_button/progress_submit_button.dart';

class AddFamilyAndRelativesPage extends StatefulWidget {
  const AddFamilyAndRelativesPage({super.key});

  @override
  State<AddFamilyAndRelativesPage> createState() =>
      _AddFamilyAndRelativesPageState();
}

class _AddFamilyAndRelativesPageState extends State<AddFamilyAndRelativesPage> {
  final TextEditingController _accountHolderController =
      TextEditingController();
  final TextEditingController _accountSearchController =
      TextEditingController();

  late String selectedRelationship = '';
  late String gender = '';
  late int childPersonId = 0;

  @override
  void dispose() {
    _accountHolderController.dispose();
    _accountSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          Locales.string(context, 'add_family_and_relative_page_title'),
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AddFamilyAndRelativeBloc, AddFamilyAndRelativeState>(
            listener: (context, state) {
              if (state is AddFamilyAndRelativeFailure) {
                final snackBar = SnackBar(
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: 'Oops!',
                    message: state.error,
                    contentType: ContentType.failure,
                  ),
                );

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
              }
              if (state is AddFamilyAndRelativeSuccess) {
                final snackBar = SnackBar(
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: 'Oops!',
                    message: "Family or Relative added successfully",
                    contentType: ContentType.success,
                  ),
                );

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);

                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              }
            },
          ),
          BlocListener<CollectionLedgerBloc, CollectionLedgerState>(
            listener: (context, state) {
              if (state is CollectionLedgerLoaded) {
                final person = state.collectionAggregate.accountHolderInfo;
                _accountHolderController.text = person.name;
                gender = person.gender;
                childPersonId = person.id;

                if (gender.isNotEmpty) {
                  context.read<RelationshipBloc>().add(
                    FetchRelationshipsEvent(gender: gender),
                  );
                }
              } else if (state is CollectionLedgerError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          ),
          BlocListener<RelationshipBloc, RelationshipState>(
            listener: (context, state) {
              if (state is RelationshipError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          ),
        ],
        child: BlocBuilder<AddFamilyAndRelativeBloc, AddFamilyAndRelativeState>(
          builder: (context, addFamilyAndRelativeState) {
            return PageContainer(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.users,
                            size: 40,
                            color: theme.colorScheme.onSurface,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            Locales.string(
                              context,
                              'add_family_and_relative_page_title',
                            ),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 36),
                          BlocBuilder<
                            CollectionLedgerBloc,
                            CollectionLedgerState
                          >(
                            builder: (context, state) {
                              return AppSearchTextInput(
                                controller: _accountSearchController,
                                label: Locales.string(
                                  context,
                                  'add_family_and_relative_page_account_number_input_label',
                                ),
                                isSearch: true,
                                enabled: state is! CollectionLedgerLoading,
                                prefixIcon: Icon(
                                  FontAwesomeIcons.piggyBank,
                                  color: theme.colorScheme.onSurface,
                                ),
                                errorText:
                                    state is CollectionLedgerValidationError
                                        ? state.errors['searchText']
                                        : addFamilyAndRelativeState
                                            is AddFamilyAndRelativeValidationErrorState
                                        ? addFamilyAndRelativeState
                                            .errors['searchAccountNumber']
                                        : null,
                                onSearchPressed: () {
                                  context.read<CollectionLedgerBloc>().add(
                                    FetchCollectionLedgersEvent(
                                      searchText:
                                          _accountSearchController.text.trim(),
                                      moduleCode: '16',
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          AppTextInput(
                            controller: _accountHolderController,
                            label: Locales.string(
                              context,
                              'add_family_and_relative_page_member_name_input_label',
                            ),
                            enabled: false,
                            errorText:
                                addFamilyAndRelativeState
                                        is AddFamilyAndRelativeValidationErrorState
                                    ? addFamilyAndRelativeState
                                        .errors['memberName']
                                    : null,
                            prefixIcon: Icon(
                              Icons.person,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 16),
                          BlocBuilder<RelationshipBloc, RelationshipState>(
                            builder: (context, relationshipState) {
                              if (relationshipState is RelationshipLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (relationshipState
                                  is RelationshipLoaded) {
                                return AppDropdownSelect<String>(
                                  value: selectedRelationship,
                                  label: Locales.string(
                                    context,
                                    'add_family_and_relative_page_relationship_input_label',
                                  ),
                                  errorText:
                                      addFamilyAndRelativeState
                                              is AddFamilyAndRelativeValidationErrorState
                                          ? addFamilyAndRelativeState
                                              .errors['relationTypeCode']
                                          : null,
                                  items:
                                      relationshipState.relationships
                                          .map(
                                            (rel) => DropdownMenuItem(
                                              value: rel.code,
                                              child: Text(rel.name),
                                            ),
                                          )
                                          .toList(),

                                  onChanged: (value) {
                                    setState(() {
                                      selectedRelationship = value!;
                                    });
                                  },
                                  prefixIcon: FontAwesomeIcons.usersViewfinder,
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  ProgressSubmitButton(
                    width: MediaQuery.of(context).size.width - 10,
                    height: 100,
                    backgroundColor: theme.colorScheme.primary,
                    progressColor: theme.colorScheme.secondary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    label: Locales.string(context, 'press_and_hold_to_submit'),
                    onSubmit: () {
                      if (!mounted) return;

                      context.read<AddFamilyAndRelativeBloc>().add(
                        AddFamilyAndRelativeSubmitted(
                          childPersonId: childPersonId,
                          relationTypeCode: selectedRelationship,
                          searchAccountNumber: _accountSearchController.text,
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
