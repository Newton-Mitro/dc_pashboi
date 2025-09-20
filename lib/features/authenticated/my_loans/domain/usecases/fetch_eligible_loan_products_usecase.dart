import 'package:pashboi/core/requests/base_request_props.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/loan_product_entity.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/repositories/loan_repository.dart';

class FetchEligibleLoanProductsProps extends BaseRequestProps {
  final String otherField;

  const FetchEligibleLoanProductsProps({
    required this.otherField,
    required super.email,
    required super.userId,
    required super.rolePermissionId,
    required super.personId,
    required super.employeeCode,
    required super.mobileNumber,
  });
}

class FetchEligibleLoanProductsUseCase
    extends UseCase<List<LoanProductEntity>, FetchEligibleLoanProductsProps> {
  final LoanRepository loanRepository;

  FetchEligibleLoanProductsUseCase({required this.loanRepository});

  @override
  ResultFuture<List<LoanProductEntity>> call(
    FetchEligibleLoanProductsProps props,
  ) async {
    return loanRepository.fetchEligibleLoanProducts(props);
  }
}
