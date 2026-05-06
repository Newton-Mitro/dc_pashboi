import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/core/extensions/string_casing_extension.dart';
import 'package:pashboi/features/authenticated/my_accounts/presentation/pages/dependents_page/bloc/fetch_dependents_bloc.dart';
import 'package:pashboi/routes/auth_routes_name.dart';
import 'package:pashboi/shared/widgets/page_container.dart';

class DependentsPage extends StatelessWidget {
  const DependentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    // Dispatch the fetch event when widget builds (Stateless trick)
    context.read<FetchDependentsBloc>().add(FetchDependentsEvent());

    return Scaffold(
      appBar: AppBar(
        title: Text(Locales.string(context, 'dependents_page_title')),
      ),
      body: PageContainer(
        child: SafeArea(
          child: BlocBuilder<FetchDependentsBloc, FetchDependentsState>(
            builder: (context, state) {
              if (state is FetchDependentsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is FetchDependentsError) {
                return Center(
                  child: Text(state.message, textAlign: TextAlign.center),
                );
              } else if (state is FetchDependentsLoaded) {
                final dependents = state.dependents;

                if (dependents.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          FontAwesomeIcons.boxOpen,
                          size: 60,
                          color: theme.colorScheme.onSurface.withOpacity(0.4),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          Locales.string(context, 'empty_dependents'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  itemCount: dependents.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final dependent = dependents[index];
                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AuthRoutesName.operatingAccountsPage,
                          arguments: {
                            'dependentPersonId': dependent.accountHolderId,
                          },
                        );
                      },
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          border: Border.all(
                            color: theme.colorScheme.primary,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4),
                                      bottomLeft: Radius.circular(4),
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      FontAwesomeIcons.children,
                                      size: 30,
                                      color: theme.colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 7,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 20,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        dependent.accountHolderName
                                            .trim()
                                            .toTitleCase(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Icon(
                                  Icons.navigate_next,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }

              return const SizedBox(); // fallback
            },
          ),
        ),
      ),
    );
  }
}
