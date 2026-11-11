import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/entities/deposit_account_entity.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/repositories/deposit_account_repository.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/usecases/get_my_accounts_usecase.dart';

class _MockRepository extends Mock implements DepositAccountRepository {}

void main() {
  test(
    'forwards the requested account holder and returns repository result',
    () async {
      final repository = _MockRepository();
      final useCase = GetMyAccountsUseCase(
        depositAccountRepository: repository,
      );
      final props = GetMyAccountsProps(
        email: 'member@example.com',
        userId: 1,
        rolePermissionId: 'role-1',
        personId: 2,
        employeeCode: 'EMP-1',
        mobileNumber: '01700000000',
        accountHolderPersonId: 3,
      );
      final accounts = <DepositAccountEntity>[];
      when(() => repository.getMyAccounts(props)).thenAnswer(
        (_) async => Right<Failure, List<DepositAccountEntity>>(accounts),
      );

      final result = await useCase.call(props);

      expect(result, Right<Failure, List<DepositAccountEntity>>(accounts));
      verify(() => repository.getMyAccounts(props)).called(1);
    },
  );
}
