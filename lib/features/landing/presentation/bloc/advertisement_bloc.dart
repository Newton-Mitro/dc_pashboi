import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/my_app/domain/entities/advertisement_entity.dart';
import 'package:pashboi/features/my_app/domain/usecases/fetch_advertisement_usecase.dart';

part 'advertisement_event.dart';
part 'advertisement_state.dart';

class AdvertisementBloc extends Bloc<AdvertisementEvent, AdvertisementState> {
  final FetchAdvertisementUseCase fetchAdvertisementUseCase;

  AdvertisementBloc(this.fetchAdvertisementUseCase)
    : super(AdvertisementInitial()) {
    on<FetchAdvertisementEvent>((event, emit) async {
      emit(AdvertisementLoading());

      final result = await fetchAdvertisementUseCase.call(NoParams());

      result.fold(
        (failure) => emit(AdvertisementError(error: failure.message)),
        (data) {
          emit(AdvertisementLoaded(advertisements: [...data]));
        },
      );
    });
  }
}
