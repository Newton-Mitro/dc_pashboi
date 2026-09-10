part of 'add_family_and_relative_bloc.dart';

sealed class AddFamilyAndRelativeEvent extends Equatable {
  const AddFamilyAndRelativeEvent();

  @override
  List<Object?> get props => [];
}

class AddFamilyAndRelativeSubmitted extends AddFamilyAndRelativeEvent {
  final int childPersonId;
  final String relationTypeCode;
  final String searchAccountNumber;

  const AddFamilyAndRelativeSubmitted({
    required this.childPersonId,
    required this.relationTypeCode,
    required this.searchAccountNumber,
  });

  @override
  List<Object?> get props => [
    childPersonId,
    relationTypeCode,
    searchAccountNumber,
  ];
}
