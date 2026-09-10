part of 'notice_bloc.dart';

sealed class NoticeState extends Equatable {
  const NoticeState();

  @override
  List<Object?> get props => [];
}

final class NoticeInitial extends NoticeState {
  const NoticeInitial();
}

final class NoticeLoading extends NoticeState {
  const NoticeLoading();
}

final class NoticeSuccess extends NoticeState {
  final List<NoticeEntity> notices;
  const NoticeSuccess({required this.notices});

  @override
  List<Object?> get props => [notices];
}

final class NoticeError extends NoticeState {
  final String error;

  const NoticeError({required this.error});

  @override
  List<Object?> get props => [error];
}
