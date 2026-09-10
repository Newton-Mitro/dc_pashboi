part of 'add_beneficiary_bloc.dart';

sealed class AddBeneficiaryState extends Equatable {
  const AddBeneficiaryState();

  @override
  List<Object?> get props => [];
}

final class AddBeneficiaryInitial extends AddBeneficiaryState {
  const AddBeneficiaryInitial();
}

class AddBeneficiaryLoading extends AddBeneficiaryState {
  const AddBeneficiaryLoading();
}

class AddBeneficiarySuccess extends AddBeneficiaryState {
  const AddBeneficiarySuccess();
}

class AddBeneficiaryFailure extends AddBeneficiaryState {
  final String error;

  const AddBeneficiaryFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class AddBeneficiaryValidationError extends AddBeneficiaryState {
  final Map<String, String> errors;

  const AddBeneficiaryValidationError(this.errors);

  @override
  List<Object?> get props => [errors];
}
