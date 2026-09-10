part of 'notice_bloc.dart';

sealed class NoticeEvent extends Equatable {
  const NoticeEvent();

  @override
  List<Object?> get props => [];
}

class FetchNoticeEvent extends NoticeEvent {
  const FetchNoticeEvent();
}
