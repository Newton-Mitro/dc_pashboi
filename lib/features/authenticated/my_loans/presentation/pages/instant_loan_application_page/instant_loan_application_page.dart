import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pashboi/features/authenticated/my_loans/presentation/pages/instant_loan_application_page/instant_loan_eligible/instant_loan_eligible.dart';
import 'package:pashboi/features/authenticated/my_loans/presentation/pages/instant_loan_terms_condition_page/bloc/instant_loan_eligibility_bloc.dart';
import 'package:pashboi/features/authenticated/my_loans/data/models/eligible_conditions_model.dart';

class InstantLoanApplicationPage extends StatefulWidget {
  const InstantLoanApplicationPage({super.key});

  @override
  State<InstantLoanApplicationPage> createState() =>
      _InstantLoanApplicationPageState();
}

class _InstantLoanApplicationPageState
    extends State<InstantLoanApplicationPage> {
  bool isTopUp = false;

  @override
  void initState() {
    super.initState();
    // Trigger the fetch event on bloc
    context.read<InstantLoanEligibilityBloc>().add(
      FetchInstantLoanEligibilityEvent(),
    );
  }

  void _handleTopUpChange() {
    setState(() {
      isTopUp = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Instant Loan Application')),
      body:
          BlocBuilder<InstantLoanEligibilityBloc, InstantLoanEligibilityState>(
            builder: (context, state) {
              if (state is InstantLoanEligibilityLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is InstantLoanEligibilitySuccess) {
                final data = state.instantLoanEligibilityDTO;

                final List<EligibleConditionsModel> eligibleConditions =
                    (data.eligibleConditions as List)
                        .cast<EligibleConditionsModel>();

                return InstantLoanEligible(
                  eligibleConditions: eligibleConditions,
                );
              }

              // Default or initial state
              return const SizedBox.shrink();
            },
          ),
    );
  }
}
