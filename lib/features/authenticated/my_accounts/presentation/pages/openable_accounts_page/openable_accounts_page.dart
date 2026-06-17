import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/features/authenticated/my_accounts/presentation/pages/openable_accounts_page/bloc/openable_account_bloc.dart';
import 'package:pashboi/routes/auth_routes_name.dart';
import 'package:pashboi/shared/widgets/buttons/app_primary_button.dart';

class OpenableAccountsPage extends StatefulWidget {
  const OpenableAccountsPage({super.key});

  @override
  State<OpenableAccountsPage> createState() => _OpenableAccountsPageState();
}

class _OpenableAccountsPageState extends State<OpenableAccountsPage> {
  @override
  void initState() {
    super.initState();
    context.read<OpenableAccountBloc>().add(FetchOpenableAccountsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Locales.string(context, "openable_accounts_page_title")),
      ),
      body: BlocBuilder<OpenableAccountBloc, OpenableAccountState>(
        builder: (context, state) {
          if (state is OpenableAccountLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OpenableAccountError) {
            return Center(
              child: Text(
                state.error,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          } else if (state is OpenableAccountSuccess) {
            if (state.openableAccounts.isEmpty) {
              return Center(
                child: Text(
                  Locales.string(context, 'no_accounts_available_to_open'),
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            return Accordion(
              headerBorderWidth: 3,
              headerBorderColor: context.theme.colorScheme.primary,
              headerBorderColorOpened: context.theme.colorScheme.primary,
              headerBackgroundColorOpened: context.theme.colorScheme.primary,
              contentBackgroundColor: context.theme.colorScheme.surface,
              contentBorderColor: context.theme.colorScheme.primary,
              contentBorderWidth: 3,
              contentHorizontalPadding: 20,
              scaleWhenAnimating: true,
              openAndCloseAnimation: true,
              headerPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
              sectionClosingHapticFeedback: SectionHapticFeedback.light,
              children:
                  state.openableAccounts.map((openableAccount) {
                    final headerColor = context.theme.colorScheme.primary;
                    final iconColor = context.theme.colorScheme.onPrimary;

                    return AccordionSection(
                      isOpen: false,
                      headerBackgroundColor: headerColor,
                      headerBackgroundColorOpened: headerColor,
                      headerBorderColor: headerColor,
                      contentBorderColor: headerColor,
                      contentVerticalPadding: 20,
                      paddingBetweenClosedSections: 20,
                      leftIcon: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          FontAwesomeIcons.check,
                          size: 30,
                          color: iconColor,
                        ),
                      ),
                      header: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            openableAccount.productName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: iconColor,
                            ),
                          ),
                          Text(
                            openableAccount.productTypeName,
                            style: TextStyle(fontSize: 14, color: iconColor),
                          ),
                        ],
                      ),
                      content: Column(
                        children: [
                          Html(data: openableAccount.description),
                          AppPrimaryButton(
                            label: Locales.string(
                              context,
                              "openable_accounts_page_open_an_account_title",
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AuthRoutesName.createNewAccountPage,
                                arguments: {
                                  'productCode': openableAccount.productCode,
                                  'productName': openableAccount.productName,
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
