part of 'my_loans_bloc.dart';

sealed class MyLoansEvent extends Equatable {
  const MyLoansEvent();

  @override
  List<Object?> get props => [];
}

class FetchMyLoansEvent extends MyLoansEvent {
  const FetchMyLoansEvent();
}
