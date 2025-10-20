part of 'product_loan_collection_account_bloc.dart';

sealed class ProductLoanCollectionAccountState extends Equatable {
  const ProductLoanCollectionAccountState();

  @override
  List<Object> get props => [];
}

final class ProductLoanCollectionAccountInitial
    extends ProductLoanCollectionAccountState {
  const ProductLoanCollectionAccountInitial();
}

final class ProductLoanCollectionAccountLoading
    extends ProductLoanCollectionAccountState {
  const ProductLoanCollectionAccountLoading();
}

final class ProductLoanCollectionAccountSuccess
    extends ProductLoanCollectionAccountState {
  final ProductLoanEligibleCollateralAccountDto
  productLoanEligibleCollateralAccountDto;

  const ProductLoanCollectionAccountSuccess(
    this.productLoanEligibleCollateralAccountDto,
  );

  @override
  List<Object> get props => [productLoanEligibleCollateralAccountDto];
}

final class ProductLoanCollectionAccountError
    extends ProductLoanCollectionAccountState {
  final String message;

  const ProductLoanCollectionAccountError(this.message);

  @override
  List<Object> get props => [message];
}
