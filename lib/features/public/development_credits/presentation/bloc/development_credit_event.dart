part of 'development_credit_bloc.dart';

sealed class DevelopmentCreditEvent extends Equatable {
  const DevelopmentCreditEvent();

  @override
  List<Object?> get props => [];
}

class FetchDevelopmentCreditEvent extends DevelopmentCreditEvent {
  const FetchDevelopmentCreditEvent();
}
