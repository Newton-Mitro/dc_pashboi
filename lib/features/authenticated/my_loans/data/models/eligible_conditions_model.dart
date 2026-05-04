import 'package:pashboi/features/authenticated/my_loans/domain/entities/eligible_conditions_entity.dart';

class EligibleConditionsModel extends EligibleConditionsEntity {
  EligibleConditionsModel({
    required int id,
    required String itemName,
    required bool isEligibile,
    required double itemValue,
    required double loaneeValue,
    required double loanAmount,
    required String savingsAccNo,
    required String eligibleLoanProductCode,
    required String loanMemberType,
    required String loanAmountRules,
    required bool isTopUpEligible,
  }) : super(
         id: id,
         itemName: itemName,
         isEligibile: isEligibile,
         itemValue: itemValue,
         loaneeValue: loaneeValue,
         loanAmount: loanAmount,
         eligibleLoanProductCode: eligibleLoanProductCode,
         savingsAccNo: savingsAccNo,
         loanMemberType: loanMemberType,
         loanAmountRules: loanAmountRules,
         isTopUpEligible: isTopUpEligible,
       );

  factory EligibleConditionsModel.fromJson(Map<String, dynamic> json) {
    double _toDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0.0;
    }

    bool _toBool(dynamic value) {
      if (value == null) return false;
      if (value is bool) return value;
      if (value is int) return value == 1;
      if (value is String) {
        return value.toLowerCase() == 'true' || value == '1';
      }
      return false;
    }

    return EligibleConditionsModel(
      id: json['id'] ?? 0,

      itemName: json['ItemName']?.toString() ?? '',
      isEligibile: _toBool(json['IsEligibile']),
      itemValue: _toDouble(json['ItemValue']),
      loaneeValue: _toDouble(json['LoaneeValue']),
      loanAmount: _toDouble(json['LoanAmount']),

      eligibleLoanProductCode:
      json['EligibleLoanProductCode']?.toString() ?? '',

      savingsAccNo: json['SavingsAccNo']?.toString() ?? '',
      loanMemberType: json['LoanMemberType']?.toString() ?? '',
      loanAmountRules: json['LoanAmountRules']?.toString() ?? '',

      isTopUpEligible: _toBool(json['IsTopUpEligible']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ItemName': itemName,
      'IsEligibile': isEligibile,
      'ItemValue': itemValue,
      'LoaneeValue': loaneeValue,
      'LoanAmount': loanAmount,
      'EligibleLoanProductCode': eligibleLoanProductCode,
      'SavingsAccNo': savingsAccNo,
      'LoanMemberType': loanMemberType,
      'LoanAmountRules': loanAmountRules,
      'IsTopUpEligible': isTopUpEligible,
    };
  }
}
