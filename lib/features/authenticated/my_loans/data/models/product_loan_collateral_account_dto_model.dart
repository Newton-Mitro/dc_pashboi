import 'package:pashboi/core/entities/entity.dart';
import 'package:pashboi/features/authenticated/my_loans/data/models/product_loan_collateral_account_model.dart';

class ProductLoanEligibleCollateralAccountDto extends Entity<int> {
  final List<ProductLoanCollateralAccountModel> collateralAccounts;
  final double maximumLoanAmount;
  final double interestRate;
  final int numberOfInstallment;
  final double totalApplyLoan;

  ProductLoanEligibleCollateralAccountDto({
    required super.id,
    required this.collateralAccounts,
    required this.maximumLoanAmount,
    required this.interestRate,
    required this.numberOfInstallment,
    required this.totalApplyLoan,
  });

  factory ProductLoanEligibleCollateralAccountDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProductLoanEligibleCollateralAccountDto(
      id: json['id'] as int,
      collateralAccounts:
          (json['collateralAccounts'] as List<dynamic>)
              .map(
                (e) => ProductLoanCollateralAccountModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
      maximumLoanAmount: (json['maximumLoanAmount'] as num).toDouble(),
      interestRate: (json['interestRate'] as num).toDouble(),
      numberOfInstallment: json['numberOfInstallment'] as int,
      totalApplyLoan: (json['totalApplyLoan'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'collateralAccounts': collateralAccounts.map((e) => e.toJson()).toList(),
      'maximumLoanAmount': maximumLoanAmount,
      'interestRate': interestRate,
      'numberOfInstallment': numberOfInstallment,
      'totalApplyLoan': totalApplyLoan,
    };
  }

  @override
  List<Object?> get props => [
    id,
    collateralAccounts,
    maximumLoanAmount,
    interestRate,
    numberOfInstallment,
    totalApplyLoan,
  ];
}
