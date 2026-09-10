part of 'page_bloc.dart';

sealed class PageState extends Equatable {
  const PageState();

  @override
  List<Object?> get props => [];
}

final class PageInitial extends PageState {
  const PageInitial();
}

final class PageLoading extends PageState {
  const PageLoading();
}

final class PageSuccess extends PageState {
  final pageData;

  const PageSuccess({required this.pageData});

  @override
  List<Object?> get props => [pageData];
}

final class PageError extends PageState {
  final String error;
  const PageError({required this.error});

  @override
  List<Object?> get props => [error];
}
