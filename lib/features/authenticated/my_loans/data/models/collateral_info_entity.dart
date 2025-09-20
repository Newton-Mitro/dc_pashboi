import 'package:pashboi/features/authenticated/my_loans/data/models/collateral_account_model.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/collateral_info_entity.dart';

class CollateralInfoModel extends CollateralInfoEntity {
  CollateralInfoModel({
    required super.id,
    required super.collateralAccounts,
    required super.maximumLoanAmount,
    required super.numberOfInstallment,
  });

  factory CollateralInfoModel.fromJson(Map<String, dynamic> json) {
    return CollateralInfoModel(
      id: 0, // since API does not provide id, use 0 or UUID
      collateralAccounts:
          (json['CollateralAccounts'] as List<dynamic>)
              .map((e) => CollateralAccountModel.fromJson(e))
              .toList(),
      maximumLoanAmount: (json['MaximumLoanAmount'] as num).toDouble(),
      numberOfInstallment: json['NumberOfInstallment'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "CollateralAccounts":
          collateralAccounts
              .map((e) => (e as CollateralAccountModel).toJson())
              .toList(),
      "MaximumLoanAmount": maximumLoanAmount,
      "NumberOfInstallment": numberOfInstallment,
    };
  }
}
