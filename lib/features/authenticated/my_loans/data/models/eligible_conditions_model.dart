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
    return EligibleConditionsModel(
      id: json['id'] ?? 0,
      itemName: json['ItemName'] as String,
      isEligibile: json['IsEligibile'] as bool,
      itemValue: json['ItemValue'] as double,
      loaneeValue: json['LoaneeValue'] as double,
      loanAmount: json['LoanAmount'] as double,
      eligibleLoanProductCode: json['EligibleLoanProductCode'] as String,
      savingsAccNo: json['SavingsAccNo'] as String,
      loanMemberType: json['LoanMemberType'] as String,
      loanAmountRules: json['LoanAmountRules'] as String,
      isTopUpEligible: json['IsTopUpEligible'] as bool,
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
