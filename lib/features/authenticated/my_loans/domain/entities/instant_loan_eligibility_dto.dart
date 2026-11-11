import 'package:equatable/equatable.dart';

class InstantLoanEligibilityDTO extends Equatable {
  final String eligibilityMessage;
  final List<dynamic> eligibleConditions;

  const InstantLoanEligibilityDTO({
    required this.eligibilityMessage,
    required this.eligibleConditions,
  });

  @override
  List<Object?> get props => [eligibilityMessage, eligibleConditions];
}
