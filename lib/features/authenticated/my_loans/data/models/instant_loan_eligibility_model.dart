import 'package:pashboi/features/authenticated/my_loans/data/models/eligible_conditions_model.dart';

class InstantLoanEligibilityModel {
  final String eligibilityMessage;
  final List<dynamic> eligibleConditions;

  InstantLoanEligibilityModel({
    required this.eligibilityMessage,
    required this.eligibleConditions,
  });

  factory InstantLoanEligibilityModel.fromJson(Map<String, dynamic> json) {
    return InstantLoanEligibilityModel(
      eligibilityMessage: json['EligibilityMessage'] as String,
      eligibleConditions:
          (json['EligibleConditions'] as List<dynamic>)
              .map(
                (e) =>
                    EligibleConditionsModel.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'EligibilityMessage': eligibilityMessage,
      'EligibleConditions':
          eligibleConditions
              .map((e) => (e as EligibleConditionsModel).toJson())
              .toList(),
    };
  }
}
