import 'package:pashboi/features/authenticated/my_loans/data/models/eligibility_details_model.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/deposit_loan_eligibility_dto.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/eligibility_details_entity.dart';
import 'dart:convert';

class DepositLoanEligibilityModel {
  final int productId;
  final String loanProductCode;
  final String loanProductName;
  final double interestRate;
  final int interestType;
  final bool isEligible;
  final List<EligibilityDetailModel> eligibilityDetails;

  DepositLoanEligibilityModel({
    required this.productId,
    required this.loanProductCode,
    required this.loanProductName,
    required this.interestRate,
    required this.interestType,
    required this.isEligible,
    required this.eligibilityDetails,
  });

  factory DepositLoanEligibilityModel.fromJson(Map<String, dynamic> json) {
    final details = json['EligibilityDetails'];
    final parsedDetails =
        details is String
            ? jsonDecode(details) as List<dynamic>
            : details as List<dynamic>;

    return DepositLoanEligibilityModel(
      productId: json['ProductId'] as int,
      loanProductCode: json['LoanProductCode'] as String,
      loanProductName: json['LoanProductName'] as String,
      interestRate: (json['InterestRate'] as num).toDouble(),
      interestType: json['InterestType'] as int,
      isEligible: json['IsEligible'] as bool,
      eligibilityDetails:
          parsedDetails
              .map(
                (e) =>
                    EligibilityDetailModel.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ProductId': productId,
      'LoanProductCode': loanProductCode,
      'LoanProductName': loanProductName,
      'InterestRate': interestRate,
      'InterestType': interestType,
      'IsEligible': isEligible,
      'EligibilityDetails':
          eligibilityDetails
              .map((e) => (e as EligibilityDetailModel).toJson())
              .toList(),
    };
  }

  DepositLoanEligibilityDto toEntity() {
    return DepositLoanEligibilityDto(
      productId: productId,
      loanProductCode: loanProductCode,
      loanProductName: loanProductName,
      interestRate: interestRate,
      interestType: interestType,
      isEligible: isEligible,
      eligibilityDetails:
          eligibilityDetails
              .map((e) => (e as EligibilityDetailEntity))
              .toList(),
    );
  }
}
