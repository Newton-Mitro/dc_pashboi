import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/entities/user_entity.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/domain/entities/collection_aggregate.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/domain/usecases/fetch_collection_ledgers_usecase.dart';

part 'collection_ledger_event.dart';
part 'collection_ledger_state.dart';

class CollectionLedgerBloc
    extends Bloc<CollectionLedgerEvent, CollectionLedgerState> {
  final FetchCollectionLedgersUseCase fetchCollectionLedgersUseCase;
  final GetAuthUserUseCase getAuthUserUseCase;
  final AppLocalizationService appLocalizationService;

  CollectionLedgerBloc({
    required this.fetchCollectionLedgersUseCase,
    required this.getAuthUserUseCase,
    required this.appLocalizationService,
  }) : super(CollectionLedgerInitial()) {
    on<FetchCollectionLedgersEvent>(_onFetchCollectionLedgers);
  }

  Future<void> _onFetchCollectionLedgers(
    FetchCollectionLedgersEvent event,
    Emitter<CollectionLedgerState> emit,
  ) async {
    final searchText = event.searchText.trim();

    if (searchText.isEmpty) {
      emit(
        const CollectionLedgerValidationError({
          'searchText': 'Please enter account number',
        }),
      );
      return;
    }

    emit(CollectionLedgerLoading());

    try {
      final authUser = await getAuthUserUseCase.call(NoParams());

      UserEntity? user;
      authUser.fold(
        (failure) => emit(
          CollectionLedgerError(
            appLocalizationService.t('failed_to_load_user_info'),
          ),
        ),
        (success) => user = success.user,
      );

      if (user == null) return;

      final result = await fetchCollectionLedgersUseCase.call(
        FetchCollectionLedgersProps(
          email: user!.loginEmail,
          userId: user!.userId,
          rolePermissionId: user!.roleId,
          personId: user!.personId,
          employeeCode: user!.employeeCode,
          mobileNumber: user!.regMobile,
          searchText: searchText,
          moduleCode: event.moduleCode,
        ),
      );

      result.fold(
        (failure) => emit(CollectionLedgerError(failure.message)),
        (ledgers) => emit(CollectionLedgerLoaded(ledgers)),
      );
    } catch (e) {
      emit(CollectionLedgerError('Failed to load collection ledgers'));
    }
  }
}
