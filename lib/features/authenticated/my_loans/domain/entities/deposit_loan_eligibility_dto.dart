import 'package:pashboi/features/authenticated/my_loans/domain/entities/eligibility_details_entity.dart';

class DepositLoanEligibilityDto {
  final int productId;
  final String loanProductCode;
  final String loanProductName;
  final double interestRate;
  final int interestType;
  final bool isEligible;
  final List<EligibilityDetailEntity> eligibilityDetails;

  DepositLoanEligibilityDto({
    required this.productId,
    required this.loanProductCode,
    required this.loanProductName,
    required this.interestRate,
    required this.interestType,
    required this.isEligible,
    required this.eligibilityDetails,
  });

  @override
  List<Object?> get props => [
    productId,
    loanProductCode,
    loanProductName,
    interestRate,
    interestType,
    isEligible,
    eligibilityDetails,
  ];
}
