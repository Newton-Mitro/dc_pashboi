import 'package:pashboi/core/entities/entity.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/eligibility_details_entity.dart';

class LoanProductEntity extends Entity<int> {
  final String loanProductCode;
  final String loanProductName;
  final double interestRate;
  final bool isEligible;
  final List<EligibilityDetailEntity> eligibilityDetails;

  LoanProductEntity({
    required super.id,
    required this.loanProductCode,
    required this.loanProductName,
    required this.interestRate,
    required this.isEligible,
    required this.eligibilityDetails,
  });

  @override
  List<Object> get props => [
    id,
    loanProductCode,
    loanProductName,
    interestRate,
    isEligible,
    eligibilityDetails,
  ];
}
