import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/features/authenticated/cards/domain/entities/debit_card_entity.dart';
import 'package:pashboi/features/authenticated/cards/domain/repositories/card_repository.dart';
import 'package:pashboi/features/authenticated/cards/domain/usecases/get_my_card_usecase.dart';
import 'package:pashboi/features/authenticated/cards/domain/usecases/issue_debit_card_usecase.dart';
import 'package:pashboi/features/authenticated/cards/domain/usecases/lock_the_card_usecase.dart';
import 'package:pashboi/features/authenticated/cards/domain/usecases/re_issue_debit_card_usecase.dart';
import 'package:pashboi/features/authenticated/cards/domain/usecases/verify_card_pin_usecase.dart';

class _MockCardRepository extends Mock implements CardRepository {}

void main() {
  late _MockCardRepository repository;

  setUp(() {
    repository = _MockCardRepository();
  });

  const baseProps = GetMyCardUseCaseProps(
    email: 'member@example.com',
    userId: 7,
    rolePermissionId: 'role-1',
    personId: 3,
    employeeCode: 'EMP-3',
    mobileNumber: '01700000000',
  );

  test('GetMyCardUseCase delegates and returns the card', () async {
    final card = DebitCardEntity(
      id: 4,
      cardsAccounts: const [],
      isActive: true,
      nameOnCard: 'Member',
      cardNumber: '1111222233334444',
      type: 'Debit',
      expiryDate: '30/06/2028',
      isVirtual: false,
      isBlock: false,
      stageCode: 'ACTIVE',
      stageName: 'Active',
    );
    when(
      () => repository.getMyCard(baseProps),
    ).thenAnswer((_) async => Right<Failure, DebitCardEntity>(card));

    final result = await GetMyCardUseCase(
      cardRepository: repository,
    ).call(baseProps);

    expect(result, Right<Failure, DebitCardEntity>(card));
    verify(() => repository.getMyCard(baseProps)).called(1);
  });

  test('IssueDebitCardUseCase forwards the issue request', () async {
    const props = IssueDebitCardUseCaseProps(
      email: 'member@example.com',
      userId: 7,
      rolePermissionId: 'role-1',
      personId: 3,
      employeeCode: 'EMP-3',
      mobileNumber: '01700000000',
      cardTypeCode: 'VISA',
      withCard: true,
    );
    when(
      () => repository.issueDebitCard(props),
    ).thenAnswer((_) async => const Right<Failure, String>('issued'));

    final result = await IssueDebitCardUseCase(
      cardRepository: repository,
    ).call(props);

    expect(result, const Right<Failure, String>('issued'));
    verify(() => repository.issueDebitCard(props)).called(1);
  });

  test('ReIssueDebitCardUsecase forwards card details', () async {
    const props = ReIssueDebitCardUsecaseProps(
      email: 'member@example.com',
      userId: 7,
      rolePermissionId: 'role-1',
      personId: 3,
      employeeCode: 'EMP-3',
      mobileNumber: '01700000000',
      cardNumber: '1111222233334444',
      cardTypeCode: 'VISA',
      virtualCard: true,
      nameOnCard: 'Member',
    );
    when(
      () => repository.reIssueDebitCard(props),
    ).thenAnswer((_) async => const Right<Failure, String>('re-issued'));

    final result = await ReIssueDebitCardUsecase(
      cardRepository: repository,
    ).call(props);

    expect(result, const Right<Failure, String>('re-issued'));
    verify(() => repository.reIssueDebitCard(props)).called(1);
  });

  test('LockTheCardUseCase forwards lock details', () async {
    const props = LockTheCardUseCaseProps(
      email: 'member@example.com',
      userId: 7,
      rolePermissionId: 'role-1',
      personId: 3,
      employeeCode: 'EMP-3',
      mobileNumber: '01700000000',
      cardNumber: '1111222233334444',
      accountNumber: 'SA-1',
      nameOnCard: 'Member',
    );
    when(
      () => repository.lockTheCard(props),
    ).thenAnswer((_) async => const Right<Failure, String>('blocked'));

    final result = await LockTheCardUseCase(
      cardRepository: repository,
    ).call(props);

    expect(result, const Right<Failure, String>('blocked'));
    verify(() => repository.lockTheCard(props)).called(1);
  });

  test('VerifyCardPinUseCase forwards PIN verification details', () async {
    const props = VerifyCardPinUseCaseProps(
      email: 'member@example.com',
      userId: 7,
      rolePermissionId: 'role-1',
      personId: 3,
      employeeCode: 'EMP-3',
      mobileNumber: '01700000000',
      cardNumber: '1111222233334444',
      nameOnCard: 'Member',
      cardPIN: 'secret-hash',
      accountNumber: 'SA-1',
    );
    when(
      () => repository.verifyCardPIN(props),
    ).thenAnswer((_) async => const Right<Failure, String>('otp-reg-id'));

    final result = await VerifyCardPinUseCase(
      cardRepository: repository,
    ).call(props);

    expect(result, const Right<Failure, String>('otp-reg-id'));
    verify(() => repository.verifyCardPIN(props)).called(1);
  });
}
