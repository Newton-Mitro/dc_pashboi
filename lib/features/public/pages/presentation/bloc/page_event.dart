part of 'page_bloc.dart';

sealed class PageEvent extends Equatable {
  const PageEvent();

  @override
  List<Object?> get props => [];
}

class FetchPageEvent extends PageEvent {
  final PageProps pageProps;

  const FetchPageEvent(this.pageProps);

  @override
  List<Object?> get props => [pageProps];
}
