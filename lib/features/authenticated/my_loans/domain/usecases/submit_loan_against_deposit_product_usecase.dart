import 'package:pashboi/core/requests/base_request_props.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/product_loan_collateral_account_entity.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/repositories/loan_repository.dart';

class SubmitLoanAgainstDepositProductProps extends BaseRequestProps {
  final List<ProductLoanCollectionAccountEntity> collateralAccounts;
  final String loanProductCode;
  final double maximumLoanAmount;
  final double interestRate;
  final String numberOfInstallment;
  final double totalApplyLoan;
  final String secretKey;
  final String cardNo;
  final String nameOnCard;
  final String accountNo;
  final String oTPRegId;
  final String oTPValue;

  const SubmitLoanAgainstDepositProductProps({
    required super.email,
    required super.userId,
    required super.rolePermissionId,
    required super.personId,
    required super.employeeCode,
    required super.mobileNumber,
    required this.secretKey,
    required this.cardNo,
    required this.collateralAccounts,
    required this.loanProductCode,
    required this.maximumLoanAmount,
    required this.interestRate,
    required this.numberOfInstallment,
    required this.totalApplyLoan,
    required this.nameOnCard,
    required this.accountNo,
    required this.oTPRegId,
    required this.oTPValue,
  });
}

class SubmitLoanAgainstDepositProductUseCase
    extends UseCase<String, SubmitLoanAgainstDepositProductProps> {
  final LoanRepository loanRepository;

  SubmitLoanAgainstDepositProductUseCase({required this.loanRepository});

  @override
  ResultFuture<String> call(SubmitLoanAgainstDepositProductProps props) async {
    return loanRepository.submitLoanAgainstDepositProduct(props);
  }
}
