import 'package:pashboi/core/entities/entity.dart';

class AgainstLoanInterestEntity extends Entity<int> {
  final double eligibleLoanAmount;
  final double maxLoanAmount;
  final String minimumInstallment;
  final bool isEligible;

  AgainstLoanInterestEntity({
    required super.id,
    required this.eligibleLoanAmount,
    required this.maxLoanAmount,
    required this.minimumInstallment,
    required this.isEligible,
  });

  @override
  List<Object?> get props => [
    id,
    eligibleLoanAmount,
    maxLoanAmount,
    minimumInstallment,
    isEligible,
  ];
}
