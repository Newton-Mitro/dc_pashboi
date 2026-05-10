import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/entities/user_entity.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/beneficiaries/domain/usecases/add_beneficiary_usecase.dart';

part 'add_beneficiary_event.dart';
part 'add_beneficiary_state.dart';

class AddBeneficiaryBloc
    extends Bloc<AddBeneficiaryEvent, AddBeneficiaryState> {
  final GetAuthUserUseCase getAuthUserUseCase;
  final AddBeneficiaryUseCase addBeneficiaryUseCase;
  final AppLocalizationService appLocalizationService;

  AddBeneficiaryBloc({
    required this.getAuthUserUseCase,
    required this.addBeneficiaryUseCase,
    required this.appLocalizationService,
  }) : super(AddBeneficiaryInitial()) {
    on<AddBeneficiarySubmit>(_onSubmitAddBeneficiary);
  }

  Future<UserEntity?> _getAuthenticatedUser(
    Emitter<AddBeneficiaryState> emit,
  ) async {
    final authUser = await getAuthUserUseCase(NoParams());
    return authUser.fold((failure) {
      final message = appLocalizationService.t('failed_to_load_user_info');
      emit(AddBeneficiaryFailure(message));
      return null;
    }, (success) => success.user);
  }

  Future<void> _onSubmitAddBeneficiary(
    AddBeneficiarySubmit event,
    Emitter<AddBeneficiaryState> emit,
  ) async {
    final errors = <String, String>{};

    if (event.beneficiaryName.trim().isEmpty) {
      errors['beneficiaryName'] = appLocalizationService.t(
        'please_enter_beneficiary_name',
      );
    }

    if (event.accountNumber.trim().isEmpty) {
      errors['accountNumber'] = appLocalizationService.t(
        'please_enter_account_number',
      );
    }

    if (errors.isNotEmpty) {
      emit(AddBeneficiaryValidationError(errors));
      return;
    }

    emit(const AddBeneficiaryLoading());

    try {
      final user = await _getAuthenticatedUser(emit);
      if (user == null) return;

      final result = await addBeneficiaryUseCase.call(
        AddBeneficiaryProps(
          email: user.loginEmail,
          userId: user.userId,
          rolePermissionId: user.roleId,
          personId: user.personId,
          employeeCode: user.employeeCode,
          mobileNumber: user.regMobile,
          beneficiaryAccountNumber: event.accountNumber,
          beneficiaryName: event.beneficiaryName,
        ),
      );

      result.fold(
        (failure) => emit(AddBeneficiaryFailure(failure.message)),
        (_) => emit(const AddBeneficiarySuccess()),
      );
    } catch (e) {
      emit(AddBeneficiaryFailure(e.toString()));
    }
  }
}
