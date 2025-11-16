import 'package:pashboi/features/authenticated/collection_ledgers/domain/entities/collection_ledger_entity.dart';

class CollectionLedgerModel extends CollectionLedgerEntity {
  CollectionLedgerModel({
    super.id,
    required super.accountNumber,
    required super.accountName,
    required super.ledgerName,
    required super.accountTypeCode,
    required super.moduleCode,
    required super.amount,
    required super.depositAmount,
    required super.accountId,
    required super.defaultAccount,
    required super.subledger,
    required super.multiplier,
    required super.editable,
    required super.lps,
    required super.ledgerId,
    required super.plType,
    required super.loanBalance,
    required super.intrestRate,
    required super.lastPaidDate,
    required super.refundBased,
    required super.collectionType,
    required super.accountFor,
    required super.isRefundBased,
    required super.isSelected,
  });

  factory CollectionLedgerModel.fromJson(Map<String, dynamic> json) {
    return CollectionLedgerModel(
      id: parseInt(json['Id']),
      accountNumber: json['AccountNo'] ?? '',
      accountName: json['AccountName'] ?? '',
      ledgerName: json['LedgerName'] ?? '',
      accountTypeCode: json['AccountTypeCode'] ?? '',
      moduleCode: json['ModuleCode'] ?? '',
      amount: parseInt(json['Amount']),
      depositAmount: parseInt(json['DepositAmount'] ?? json['Amount']),
      accountId: parseInt(json['AccountId']),
      ledgerId: parseInt(json['LedgerId']),
      defaultAccount: json['IsDefaulter'] ?? false,
      subledger: json['IsSubLedger'] ?? false,
      multiplier: json['IsMultiplier'] ?? false,
      editable: json['IsNotEditable'] ?? false,
      lps: json['IsLps'] ?? false,
      plType: parseInt(json['PlType']),
      loanBalance: parseInt(json['LoanBalance']),
      intrestRate:
          (json['InterestRate'] is num)
              ? (json['InterestRate'] as num).toDouble()
              : double.tryParse(json['InterestRate'] ?? "0") ?? 0.0,
      lastPaidDate:
          DateTime.tryParse(json['LastPaidDate'] ?? '') ?? DateTime(1970),
      refundBased: json['IsRefundBased'] ?? false,
      collectionType: json['LoanCollectionType'] ?? '',
      accountFor: json['AccountFor'] ?? '',
      isRefundBased: json['IsRefundBased'] ?? false,
      isSelected: false,
    );
  }

  static int parseInt(dynamic value) {
    if (value == null) return 0;

    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is num) return value.toInt();

    if (value is String) {
      return double.tryParse(value)?.toInt() ?? 0;
    }

    return 0;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'accountNumber': accountNumber,
      'accountName': accountName,
      'ledgerName': ledgerName,
      'accountTypeCode': accountTypeCode,
      'moduleCode': moduleCode,
      'depositAmount': amount,
      'accountId': accountId,
      'ledgerId': ledgerId,
      'defaultAccount': defaultAccount,
      'subledger': subledger,
      'multiplier': multiplier,
      'editable': editable,
      'lps': lps,
      'plType': plType,
      'loanBalance': loanBalance,
      'intrestRate': intrestRate,
      'lastPaidDate': lastPaidDate.toIso8601String(),
      'refundBased': refundBased,
      'LoanCollectionType': collectionType,
      'isRefundBased': isRefundBased,
      'accountFor': accountFor,
    };
  }
}
