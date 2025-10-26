import 'package:pashboi/features/authenticated/my_loans/data/models/product_loan_collateral_account_model.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/submit_loan_against_deposit_product_entity.dart';

class SubmitLoanAgainstDepositProductModel
    extends SubmitLoanAgainstDepositProductEntity {
  SubmitLoanAgainstDepositProductModel({
    required super.collateralAccounts,
    required super.loanProductCode,

    required super.maximumLoanAmount,
    required super.interestRate,
    required super.numberOfInstallment,
    required super.totalApplyLoan,
    required super.secretKey,
    required super.cardNo,
    required super.oTPRegId,
    required super.oTPValue,
  });

  factory SubmitLoanAgainstDepositProductModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return SubmitLoanAgainstDepositProductModel(
      collateralAccounts:
          (json['CollateralAccounts'] as List<dynamic>)
              .map((e) => ProductLoanCollateralAccountModel.fromJson(e))
              .toList(),
      loanProductCode: json['LoanProductCode'],

      maximumLoanAmount: (json['MaximumLoanAmount'] as num).toDouble(),
      interestRate: (json['InterestRate'] as num).toDouble(),
      numberOfInstallment: (json['numberOfInstallment'].toString()),
      totalApplyLoan: (json['TotalApplyLoan'] as num).toDouble(),
      secretKey: (json['SecretKey'].toString()),
      cardNo: (json['CardNo'].toString()),
      oTPRegId: (json['oTPRegId'].toString()),
      oTPValue: (json['oTPValue'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'collateralAccounts':
          collateralAccounts
              .map((e) => (e as ProductLoanCollateralAccountModel).toJson())
              .toList(),
      'loanProductCode': loanProductCode,

      'maximumLoanAmount': maximumLoanAmount,
      'interestRate': interestRate,
      'numberOfInstallment': numberOfInstallment,
      'totalApplyLoan': totalApplyLoan,
      'secretKey': secretKey,
      'cardNo': cardNo,
      'oTPRegId': oTPRegId,
      'oTPValue': oTPValue,
    };
  }
}
