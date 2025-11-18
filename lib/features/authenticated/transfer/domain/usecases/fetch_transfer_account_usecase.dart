import 'package:pashboi/core/requests/base_request_props.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/authenticated/transfer/domain/repositories/transfer_repository.dart';

class FetchTransferAccountProps extends BaseRequestProps {
  final String searchText;
  final String moduleCode;

  const FetchTransferAccountProps({
    required this.searchText,
    required this.moduleCode,
    required super.email,
    required super.userId,
    required super.rolePermissionId,
    required super.personId,
    required super.employeeCode,
    required super.mobileNumber,
  });
}

class FetchTransferAccountUseCase
    extends UseCase<String, FetchTransferAccountProps> {
  final TransferRepository transferRepository;

  FetchTransferAccountUseCase({required this.transferRepository});

  @override
  ResultFuture<String> call(FetchTransferAccountProps props) async {
    return transferRepository.fetchTransferAccount(props);
  }
}
