import 'package:pashboi/core/entities/entity.dart';

class EligibleConditionsEntity extends Entity<int> {
  final String itemName;
  final bool isEligibile;
  final double itemValue;
  final double loaneeValue;
  final double loanAmount;
  final String savingsAccNo;
  final String loanMemberType;
  final String loanAmountRules;
  final bool isTopUpEligible;

  EligibleConditionsEntity({
    required super.id,
    required this.itemName,
    required this.isEligibile,
    required this.itemValue,
    required this.loaneeValue,
    required this.loanAmount,
    required this.savingsAccNo,
    required this.loanMemberType,
    required this.loanAmountRules,
    required this.isTopUpEligible,
  });

  @override
  List<Object?> get props => [
    id,
    itemName,
    isEligibile,
    itemValue,
    loaneeValue,
    loanAmount,
    savingsAccNo,
    loanMemberType,
    loanAmountRules,
    isTopUpEligible,
  ];
}
