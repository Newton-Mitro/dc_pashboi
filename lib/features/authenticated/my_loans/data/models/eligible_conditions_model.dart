import 'package:pashboi/features/authenticated/my_loans/domain/entities/eligible_conditions_entity.dart';

class EligibleConditionsModel extends EligibleConditionsEntity {
  EligibleConditionsModel({
    required int super.id,
    required super.itemName,
    required super.isEligibile,
    required super.itemValue,
    required super.loaneeValue,
    required super.loanAmount,
    required super.savingsAccNo,
    required super.eligibleLoanProductCode,
    required super.loanMemberType,
    required super.loanAmountRules,
    required super.isTopUpEligible,
  });

  factory EligibleConditionsModel.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0.0;
    }

    bool toBool(dynamic value) {
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
      isEligibile: toBool(json['IsEligibile']),
      itemValue: toDouble(json['ItemValue']),
      loaneeValue: toDouble(json['LoaneeValue']),
      loanAmount: toDouble(json['LoanAmount']),

      eligibleLoanProductCode:
          json['EligibleLoanProductCode']?.toString() ?? '',

      savingsAccNo: json['SavingsAccNo']?.toString() ?? '',
      loanMemberType: json['LoanMemberType']?.toString() ?? '',
      loanAmountRules: json['LoanAmountRules']?.toString() ?? '',

      isTopUpEligible: toBool(json['IsTopUpEligible']),
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
