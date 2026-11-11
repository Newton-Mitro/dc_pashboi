import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/withdraw/domain/usecases/generate_withdrawl_qr_usecase.dart';
import 'package:pashboi/features/authenticated/withdraw/presentation/pages/withdrawl_qr_page/bloc/withdrawl_qr_steps_bloc.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/entities/deposit_account_entity.dart';

class _MockGetAuthUserUseCase extends Mock implements GetAuthUserUseCase {}

class _MockGenerateWithdrawlQrUseCase extends Mock
    implements GenerateWithdrawlQrUseCase {}

class _MockLocalizationService extends Mock implements AppLocalizationService {}

void main() {
  late _MockGetAuthUserUseCase getAuthUserUseCase;
  late _MockGenerateWithdrawlQrUseCase generateWithdrawlQrUseCase;
  late _MockLocalizationService localizationService;

  setUp(() {
    getAuthUserUseCase = _MockGetAuthUserUseCase();
    generateWithdrawlQrUseCase = _MockGenerateWithdrawlQrUseCase();
    localizationService = _MockLocalizationService();
    when(() => localizationService.t(any())).thenAnswer(
      (invocation) => invocation.positionalArguments.single as String,
    );
  });

  WithdrawlQrStepsBloc createBloc() => WithdrawlQrStepsBloc(
    getAuthUserUseCase: getAuthUserUseCase,
    generateWithdrawlQrUseCase: generateWithdrawlQrUseCase,
    appLocalizationService: localizationService,
  );

  blocTest<WithdrawlQrStepsBloc, WithdrawlQrStepsState>(
    'rejects a withdrawal amount that is not a multiple of 500',
    build: createBloc,
    act: (bloc) async {
      bloc
        ..add(
          WithdrawlQrSelectCardAccount(
            DepositAccountEntity(
              id: 1,
              number: 'SA-1',
              name: 'Member',
              typeName: 'Savings',
              withdrawableBalance: 2500,
            ),
          ),
        )
        ..add(const WithdrawlQrGoToNextStep())
        ..add(
          const WithdrawlQrUpdateStepData(
            step: 1,
            data: {'withdrawAmount': '750'},
          ),
        )
        ..add(const WithdrawlQrGoToNextStep());
    },
    expect:
        () => [
          isA<WithdrawlQrStepsState>(),
          isA<WithdrawlQrStepsState>().having(
            (state) => state.currentStep,
            'currentStep',
            1,
          ),
          isA<WithdrawlQrStepsState>(),
          isA<WithdrawlQrStepsState>()
              .having((state) => state.currentStep, 'currentStep', 1)
              .having(
                (state) => state.validationErrors[1]?['withdrawAmount'],
                'amount validation',
                'amount_must_be_a_multiple_of_500',
              ),
        ],
  );

  blocTest<WithdrawlQrStepsBloc, WithdrawlQrStepsState>(
    'allows a valid withdrawal amount within the account balance',
    build: createBloc,
    act: (bloc) async {
      bloc
        ..add(
          WithdrawlQrSelectCardAccount(
            DepositAccountEntity(
              id: 1,
              number: 'SA-1',
              name: 'Member',
              typeName: 'Savings',
              withdrawableBalance: 2500,
            ),
          ),
        )
        ..add(const WithdrawlQrGoToNextStep())
        ..add(
          const WithdrawlQrUpdateStepData(
            step: 1,
            data: {'withdrawAmount': '1000'},
          ),
        )
        ..add(const WithdrawlQrGoToNextStep());
    },
    expect:
        () => [
          isA<WithdrawlQrStepsState>(),
          isA<WithdrawlQrStepsState>().having(
            (state) => state.currentStep,
            'currentStep',
            1,
          ),
          isA<WithdrawlQrStepsState>(),
          isA<WithdrawlQrStepsState>()
              .having((state) => state.currentStep, 'currentStep', 2)
              .having((state) => state.validationErrors[1], 'errors', isEmpty),
        ],
  );
}
