import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/entities/user_entity.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/beneficiaries/domain/entities/beneficiary_entity.dart';
import 'package:pashboi/features/authenticated/beneficiaries/domain/usecases/fetch_beneficiaries_usecase.dart';
import 'package:pashboi/features/authenticated/beneficiaries/domain/usecases/remove_beneficiary_usecase.dart';

part 'beneficiaries_event.dart';
part 'beneficiaries_state.dart';

class BeneficiariesBloc extends Bloc<BeneficiariesEvent, BeneficiariesState> {
  final FetchBeneficiariesUseCase fetchBeneficiariesUseCase;
  final GetAuthUserUseCase getAuthUserUseCase;
  final RemoveBeneficiaryUseCase removeBeneficiaryUseCase;
  final AppLocalizationService appLocalizationService;

  BeneficiariesBloc({
    required this.fetchBeneficiariesUseCase,
    required this.getAuthUserUseCase,
    required this.removeBeneficiaryUseCase,
    required this.appLocalizationService,
  }) : super(const BeneficiariesInitial()) {
    on<FetchBeneficiaries>(_onFetchBeneficiaries);
    on<DeleteBeneficiary>(_onDeleteBeneficiary);
  }

  Future<UserEntity?> _getAuthenticatedUser(
    Emitter<BeneficiariesState> emit,
  ) async {
    final authUser = await getAuthUserUseCase(NoParams());
    return authUser.fold((failure) {
      emit(const BeneficiariesError('Failed to load user information'));
      return null;
    }, (success) => success.user);
  }

  Future<void> _onFetchBeneficiaries(
    FetchBeneficiaries event,
    Emitter<BeneficiariesState> emit,
  ) async {
    emit(const BeneficiariesLoading());

    final user = await _getAuthenticatedUser(emit);
    if (user == null) return;

    final result = await fetchBeneficiariesUseCase.call(
      FetchBeneficiariesProps(
        email: user.loginEmail,
        userId: user.userId,
        rolePermissionId: user.roleId,
        personId: user.personId,
        employeeCode: user.employeeCode,
        mobileNumber: user.regMobile,
      ),
    );

    result.fold(
      (failure) => emit(BeneficiariesError(failure.message)),
      (beneficiaries) => emit(BeneficiariesLoaded(beneficiaries)),
    );
  }

  Future<void> _onDeleteBeneficiary(
    DeleteBeneficiary event,
    Emitter<BeneficiariesState> emit,
  ) async {
    emit(const BeneficiariesLoading());

    final user = await _getAuthenticatedUser(emit);
    if (user == null) return;

    final result = await removeBeneficiaryUseCase.call(
      RemoveBeneficiaryProps(
        email: user.loginEmail,
        userId: user.userId,
        rolePermissionId: user.roleId,
        personId: user.personId,
        employeeCode: user.employeeCode,
        mobileNumber: user.regMobile,
        beneficiaryAccountNumber: event.accountNumber,
      ),
    );

    await result.fold(
      (failure) async {
        emit(BeneficiariesError(failure.message));
      },
      (_) async {
        emit(const BeneficiariesSuccess());

        // After success, immediately fetch the updated beneficiaries list
        add(FetchBeneficiaries());
      },
    );
  }
}
