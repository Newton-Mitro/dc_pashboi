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
import 'package:pashboi/features/authenticated/cards/domain/entities/debit_card_entity.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/entities/deposit_account_entity.dart';
import 'package:pashboi/features/authenticated/transfer/domain/usecases/submit_fund_transfer_usecase.dart';
import 'package:pashboi/features/authenticated/transfer/presentation/pages/internal_transfer_page/bloc/internal_transfer_steps_bloc.dart';

class _MockGetAuthUserUseCase extends Mock implements GetAuthUserUseCase {}

class _MockSubmitFundTransferUseCase extends Mock
    implements SubmitFundTransferUseCase {}

class _MockLocalizationService extends Mock implements AppLocalizationService {}

void main() {
  late _MockGetAuthUserUseCase getAuthUserUseCase;
  late _MockSubmitFundTransferUseCase submitFundTransferUseCase;
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
  final sourceAccount = DepositAccountEntity(
    id: 1,
    number: 'SA-1',
    name: 'Member',
    typeName: 'Savings',
  );
  DebitCardEntity cardWithName(String nameOnCard) => DebitCardEntity(
    id: 2,
    cardsAccounts: const [],
    isActive: true,
    nameOnCard: nameOnCard,
    cardNumber: '1111222233334444',
    type: 'Debit',
    expiryDate: '30/06/2028',
    isVirtual: false,
    isBlock: false,
    stageCode: 'ACTIVE',
    stageName: 'Active',
  );
  final debitCard = cardWithName('Member Name');

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(
      const SubmitFundTransferProps(
        email: '',
        userId: 0,
        rolePermissionId: '',
        personId: 0,
        employeeCode: '',
        mobileNumber: '',
        amount: 0,
        otpRegId: '',
        otpValue: '',
        accountNumber: '',
        toAccountNumber: '',
        accountType: '',
        cardNumber: '',
        nameOnCard: '',
        cardPin: '',
      ),
    );
  });

  setUp(() {
    getAuthUserUseCase = _MockGetAuthUserUseCase();
    submitFundTransferUseCase = _MockSubmitFundTransferUseCase();
    localizationService = _MockLocalizationService();
    when(() => localizationService.t(any())).thenAnswer(
      (invocation) => invocation.positionalArguments.single as String,
    );
  });

  InternalTransferStepsBloc createBloc() => InternalTransferStepsBloc(
    getAuthUserUseCase: getAuthUserUseCase,
    submitFundTransferUseCase: submitFundTransferUseCase,
    appLocalizationService: localizationService,
  );

  blocTest<InternalTransferStepsBloc, InternalTransferStepsState>(
    'blocks progression without a selected source account',
    build: createBloc,
    act: (bloc) => bloc.add(const InternalTransferGoToNextStep()),
    expect:
        () => [
          isA<InternalTransferStepsState>()
              .having((state) => state.currentStep, 'currentStep', 0)
              .having(
                (state) => state.validationErrors[0]?['transferFromAccount'],
                'source account validation',
                'select_an_account_to_transfer_from',
              ),
        ],
  );

  blocTest<InternalTransferStepsBloc, InternalTransferStepsState>(
    'advances only after each required step is valid and keeps step data merged',
    build: createBloc,
    act: (bloc) {
      bloc
        ..add(InternalTransferSelectCardAccount(sourceAccount))
        ..add(const InternalTransferGoToNextStep())
        ..add(
          const InternalTransferUpdateStepData(
            step: 1,
            data: {'searchAccountNumber': 'SA-2'},
          ),
        )
        ..add(
          const InternalTransferUpdateStepData(
            step: 1,
            data: {'searchedAccountHolderName': 'Recipient'},
          ),
        )
        ..add(const InternalTransferGoToNextStep())
        ..add(
          const InternalTransferUpdateStepData(
            step: 2,
            data: {'transferAmount': '750'},
          ),
        )
        ..add(const InternalTransferGoToNextStep())
        ..add(const InternalTransferGoToNextStep())
        ..add(const InternalTransferGoToPreviousStep());
    },
    expect:
        () => [
          isA<InternalTransferStepsState>().having(
            (state) => state.selectedAccount,
            'selectedAccount',
            sourceAccount,
          ),
          isA<InternalTransferStepsState>()
              .having((state) => state.currentStep, 'currentStep', 1)
              .having(
                (state) => state.validationErrors[0],
                'step 0 errors',
                isEmpty,
              ),
          isA<InternalTransferStepsState>().having(
            (state) => state.stepData[1]?['searchAccountNumber'],
            'searched account number',
            'SA-2',
          ),
          isA<InternalTransferStepsState>().having(
            (state) => state.stepData[1]?['searchedAccountHolderName'],
            'account holder name',
            'Recipient',
          ),
          isA<InternalTransferStepsState>()
              .having((state) => state.currentStep, 'currentStep', 2)
              .having(
                (state) => state.validationErrors[1],
                'step 1 errors',
                isEmpty,
              ),
          isA<InternalTransferStepsState>().having(
            (state) => state.stepData[2]?['transferAmount'],
            'transfer amount',
            '750',
          ),
          isA<InternalTransferStepsState>()
              .having((state) => state.currentStep, 'currentStep', 3)
              .having(
                (state) => state.validationErrors[2],
                'step 2 errors',
                isEmpty,
              ),
          isA<InternalTransferStepsState>().having(
            (state) => state.currentStep,
            'currentStep',
            4,
          ),
          isA<InternalTransferStepsState>().having(
            (state) => state.currentStep,
            'currentStep',
            3,
          ),
        ],
  );

  blocTest<InternalTransferStepsBloc, InternalTransferStepsState>(
    'validates recipient, amount, PIN, and confirmation fields',
    build: createBloc,
    act: (bloc) {
      bloc
        ..add(const InternalTransferValidateStep(1))
        ..add(const InternalTransferValidateStep(2))
        ..add(const InternalTransferValidateStep(4))
        ..add(const InternalTransferValidateStep(5))
        ..add(
          const InternalTransferUpdateStepData(
            step: 1,
            data: {
              'searchAccountNumber': 'SA-2',
              'searchedAccountHolderName': 'Recipient',
            },
          ),
        )
        ..add(
          const InternalTransferUpdateStepData(
            step: 2,
            data: {'transferAmount': '750'},
          ),
        )
        ..add(
          const InternalTransferUpdateStepData(
            step: 4,
            data: {'cardPin': '1234'},
          ),
        )
        ..add(
          const InternalTransferUpdateStepData(
            step: 5,
            data: {'confirmation': true},
          ),
        )
        ..add(const InternalTransferValidateStep(1))
        ..add(const InternalTransferValidateStep(2))
        ..add(const InternalTransferValidateStep(4))
        ..add(const InternalTransferValidateStep(5));
    },
    expect:
        () => [
          isA<InternalTransferStepsState>().having(
            (state) => state.validationErrors[1],
            'recipient errors',
            {
              'searchAccountNumber': 'please_enter_a_search_account_number',
              'searchedAccountHolderName': 'account_holder_name_is_required',
            },
          ),
          isA<InternalTransferStepsState>().having(
            (state) => state.validationErrors[2],
            'amount errors',
            {'transferAmount': 'please_enter_transfer_amount'},
          ),
          isA<InternalTransferStepsState>().having(
            (state) => state.validationErrors[4],
            'PIN errors',
            {'cardPin': 'please_enter_a_card_pin'},
          ),
          isA<InternalTransferStepsState>().having(
            (state) => state.validationErrors[5],
            'confirmation errors',
            {'confirmation': 'you_must_confirm_to_proceed'},
          ),
          isA<InternalTransferStepsState>().having(
            (state) => state.stepData[1]?['searchAccountNumber'],
            'recipient number',
            'SA-2',
          ),
          isA<InternalTransferStepsState>().having(
            (state) => state.stepData[2]?['transferAmount'],
            'amount',
            '750',
          ),
          isA<InternalTransferStepsState>().having(
            (state) => state.stepData[4]?['cardPin'],
            'PIN',
            '1234',
          ),
          isA<InternalTransferStepsState>().having(
            (state) => state.stepData[5]?['confirmation'],
            'confirmation',
            true,
          ),
          isA<InternalTransferStepsState>().having(
            (state) => state.validationErrors[1],
            'valid recipient errors',
            isEmpty,
          ),
          isA<InternalTransferStepsState>().having(
            (state) => state.validationErrors[2],
            'valid amount errors',
            isEmpty,
          ),
          isA<InternalTransferStepsState>().having(
            (state) => state.validationErrors[4],
            'valid PIN errors',
            isEmpty,
          ),
          isA<InternalTransferStepsState>().having(
            (state) => state.validationErrors[5],
            'valid confirmation errors',
            isEmpty,
          ),
        ],
  );

  blocTest<InternalTransferStepsBloc, InternalTransferStepsState>(
    'rejects PINs with a length other than four',
    build: createBloc,
    act: (bloc) {
      bloc
        ..add(
          const InternalTransferUpdateStepData(
            step: 4,
            data: {'cardPin': '123'},
          ),
        )
        ..add(const InternalTransferValidateStep(4));
    },
    expect:
        () => [
          isA<InternalTransferStepsState>(),
          isA<InternalTransferStepsState>().having(
            (state) => state.validationErrors[4]?['cardPin'],
            'PIN validation',
            'pin_must_be_4_digits',
          ),
        ],
  );

  blocTest<InternalTransferStepsBloc, InternalTransferStepsState>(
    'does not advance beyond the last step and cannot move before the first',
    build: createBloc,
    act: (bloc) {
      bloc
        ..add(const InternalTransferGoToPreviousStep())
        ..add(
          const InternalTransferUpdateStepData(
            step: 5,
            data: {'confirmation': true},
          ),
        )
        ..add(const InternalTransferGoToNextStep());
    },
    expect:
        () => [
          isA<InternalTransferStepsState>().having(
            (state) => state.stepData[5]?['confirmation'],
            'confirmation',
            true,
          ),
          isA<InternalTransferStepsState>()
              .having((state) => state.currentStep, 'last step', 0)
              .having(
                (state) => state.validationErrors[0],
                'step zero errors',
                isNotEmpty,
              ),
        ],
  );

  blocTest<InternalTransferStepsBloc, InternalTransferStepsState>(
    'shows an error and does not submit when authentication fails',
    setUp: () {
      when(() => getAuthUserUseCase.call(any())).thenAnswer(
        (_) async => const Left<Failure, AuthUserEntity>(
          ServerFailure(message: 'User unavailable'),
        ),
      );
    },
    build: createBloc,
    act:
        (bloc) => bloc.add(
          const InternalTransferSubmit(
            toAccountNumber: 'SA-2',
            transferAmount: 750,
          ),
        ),
    expect:
        () => [
          isA<InternalTransferStepsState>().having(
            (state) => state.isLoading,
            'loading',
            true,
          ),
          isA<InternalTransferStepsState>()
              .having((state) => state.isLoading, 'loading', false)
              .having(
                (state) => state.error,
                'error',
                'failed_to_load_user_info',
              ),
        ],
    verify: (_) => verifyNever(() => submitFundTransferUseCase.call(any())),
  );

  blocTest<InternalTransferStepsBloc, InternalTransferStepsState>(
    'exposes transfer failures and clears the loading state',
    setUp: () {
      when(
        () => getAuthUserUseCase.call(any()),
      ).thenAnswer((_) async => Right<Failure, AuthUserEntity>(authUser));
      when(() => submitFundTransferUseCase.call(any())).thenAnswer(
        (_) async => const Left<Failure, String>(
          ServerFailure(message: 'Transfer rejected'),
        ),
      );
    },
    build: createBloc,
    seed:
        () => InternalTransferStepsState(
          currentStep: 5,
          selectedAccount: sourceAccount,
          selectedCard: debitCard,
          stepData: const {
            4: {'cardPin': '1234', 'OTPRegId': 'reg-id'},
            5: {'OTP': '456789'},
          },
        ),
    act:
        (bloc) => bloc.add(
          const InternalTransferSubmit(
            toAccountNumber: 'SA-2',
            transferAmount: 750,
          ),
        ),
    expect:
        () => [
          isA<InternalTransferStepsState>().having(
            (state) => state.isLoading,
            'loading',
            true,
          ),
          isA<InternalTransferStepsState>()
              .having((state) => state.isLoading, 'loading', false)
              .having((state) => state.error, 'error', 'Transfer rejected'),
        ],
  );

  blocTest<InternalTransferStepsBloc, InternalTransferStepsState>(
    'reports unexpected submission errors and clears the loading state',
    setUp: () {
      when(
        () => getAuthUserUseCase.call(any()),
      ).thenAnswer((_) async => Right<Failure, AuthUserEntity>(authUser));
      when(
        () => submitFundTransferUseCase.call(any()),
      ).thenThrow(Exception('transport failure'));
      when(
        () => localizationService.t('failed_to_submit_deposit_now'),
      ).thenReturn('failed_to_submit_deposit_now');
    },
    build: createBloc,
    seed:
        () => InternalTransferStepsState(
          currentStep: 5,
          selectedAccount: sourceAccount,
          selectedCard: debitCard,
          stepData: const {
            4: {'cardPin': '1234', 'OTPRegId': 'reg-id'},
            5: {'OTP': '456789'},
          },
        ),
    act:
        (bloc) => bloc.add(
          const InternalTransferSubmit(
            toAccountNumber: 'SA-2',
            transferAmount: 750,
          ),
        ),
    expect:
        () => [
          isA<InternalTransferStepsState>().having(
            (state) => state.isLoading,
            'loading',
            true,
          ),
          isA<InternalTransferStepsState>()
              .having((state) => state.isLoading, 'loading', false)
              .having(
                (state) => state.error,
                'error',
                'failed_to_submit_deposit_now',
              ),
        ],
  );

  blocTest<InternalTransferStepsBloc, InternalTransferStepsState>(
    'hashes the card PIN and submits normalized transfer details',
    setUp: () {
      when(
        () => getAuthUserUseCase.call(any()),
      ).thenAnswer((_) async => Right<Failure, AuthUserEntity>(authUser));
      when(() => submitFundTransferUseCase.call(any())).thenAnswer(
        (_) async => const Right<Failure, String>('Transfer complete'),
      );
    },
    build: createBloc,
    act: (bloc) async {
      bloc
        ..add(InternalTransferSelectCardAccount(sourceAccount))
        ..add(InternalTransferSelectDebitCard(cardWithName('  MEMBER NAME ')))
        ..add(
          const InternalTransferUpdateStepData(
            step: 4,
            data: {'cardPin': ' 1234 ', 'OTPRegId': 'otp-reg'},
          ),
        )
        ..add(
          const InternalTransferUpdateStepData(
            step: 5,
            data: {'OTP': '456789'},
          ),
        )
        ..add(
          const InternalTransferSubmit(
            toAccountNumber: 'SA-2',
            transferAmount: 750,
          ),
        );
    },
    expect:
        () => [
          isA<InternalTransferStepsState>(),
          isA<InternalTransferStepsState>(),
          isA<InternalTransferStepsState>(),
          isA<InternalTransferStepsState>(),
          isA<InternalTransferStepsState>().having(
            (state) => state.isLoading,
            'isLoading',
            isTrue,
          ),
          isA<InternalTransferStepsState>()
              .having((state) => state.isLoading, 'isLoading', isFalse)
              .having(
                (state) => state.successMessage,
                'successMessage',
                'Transfer complete',
              ),
        ],
    verify: (_) {
      final props =
          verify(
                () => submitFundTransferUseCase.call(captureAny()),
              ).captured.single
              as SubmitFundTransferProps;
      expect(props.amount, 750);
      expect(props.accountNumber, 'SA-1');
      expect(props.toAccountNumber, 'SA-2');
      expect(props.cardPin, md5.convert(utf8.encode('1234')).toString());
      expect(props.nameOnCard, 'member name');
      expect(props.otpRegId, 'otp-reg');
      expect(props.otpValue, '456789');
    },
  );
}
