part of 'authenticated_home_bloc.dart';

sealed class AuthenticatedHomeState extends Equatable {
  const AuthenticatedHomeState();

  @override
  List<Object?> get props => [];
}

class AuthenticatedHomeInitial extends AuthenticatedHomeState {
  final int selectedPage;
  const AuthenticatedHomeInitial({this.selectedPage = 0});

  @override
  List<Object?> get props => [selectedPage];
}

final class AuthLoading extends AuthenticatedHomeState {
  const AuthLoading();
}

class PageChangedState extends AuthenticatedHomeState {
  final int selectedPage;
  const PageChangedState(this.selectedPage);

  PageChangedState copyWith({int? selectedPage}) {
    return PageChangedState(selectedPage ?? this.selectedPage);
  }

  @override
  List<Object?> get props => [selectedPage];
}
