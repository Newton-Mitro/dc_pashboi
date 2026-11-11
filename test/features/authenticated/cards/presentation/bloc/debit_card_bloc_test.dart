import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:crypto/crypto.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/entities/auth_user_entity.dart';
import 'package:pashboi/features/auth/domain/entities/user_entity.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/cards/domain/usecases/get_my_card_usecase.dart';
import 'package:pashboi/features/authenticated/cards/domain/usecases/issue_debit_card_usecase.dart';
import 'package:pashboi/features/authenticated/cards/domain/usecases/lock_the_card_usecase.dart';
import 'package:pashboi/features/authenticated/cards/domain/usecases/re_issue_debit_card_usecase.dart';
import 'package:pashboi/features/authenticated/cards/domain/usecases/verify_card_pin_usecase.dart';
import 'package:pashboi/features/authenticated/cards/presentation/pages/bloc/debit_card_bloc.dart';

class _MockGetAuthUserUseCase extends Mock implements GetAuthUserUseCase {}

class _MockGetMyCardUseCase extends Mock implements GetMyCardUseCase {}

class _MockIssueDebitCardUseCase extends Mock
    implements IssueDebitCardUseCase {}

class _MockReIssueDebitCardUsecase extends Mock
    implements ReIssueDebitCardUsecase {}

class _MockLockTheCardUseCase extends Mock implements LockTheCardUseCase {}

class _MockVerifyCardPinUseCase extends Mock implements VerifyCardPinUseCase {}

class _MockLocalizationService extends Mock implements AppLocalizationService {}

void main() {
  late _MockGetAuthUserUseCase getAuthUserUseCase;
  late _MockGetMyCardUseCase getMyCardUseCase;
  late _MockIssueDebitCardUseCase issueDebitCardUseCase;
  late _MockReIssueDebitCardUsecase reIssueDebitCardUsecase;
  late _MockLockTheCardUseCase lockTheCardUseCase;
  late _MockVerifyCardPinUseCase verifyCardPinUseCase;
  late _MockLocalizationService localizationService;

  final user = UserEntity(
    userId: 7,
    personId: 3,
    loginEmail: 'member@example.com',
    roleId: 'role-1',
    roleName: 'Member',
    userName: 'Member',
    branchCode: '01',
    regMobile: '01700000000',
    address: '',
    organizationCode: '',
    deviceId: 1,
    employeeCode: 'EMP-3',
    isNewMenu: false,
    rolePermissions: const [],
  );
  final authUser = AuthUserEntity(
    accessToken: 'access-token',
    refreshToken: 'refresh-token',
    user: user,
  );

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(
      const IssueDebitCardUseCaseProps(
        email: '',
        userId: 0,
        rolePermissionId: '',
        personId: 0,
        employeeCode: '',
        mobileNumber: '',
        cardTypeCode: '',
        withCard: false,
      ),
    );
    registerFallbackValue(
      const VerifyCardPinUseCaseProps(
        email: '',
        userId: 0,
        rolePermissionId: '',
        personId: 0,
        employeeCode: '',
        mobileNumber: '',
        cardNumber: '',
        nameOnCard: '',
        cardPIN: '',
        accountNumber: '',
      ),
    );
  });

  setUp(() {
    getAuthUserUseCase = _MockGetAuthUserUseCase();
    getMyCardUseCase = _MockGetMyCardUseCase();
    issueDebitCardUseCase = _MockIssueDebitCardUseCase();
    reIssueDebitCardUsecase = _MockReIssueDebitCardUsecase();
    lockTheCardUseCase = _MockLockTheCardUseCase();
    verifyCardPinUseCase = _MockVerifyCardPinUseCase();
    localizationService = _MockLocalizationService();
    when(() => localizationService.t(any())).thenAnswer(
      (invocation) => invocation.positionalArguments.single as String,
    );
  });

  DebitCardBloc createBloc() => DebitCardBloc(
    getMyCardUseCase: getMyCardUseCase,
    issueDebitCardUseCase: issueDebitCardUseCase,
    reIssueDebitCardUsecase: reIssueDebitCardUsecase,
    lockTheCardUseCase: lockTheCardUseCase,
    verifyCardPinUseCase: verifyCardPinUseCase,
    getAuthUserUseCase: getAuthUserUseCase,
    appLocalizationService: localizationService,
  );

  blocTest<DebitCardBloc, DebitCardState>(
    'issues a card and emits a success state',
    setUp: () {
      when(
        () => getAuthUserUseCase.call(any()),
      ).thenAnswer((_) async => Right<Failure, AuthUserEntity>(authUser));
      when(
        () => issueDebitCardUseCase.call(any()),
      ).thenAnswer((_) async => const Right<Failure, String>('received'));
    },
    build: createBloc,
    act:
        (bloc) => bloc.add(
          const DebitCardIssue(cardTypeCode: 'VISA', withCard: true),
        ),
    expect:
        () => [
          isA<DebitCardState>().having(
            (state) => state.isLoading,
            'isLoading',
            isTrue,
          ),
          isA<DebitCardState>()
              .having((state) => state.isLoading, 'isLoading', isFalse)
              .having(
                (state) => state.successMessage,
                'successMessage',
                'card_issued_successfully',
              ),
        ],
    verify: (_) {
      final props =
          verify(() => issueDebitCardUseCase.call(captureAny())).captured.single
              as IssueDebitCardUseCaseProps;
      expect(props.cardTypeCode, 'VISA');
      expect(props.withCard, isTrue);
      expect(props.email, user.loginEmail);
      expect(props.personId, user.personId);
    },
  );

  blocTest<DebitCardBloc, DebitCardState>(
    'hashes a PIN before verifying it and clears attempts on success',
    setUp: () {
      when(
        () => getAuthUserUseCase.call(any()),
      ).thenAnswer((_) async => Right<Failure, AuthUserEntity>(authUser));
      when(
        () => verifyCardPinUseCase.call(any()),
      ).thenAnswer((_) async => const Right<Failure, String>('otp-reg-id'));
    },
    build: createBloc,
    act:
        (bloc) => bloc.add(
          const DebitCardPinVerify(
            cardNumber: '1111222233334444',
            nameOnCard: 'Member',
            cardPIN: ' 1234 ',
            accountNumber: 'SA-1',
          ),
        ),
    expect:
        () => [
          isA<DebitCardState>().having(
            (state) => state.isLoading,
            'isLoading',
            isTrue,
          ),
          isA<DebitCardState>()
              .having((state) => state.isLoading, 'isLoading', isFalse)
              .having(
                (state) => state.successMessage,
                'successMessage',
                'otp-reg-id',
              )
              .having((state) => state.pinAttempts, 'pinAttempts', 0),
        ],
    verify: (_) {
      final props =
          verify(() => verifyCardPinUseCase.call(captureAny())).captured.single
              as VerifyCardPinUseCaseProps;
      expect(props.cardPIN, md5.convert(utf8.encode('1234')).toString());
      expect(props.accountNumber, 'SA-1');
    },
  );
}
