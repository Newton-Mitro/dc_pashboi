import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/entities/user_entity.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/transfer/domain/usecases/fetch_transfer_account_usecase.dart';
part 'transfer_search_account_event.dart';
part 'transfer_search_account_state.dart';

class TransferSearchAccountBloc
    extends Bloc<TransferSearchAccountEvent, TransferSearchAccountState> {
  final GetAuthUserUseCase getAuthUserUseCase;
  final FetchTransferAccountUseCase fetchTransferAccountUseCase;
  TransferSearchAccountBloc({
    required this.fetchTransferAccountUseCase,
    required this.getAuthUserUseCase,
  }) : super(TransferSearchAccountInitial()) {
    on<FetchTransferSearchAccountEvent>(_onTransferSearchAccount);
  }

  Future<void> _onTransferSearchAccount(
    FetchTransferSearchAccountEvent event,
    Emitter<TransferSearchAccountState> emit,
  ) async {
    final searchText = event.searchText.trim();

    if (searchText.isEmpty) {
      emit(
        const TransferSearchAccountValidationError({
          'searchText': 'Please enter account number',
        }),
      );
      return;
    }
    emit(TransferSearchAccountLoading());
    try {
      final authUser = await getAuthUserUseCase.call(NoParams());

      UserEntity? user;
      authUser.fold(
        (failure) =>
            emit(TransferSearchAccountError('Failed to load user information')),
        (success) => user = success.user,
      );

      if (user == null) return;

      final result = await fetchTransferAccountUseCase.call(
        FetchTransferAccountProps(
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
        (failure) => emit(TransferSearchAccountError(failure.message)),
        (data) => emit(TransferSearchAccountLoaded(data.toString())),
      );
    } catch (e) {
      emit(TransferSearchAccountError('Failed to load collection ledgers'));
    }
  }
}
