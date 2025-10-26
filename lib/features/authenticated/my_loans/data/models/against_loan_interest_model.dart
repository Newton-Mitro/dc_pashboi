import 'package:pashboi/features/authenticated/my_loans/domain/entities/against_loan_interest_entity.dart';

class AgainstLoanInterestModel extends AgainstLoanInterestEntity {
  AgainstLoanInterestModel({
    required super.id,
    required super.eligibleLoanAmount,
    required super.maxLoanAmount,
    required super.minimumInstallment,
    required super.interestRate,
    required super.isEligible,
  });

  factory AgainstLoanInterestModel.fromJson(Map<String, dynamic> json) {
    return AgainstLoanInterestModel(
      id: 0,
      eligibleLoanAmount: (json['EligibleLoanAmount'] as num).toDouble(),
      maxLoanAmount: (json['MaxLoanAmount'] as num).toDouble(),
      interestRate: (json['InterestRate'] as num).toDouble(),
      minimumInstallment: (json['MinimumInstallment'] ?? '').toString(),
      isEligible: json['IsEligible'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "EligibleLoanAmount": eligibleLoanAmount,
      "MaxLoanAmount": maxLoanAmount,
      "InterestRate": interestRate,
      "MinimumInstallment": minimumInstallment,
      "IsEligible": isEligible,
    };
  }
}
