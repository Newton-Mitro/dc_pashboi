part of 'family_and_relatives_bloc.dart';

sealed class FamilyAndRelativesEvent extends Equatable {
  const FamilyAndRelativesEvent();

  @override
  List<Object?> get props => [];
}

class FetchFamilyAndRelatives extends FamilyAndRelativesEvent {
  const FetchFamilyAndRelatives();
}
