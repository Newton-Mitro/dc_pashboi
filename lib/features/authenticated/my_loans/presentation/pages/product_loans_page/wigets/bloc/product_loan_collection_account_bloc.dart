import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/product_loan_collateral_accounts_dto.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/fetch_product_loan_collateral%20_account_usecase.dart';

part 'product_loan_collection_account_event.dart';
part 'product_loan_collection_account_state.dart';

class ProductLoanCollectionAccountBloc
    extends
        Bloc<
          ProductLoanCollectionAccountEvent,
          ProductLoanCollectionAccountState
        > {
  final GetAuthUserUseCase getAuthUserUseCase;
  final FetchProductLoanCollateralAccountUseCase
  fetchProductLoanCollateralAccountUseCase;
  final AppLocalizationService appLocalizationService;

  ProductLoanCollectionAccountBloc({
    required this.getAuthUserUseCase,
    required this.fetchProductLoanCollateralAccountUseCase,
    required this.appLocalizationService,
  }) : super(ProductLoanCollectionAccountInitial()) {
    on<FetchProductLoanCollectionAccountEvent>(
      _onFetchProductLoanCollectionAccountEvent,
    );
  }

  Future<void> _onFetchProductLoanCollectionAccountEvent(
    FetchProductLoanCollectionAccountEvent event,
    Emitter<ProductLoanCollectionAccountState> emit,
  ) async {
    emit(const ProductLoanCollectionAccountLoading());

    final userResult = await getAuthUserUseCase.call(NoParams());

    await userResult.fold(
      (failure) async {
        emit(ProductLoanCollectionAccountError(failure.message));
      },
      (authData) async {
        final user = authData.user;
        final productLoanCollectionAccountResult =
            await fetchProductLoanCollateralAccountUseCase.call(
              FetchProductLoanCollateralAccountProps(
                email: user.loginEmail,
                userId: user.userId,
                rolePermissionId: user.roleId,
                personId: user.personId,
                employeeCode: user.employeeCode,
                mobileNumber: user.regMobile,
                productCode: event.productCode,
              ),
            );

        productLoanCollectionAccountResult.fold(
          (failure) {
            emit(ProductLoanCollectionAccountError(failure.message));
          },
          (productLoanCollectionAccountResult) {
            emit(
              ProductLoanCollectionAccountSuccess(
                productLoanCollectionAccountResult,
              ),
            );
          },
        );
      },
    );
  }
}
