import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pashboi/features/authenticated/my_loans/presentation/pages/instant_loan_application_page/instant_loan_eligible/instant_loan_eligible.dart';
import 'package:pashboi/features/authenticated/my_loans/presentation/pages/instant_loan_application_page/instant_loan_not_eligible/instant_loan_not_eligible.dart';
import 'package:pashboi/features/authenticated/my_loans/presentation/pages/instant_loan_terms_condition_page/bloc/instant_loan_eligibility_bloc.dart';
import 'package:pashboi/features/authenticated/my_loans/data/models/eligible_conditions_model.dart'; // Add this if not already

class InstantLoanApplicationPage extends StatefulWidget {
  const InstantLoanApplicationPage({super.key});

  @override
  State<InstantLoanApplicationPage> createState() =>
      _InstantLoanApplicationPageState();
}

class _InstantLoanApplicationPageState
    extends State<InstantLoanApplicationPage> {
  @override
  void initState() {
    super.initState();
    // Trigger the fetch event on bloc
    context.read<InstantLoanEligibilityBloc>().add(
      FetchInstantLoanEligibilityEvent(),
    );
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

                // Safely cast the eligibleConditions list
                final List<EligibleConditionsModel> eligibleConditions =
                    (data.eligibleConditions as List)
                        .cast<EligibleConditionsModel>();

                if (data.eligibilityMessage == "Not Eligible") {
                  return InstantLoanNotEligible(
                    eligibleConditions: eligibleConditions,
                  );
                } else {
                  return InstantLoanEligible(
                    eligibleConditions: eligibleConditions,
                  );
                }
              }

              // Default fallback UI
              return const SizedBox();
            },
          ),
    );
  }
}
