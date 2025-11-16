import 'package:pashboi/core/entities/entity.dart';

class CollectionLedgerEntity extends Entity<int> {
  final int accountId;
  final String accountNumber;
  final String accountName;
  final String accountTypeCode;
  final String moduleCode;

  final int ledgerId;
  final String ledgerName;
  final bool subledger;
  final int plType;
  final String collectionType;
  final bool defaultAccount;

  final int amount;
  final int depositAmount;

  final bool multiplier;
  final bool editable;

  final int loanBalance;
  final bool lps;
  final double intrestRate;
  final DateTime lastPaidDate;
  final bool refundBased;

  final String accountFor;
  final bool isSelected;
  final bool isRefundBased;

  CollectionLedgerEntity({
    super.id,
    required this.accountNumber,
    required this.accountName,
    required this.ledgerName,
    required this.accountTypeCode,
    required this.moduleCode,
    required this.amount,
    required this.depositAmount,
    required this.accountId,
    required this.defaultAccount,
    required this.subledger,
    required this.multiplier,
    required this.editable,
    required this.lps,
    required this.ledgerId,
    required this.plType,
    required this.loanBalance,
    required this.intrestRate,
    required this.lastPaidDate,
    required this.refundBased,
    required this.collectionType,
    required this.accountFor,
    required this.isRefundBased,
    this.isSelected = false,
  });

  Map<String, dynamic> toJson() => {
    'AccountId': accountId,
    'AccountNo': accountNumber.trim(),
    'AccountType': accountTypeCode.trim(),
    'Amount': depositAmount,
    'IsDefaulter': defaultAccount,
    'IsLps': lps,
    'IsMultiplier': multiplier,
    'IsNotEditable': editable,
    'IsRefundBased': isRefundBased,
    'IsSubLedger': subledger,
    'LedgerId': ledgerId,
    'PlType': plType,
  };

  CollectionLedgerEntity copyWith({
    int? id,
    int? accountId,
    String? accountNumber,
    String? accountName,
    String? accountTypeCode,
    String? moduleCode,
    int? ledgerId,
    String? ledgerName,
    bool? subledger,
    int? plType,
    String? collectionType,
    bool? defaultAccount,
    int? amount,
    int? depositAmount,
    bool? multiplier,
    bool? editable,
    int? loanBalance,
    bool? lps,
    double? intrestRate,
    DateTime? lastPaidDate,
    bool? refundBased,
    String? accountFor,
    bool? isRefundBased,
    bool? isSelected,
  }) {
    return CollectionLedgerEntity(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      accountNumber: accountNumber ?? this.accountNumber,
      accountName: accountName ?? this.accountName,
      accountTypeCode: accountTypeCode ?? this.accountTypeCode,
      moduleCode: moduleCode ?? this.moduleCode,
      ledgerId: ledgerId ?? this.ledgerId,
      ledgerName: ledgerName ?? this.ledgerName,
      subledger: subledger ?? this.subledger,
      plType: plType ?? this.plType,
      collectionType: collectionType ?? this.collectionType,
      defaultAccount: defaultAccount ?? this.defaultAccount,
      amount: amount ?? this.amount,
      depositAmount: depositAmount ?? this.depositAmount,
      multiplier: multiplier ?? this.multiplier,
      editable: editable ?? this.editable,
      loanBalance: loanBalance ?? this.loanBalance,
      lps: lps ?? this.lps,
      intrestRate: intrestRate ?? this.intrestRate,
      lastPaidDate: lastPaidDate ?? this.lastPaidDate,
      refundBased: refundBased ?? this.refundBased,
      accountFor: accountFor ?? this.accountFor,
      isSelected: isSelected ?? this.isSelected,
      isRefundBased: isRefundBased ?? this.isRefundBased,
    );
  }

  @override
  List<Object?> get props => [
    id,
    accountNumber,
    accountName,
    ledgerName,
    accountTypeCode,
    moduleCode,
    amount,
    depositAmount,
    accountId,
    ledgerId,
    defaultAccount,
    subledger,
    multiplier,
    editable,
    lps,
    plType,
    loanBalance,
    intrestRate,
    lastPaidDate,
    refundBased,
    collectionType,
    accountFor,
    isRefundBased,
    isSelected,
  ];
}
