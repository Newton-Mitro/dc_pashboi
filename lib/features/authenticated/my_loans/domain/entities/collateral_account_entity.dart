import 'package:pashboi/core/entities/entity.dart';

class CollateralAccountEntity extends Entity<int> {
  final String accountType;
  final String accountNumber;
  final double totalBalance;
  final double loanableBalance;
  final double partialApplyLoan;
  final bool isEligible;
  final double withdrawableBalance;

  CollateralAccountEntity({
    required super.id,
    required this.accountType,
    required this.accountNumber,
    required this.totalBalance,
    required this.loanableBalance,
    required this.partialApplyLoan,
    required this.isEligible,
    required this.withdrawableBalance,
  });

  @override
  List<Object?> get props => [
    id,
    accountType,
    accountNumber,
    totalBalance,
    loanableBalance,
    partialApplyLoan,
    isEligible,
    withdrawableBalance,
  ];
}
