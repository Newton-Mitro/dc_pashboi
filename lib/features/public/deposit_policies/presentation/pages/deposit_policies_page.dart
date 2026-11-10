import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/core/injection.dart';
import 'package:pashboi/features/public/deposit_policies/domain/enities/deposit_policy_entity.dart';
import 'package:pashboi/features/public/deposit_policies/presentation/bloc/deposit_policy_bloc.dart';
import 'package:pashboi/routes/public_routes_name.dart';
import 'package:pashboi/shared/widgets/page_container.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/shared/widgets/public_app_icon_card.dart';

class DepositPoliciesPage extends StatelessWidget {
  const DepositPoliciesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => sl<DepositPolicyBloc>()..add(FetchDepositPolicyEvent()),
      child: PageContainer(
        child: BlocBuilder<DepositPolicyBloc, DepositPolicyState>(
          builder: (context, state) {
            if (state is DepositProductLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DepositPolicyError) {
              return Center(child: Text('Error: ${state.error}'));
            } else if (state is DepositPolicySuccess) {
              final List<DepositPolicyEntity> products = state.depositPolicies;

              if (products.isEmpty) {
                return const Center(child: Text('No deposit products found.'));
              }

              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5,
                    ), // Adjust spacing here
                    child: PublicAppIconCard(
                      leftIcon: FontAwesomeIcons.piggyBank,
                      rightIcon: FontAwesomeIcons.chevronRight,
                      boarderColor: context.theme.colorScheme.primary,
                      cardBody: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              product.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Html(data: product.shortDescription),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          PublicRoutesName.savingPolicyDetailsPage,
                          arguments: {"depositPolicy": product},
                        );
                      },
                    ),
                  );
                },
              );
            }

            return const SizedBox.shrink(); // default fallback
          },
        ),
      ),
    );
  }
}
