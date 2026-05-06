import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/core/extensions/string_casing_extension.dart';
import 'package:pashboi/features/authenticated/beneficiaries/presentation/pages/beneficiaries_bloc/beneficiaries_bloc.dart';
import 'package:pashboi/shared/widgets/page_container.dart';
import 'package:pashboi/shared/widgets/app_icon_card.dart';

class BeneficiariesPage extends StatefulWidget {
  const BeneficiariesPage({super.key});

  @override
  State<BeneficiariesPage> createState() => _BeneficiariesPageState();
}

class _BeneficiariesPageState extends State<BeneficiariesPage> {
  @override
  void initState() {
    super.initState();
    context.read<BeneficiariesBloc>().add(FetchBeneficiaries());
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Scaffold(
      appBar: AppBar(
        title: Text(Locales.string(context, 'beneficiaries_page_title')),
      ),
      body: PageContainer(
        child: SafeArea(
          child: BlocBuilder<BeneficiariesBloc, BeneficiariesState>(
            builder: (context, state) {
              if (state is BeneficiariesLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is BeneficiariesError) {
                return Center(child: Text(state.message));
              }

              if (state is BeneficiariesLoaded) {
                final beneficiaries = state.beneficiaries;

                if (beneficiaries.isEmpty) {
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
                          Locales.string(context, 'empty_beneficiaries'),
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

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  itemCount: beneficiaries.length,
                  itemBuilder: (context, index) {
                    final info = beneficiaries[index];

                    return Padding(
                      key: ValueKey(info.accountNumber),
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Dismissible(
                        key: ValueKey(info.accountNumber),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          context.read<BeneficiariesBloc>().add(
                            DeleteBeneficiary(info.accountNumber),
                          );
                        },
                        child: AppIconCard(
                          leftIcon: FontAwesomeIcons.userShield,
                          boarderColor: theme.colorScheme.primary,
                          cardBody: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                info.name.toTitleCase(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                info.accountNumber,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.indigo,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  "Beneficiary",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            // Optional full card tap handler
                          },
                        ),
                      ),
                    );
                  },
                );
              }

              // default empty widget while waiting for initial or other states
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
