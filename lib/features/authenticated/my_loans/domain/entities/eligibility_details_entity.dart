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
  final bool isSelected;

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
    this.isSelected = false,
  });

  EligibilityDetailEntity copyWith({
    int? id,
    int? accountId,
    String? depositAccountNo,
    int? personId,
    String? fullName,
    String? personMembership,
    double? balance,
    double? withdrawableBalance,
    double? interestRate,
    bool? isSuretyAccount,
    String? accTypeCode,
    String? accountTypeName,
    bool? hasCertificate,
    String? suretyTypeCode,
    String? minimumInstallment,
    bool? isEligible,
    bool? collareralEligible,
    double? maximumLoanAmount,
    double? productInterestRate,
    int? numberOfInstallment,
    double? totalApplyLoan,
    double? loanableBalance,
    double? partialApplyLoan,
    bool? isFamilyDefaulter,
    bool? isSelfDefaulter,
    bool? isCertificateSubmitted,
    bool? isSelected,
  }) {
    return EligibilityDetailEntity(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      depositAccountNo: depositAccountNo ?? this.depositAccountNo,
      personId: personId ?? this.personId,
      fullName: fullName ?? this.fullName,
      personMembership: personMembership ?? this.personMembership,
      balance: balance ?? this.balance,
      withdrawableBalance: withdrawableBalance ?? this.withdrawableBalance,
      interestRate: interestRate ?? this.interestRate,
      isSuretyAccount: isSuretyAccount ?? this.isSuretyAccount,
      accTypeCode: accTypeCode ?? this.accTypeCode,
      accountTypeName: accountTypeName ?? this.accountTypeName,
      hasCertificate: hasCertificate ?? this.hasCertificate,
      suretyTypeCode: suretyTypeCode ?? this.suretyTypeCode,
      minimumInstallment: minimumInstallment ?? this.minimumInstallment,
      isEligible: isEligible ?? this.isEligible,
      collareralEligible: collareralEligible ?? this.collareralEligible,
      maximumLoanAmount: maximumLoanAmount ?? this.maximumLoanAmount,
      productInterestRate: productInterestRate ?? this.productInterestRate,
      numberOfInstallment: numberOfInstallment ?? this.numberOfInstallment,
      totalApplyLoan: totalApplyLoan ?? this.totalApplyLoan,
      loanableBalance: loanableBalance ?? this.loanableBalance,
      partialApplyLoan: partialApplyLoan ?? this.partialApplyLoan,
      isFamilyDefaulter: isFamilyDefaulter ?? this.isFamilyDefaulter,
      isSelfDefaulter: isSelfDefaulter ?? this.isSelfDefaulter,
      isCertificateSubmitted:
          isCertificateSubmitted ?? this.isCertificateSubmitted,
      isSelected: isSelected ?? this.isSelected,
    );
  }

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
    isSelected,
  ];
}
