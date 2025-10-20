import 'package:pashboi/core/entities/entity.dart';

class ProductLoanCollectionAccountEntity extends Entity<int> {
  final String accountType;
  final String accountNumber;
  final double totalBalance;
  final double loanableBalance;
  final double partialApplyLoan;
  final bool isEligible;
  final double withdrawableBalance;
  final bool? isSelected;

  ProductLoanCollectionAccountEntity({
    required super.id,
    required this.accountType,
    required this.accountNumber,
    required this.totalBalance,
    required this.loanableBalance,
    required this.partialApplyLoan,
    required this.isEligible,
    required this.withdrawableBalance,
    this.isSelected,
  });

  ProductLoanCollectionAccountEntity copyWith({
    int? id,
    String? accountType,
    String? accountNumber,
    double? totalBalance,
    double? loanableBalance,
    double? partialApplyLoan,
    bool? isEligible,
    double? withdrawableBalance,
    bool? isSelected,
  }) {
    return ProductLoanCollectionAccountEntity(
      id: id ?? this.id,
      accountType: accountType ?? this.accountType,
      accountNumber: accountNumber ?? this.accountNumber,
      totalBalance: totalBalance ?? this.totalBalance,
      loanableBalance: loanableBalance ?? this.loanableBalance,
      partialApplyLoan: partialApplyLoan ?? this.partialApplyLoan,
      isEligible: isEligible ?? this.isEligible,
      withdrawableBalance: withdrawableBalance ?? this.withdrawableBalance,
      isSelected: isSelected ?? this.isSelected,
    );
  }

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
    isSelected,
  ];
}
