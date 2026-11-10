import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/core/injection.dart';
import 'package:pashboi/features/public/loan_policies/presentation/bloc/loan_policy_bloc.dart';
import 'package:pashboi/routes/public_routes_name.dart';
import 'package:pashboi/shared/widgets/page_container.dart';
import 'package:pashboi/features/public/loan_policies/domain/entites/loan_policy_entity.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/shared/widgets/public_app_icon_card.dart';

class LoanPoliciesPage extends StatefulWidget {
  const LoanPoliciesPage({super.key});

  @override
  State<LoanPoliciesPage> createState() => _LoanPoliciesPageState();
}

class _LoanPoliciesPageState extends State<LoanPoliciesPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LoanPolicyBloc>()..add(FetchLoanPolicyEvent()),
      child: PageContainer(
        child: BlocBuilder<LoanPolicyBloc, LoanPolicyState>(
          builder: (context, state) {
            if (state is LoanPolicyLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LoanPolicySuccess) {
              final List<LoanPolicyEntity> policies = state.loanPolicies;

              if (policies.isEmpty) {
                return const Center(child: Text("No loan policies available."));
              }
              return ListView.builder(
                itemCount: policies.length,
                itemBuilder: (context, index) {
                  final product = policies[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 10,
                    ), // Adjust spacing here
                    child: PublicAppIconCard(
                      leftIcon: FontAwesomeIcons.piggyBank,
                      rightIcon: FontAwesomeIcons.chevronRight,
                      boarderColor: context.theme.colorScheme.primary,
                      cardBody: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
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
                          PublicRoutesName.loanPoliciesDetailsPage,
                          arguments: {"loanPolicy": product},
                        );
                      },
                    ),
                  );
                },
              );

              // return ListView.builder(
              //   itemCount: policies.length,
              //   itemBuilder: (context, index) {
              //     final policy = policies[index];
              //     return Card(
              //       elevation: 1,
              //       shadowColor: const Color.fromARGB(179, 0, 0, 0),
              //       color: context.theme.colorScheme.surface,
              //       surfaceTintColor: context.theme.colorScheme.primary,
              //       margin: const EdgeInsets.symmetric(
              //         horizontal: 12,
              //         vertical: 8,
              //       ),
              //       child: ListTile(
              //         leading: FaIcon(
              //           FontAwesomeIcons.sackDollar,
              //           size: 24,
              //           color: context.theme.colorScheme.onSurface,
              //         ),
              //         title: Text(
              //           policy.title,
              //           style: TextStyle(
              //             color: context.theme.colorScheme.onSurface,
              //           ),
              //         ),
              //         subtitle: Text(
              //           policy.shortDescription ?? 'No description',
              //           style: TextStyle(
              //             color: context.theme.colorScheme.onSurface,
              //           ),
              //         ),
              //         trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              //         onTap: () {
              //           Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //               builder:
              //                   (context) =>
              //                       LoanPolicyDetailsPage(loanPolicy: policy),
              //             ),
              //           );
              //         },
              //       ),
              //     );
              //   },
              // );
            } else if (state is LoanPolicyerror) {
              return Center(child: Text("Error: ${state.error}"));
            }

            return const SizedBox.shrink(); // Default state
          },
        ),
      ),
    );
  }
}
