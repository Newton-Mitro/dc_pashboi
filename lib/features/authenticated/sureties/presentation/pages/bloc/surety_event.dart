part of 'surety_bloc.dart';

sealed class SuretyEvent extends Equatable {
  const SuretyEvent();

  @override
  List<Object?> get props => [];
}

final class FetchLoanSuretiesEvent extends SuretyEvent {
  final String loanNumber;

  const FetchLoanSuretiesEvent({required this.loanNumber});

  @override
  List<Object?> get props => [loanNumber];
}

final class FetchGivenSuretiesEvent extends SuretyEvent {
  const FetchGivenSuretiesEvent();
}
