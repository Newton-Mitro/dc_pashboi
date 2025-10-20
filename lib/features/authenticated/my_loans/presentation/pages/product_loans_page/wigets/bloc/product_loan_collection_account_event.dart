part of 'product_loan_collection_account_bloc.dart';

sealed class ProductLoanCollectionAccountEvent extends Equatable {
  const ProductLoanCollectionAccountEvent();

  @override
  List<Object> get props => [];
}

class FetchProductLoanCollectionAccountEvent
    extends ProductLoanCollectionAccountEvent {
  final String productCode;

  const FetchProductLoanCollectionAccountEvent(this.productCode);

  @override
  List<Object> get props => [productCode];
}
