import 'package:pashboi/core/entities/entity.dart';

class EligibilityDetailEntity extends Entity<int> {
  final int accountId;
  final String depositAccountNo;
  final int personId;
  final String fullName;
  final String personMembership;
  final double balance;
  final double withdrawableBalance;
  final double interestRate;
  final bool isSuretyAccount;
  final String accTypeCode;
  final String accountTypeName;
  final bool hasCertificate;
  final String suretyTypeCode;
  final String minimumInstallment;
  final bool isEligible;
  final bool collareralEligible;
  final double maximumLoanAmount;
  final double productInterestRate;
  final int numberOfInstallment;
  final double totalApplyLoan;
  final double loanableBalance;
  final double partialApplyLoan;
  final bool isFamilyDefaulter;
  final bool isSelfDefaulter;
  final bool isCertificateSubmitted;

  EligibilityDetailEntity({
    required super.id,
    required this.accountId,
    required this.depositAccountNo,
    required this.personId,
    required this.fullName,
    required this.personMembership,
    required this.balance,
    required this.withdrawableBalance,
    required this.interestRate,
    required this.isSuretyAccount,
    required this.accTypeCode,
    required this.accountTypeName,
    required this.hasCertificate,
    required this.suretyTypeCode,
    required this.minimumInstallment,
    required this.isEligible,
    required this.collareralEligible,
    required this.maximumLoanAmount,
    required this.productInterestRate,
    required this.numberOfInstallment,
    required this.totalApplyLoan,
    required this.loanableBalance,
    required this.partialApplyLoan,
    required this.isFamilyDefaulter,
    required this.isSelfDefaulter,
    required this.isCertificateSubmitted,
  });

  @override
  List<Object?> get props => [
    id,
    accountId,
    depositAccountNo,
    personId,
    fullName,
    personMembership,
    balance,
    withdrawableBalance,
    interestRate,
    isSuretyAccount,
    accTypeCode,
    accountTypeName,
    hasCertificate,
    suretyTypeCode,
    minimumInstallment,
    isEligible,
    collareralEligible,
    maximumLoanAmount,
    productInterestRate,
    numberOfInstallment,
    totalApplyLoan,
    loanableBalance,
    partialApplyLoan,
    isFamilyDefaulter,
    isSelfDefaulter,
    isCertificateSubmitted,
  ];
}
