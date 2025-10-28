import 'package:pashboi/features/authenticated/my_loans/domain/entities/product_loan_collateral_account_entity.dart';

class ProductLoanCollateralAccountModel
    extends ProductLoanCollectionAccountEntity {
  ProductLoanCollateralAccountModel({
    required super.id,
    required super.accountType,
    required super.accountNumber,
    required super.totalBalance,
    required super.loanableBalance,
    required super.partialApplyLoan,
    required super.isEligible,
    required super.withdrawableBalance,
  });

  factory ProductLoanCollateralAccountModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProductLoanCollateralAccountModel(
      id:
          json['AccountId'] is int
              ? json['AccountId'] as int
              : int.tryParse(json['AccountId'].toString()) ?? 0,
      accountType: (json['AccountType'] ?? '').toString(),
      accountNumber: (json['AccountNumber'] ?? '').toString(),
      totalBalance: (json['TotalBalance'] as num?)?.toDouble() ?? 0.0,
      loanableBalance: (json['LoanableBalance'] as num?)?.toDouble() ?? 0.0,
      partialApplyLoan: (json['PartialApplyLoan'] ?? '').toString(),
      isEligible:
          json['IsEligible'] == true ||
          json['IsEligible']?.toString().toLowerCase() == 'true',
      withdrawableBalance:
          (json['WithdrawableBalance'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "AccountId": id,
      "AccountType": accountType,
      "AccountNumber": accountNumber,
      "TotalBalance": totalBalance,
      "LoanableBalance": loanableBalance,
      "PartialApplyLoan": partialApplyLoan,
      "IsEligible": isEligible,
      "WithdrawableBalance": withdrawableBalance,
    };
  }

  factory ProductLoanCollateralAccountModel.fromEntity(
    ProductLoanCollectionAccountEntity entity,
  ) {
    return ProductLoanCollateralAccountModel(
      id: entity.id,
      accountType: entity.accountType,
      accountNumber: entity.accountNumber,
      totalBalance: entity.totalBalance,
      loanableBalance: entity.loanableBalance,
      partialApplyLoan: entity.partialApplyLoan,
      isEligible: entity.isEligible,
      withdrawableBalance: entity.withdrawableBalance,
    );
  }

  static List<Map<String, dynamic>> listToJson(
    List<ProductLoanCollectionAccountEntity> entities,
  ) {
    return entities
        .map((e) => ProductLoanCollateralAccountModel.fromEntity(e).toJson())
        .toList();
  }
}
