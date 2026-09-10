part of 'add_beneficiary_bloc.dart';

sealed class AddBeneficiaryEvent extends Equatable {
  const AddBeneficiaryEvent();

  @override
  List<Object?> get props => [];
}

class AddBeneficiarySubmit extends AddBeneficiaryEvent {
  final String beneficiaryName;
  final String accountNumber;

  const AddBeneficiarySubmit({
    required this.beneficiaryName,
    required this.accountNumber,
  });

  @override
  List<Object?> get props => [beneficiaryName, accountNumber];
}
