import 'package:pashboi/features/authenticated/my_loans/data/models/eligibility_details_model.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/loan_product_entity.dart';

class LoanProductModel extends LoanProductEntity {
  LoanProductModel({
    required super.id,
    required super.loanProductCode,
    required super.loanProductName,
    required super.interestRate,
    required super.isEligible,
    required super.eligibilityDetails,
  });

  factory LoanProductModel.fromJson(Map<String, dynamic> json) {
    return LoanProductModel(
      id: json['ProductId'] as int,
      loanProductCode: (json['LoanProductCode'] ?? '').toString().trim(),
      loanProductName: (json['LoanProductName'] ?? '').toString(),
      interestRate: (json['InterestRate'] as num).toDouble(),
      isEligible: json['IsEligible'] as bool,
      eligibilityDetails:
          (json['EligibilityDetails'] as List<dynamic>)
              .map((e) => EligibilityDetailModel.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ProductId": id,
      "LoanProductCode": loanProductCode,
      "LoanProductName": loanProductName,
      "InterestRate": interestRate,
      "IsEligible": isEligible,
      "EligibilityDetails":
          eligibilityDetails
              .map((e) => (e as EligibilityDetailModel).toJson())
              .toList(),
    };
  }
}
