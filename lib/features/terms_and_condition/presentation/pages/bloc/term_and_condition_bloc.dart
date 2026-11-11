import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/features/terms_and_condition/domain/usecases/fetch_term_and_condition_usecase.dart';

part 'term_and_condition_event.dart';
part 'term_and_condition_state.dart';

class TermAndConditionBloc
    extends Bloc<TermAndConditionEvent, TermAndConditionState> {
  final FetchTermAndConditionUseCase fetchTermAndConditionUseCase;

  TermAndConditionBloc({
    required this.fetchTermAndConditionUseCase,
  }) : super(TermAndConditionInitial()) {
    on<FetchTermAndConditionEvent>(_onFetchTermAndConditionEvent);
  }

  Future<void> _onFetchTermAndConditionEvent(
    FetchTermAndConditionEvent event,
    Emitter<TermAndConditionState> emit,
  ) async {
    emit(TermAndConditionLoading());

    final result = await fetchTermAndConditionUseCase.call(
      FetchTermAndConditionProps(contentName: event.contentName),
    );

    result.fold(
      (failure) => emit(TermAndConditionError(message: failure.message)),
      (content) => emit(TermAndConditionLoaded(content: content)),
    );
  }
}
