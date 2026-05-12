import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/features/my_app/domain/usecases/fetch_app_status_usecase.dart';

part 'my_app_event.dart';
part 'my_app_state.dart';

class AppStatusBloc extends Bloc<AppStatusEvent, AppStatusState> {
  final FetchAppStatusUseCase fetchAppStatusUseCase;

  AppStatusBloc(this.fetchAppStatusUseCase) : super(AppStatusInitial()) {
    on<FetchAppStatusEvent>((event, emit) async {
      emit(AppStatusLoading());

      final result = await fetchAppStatusUseCase.call(
        FetchAppStatusPrams(version: 63),
      );

      result.fold((failure) => emit(AppStatusError(failure.message)), (status) {
        if (status.isMaintenance == true) {
          emit(UnderMaintenance(status.maintenanceMessage));
        } else if (status.isUpdated == false) {
          emit(NewVersionAvailable(status.updateMessage));
        } else {
          emit(const AppIsHealthy());
        }
      });
    });
  }
}
