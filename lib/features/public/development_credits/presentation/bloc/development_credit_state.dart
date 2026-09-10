part of 'development_credit_bloc.dart';

sealed class DevelopmentCreditState extends Equatable {
  const DevelopmentCreditState();

  @override
  List<Object?> get props => [];
}

final class DevelopmentCreditInitial extends DevelopmentCreditState {
  const DevelopmentCreditInitial();
}

final class DevelopmentCreditLoading extends DevelopmentCreditState {
  const DevelopmentCreditLoading();
}

final class DevelopmentCreditSuccess extends DevelopmentCreditState {
  final List<DevelopmentCreditsEntity> developmentCredit;
  const DevelopmentCreditSuccess({required this.developmentCredit});

  @override
  List<Object?> get props => [developmentCredit];
}

final class DevelopmentCreditError extends DevelopmentCreditState {
  final String error;

  const DevelopmentCreditError({required this.error});

  @override
  List<Object?> get props => [error];
}
