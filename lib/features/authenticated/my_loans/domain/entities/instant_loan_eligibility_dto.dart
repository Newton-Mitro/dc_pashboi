class InstantLoanEligibilityDTO {
  final String eligibilityMessage;
  final List<dynamic> eligibleConditions;

  InstantLoanEligibilityDTO({
    required this.eligibilityMessage,
    required this.eligibleConditions,
  });

  @override
  List<Object?> get props => [eligibilityMessage, eligibleConditions];
}
