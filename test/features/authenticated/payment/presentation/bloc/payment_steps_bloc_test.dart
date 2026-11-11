import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/entities/deposit_account_entity.dart';
import 'package:pashboi/features/authenticated/payment/domain/usecases/submit_payment_usecase.dart';
import 'package:pashboi/features/authenticated/payment/presentation/pages/payment_page/bloc/payment_steps_bloc.dart';

class _MockGetAuthUserUseCase extends Mock implements GetAuthUserUseCase {}

class _MockSubmitPaymentUseCase extends Mock implements SubmitPaymentUseCase {}

class _MockLocalizationService extends Mock implements AppLocalizationService {}

void main() {
  late _MockGetAuthUserUseCase getAuthUserUseCase;
  late _MockSubmitPaymentUseCase submitPaymentUseCase;
  late _MockLocalizationService localizationService;

  setUp(() {
    getAuthUserUseCase = _MockGetAuthUserUseCase();
    submitPaymentUseCase = _MockSubmitPaymentUseCase();
    localizationService = _MockLocalizationService();
    when(() => localizationService.t(any())).thenAnswer(
      (invocation) => invocation.positionalArguments.single as String,
    );
  });

  PaymentStepsBloc createBloc() => PaymentStepsBloc(
    getAuthUserUseCase: getAuthUserUseCase,
    submitPaymentUseCase: submitPaymentUseCase,
    appLocalizationService: localizationService,
  );

  blocTest<PaymentStepsBloc, PaymentStepsState>(
    'requires a source account before proceeding',
    build: createBloc,
    act: (bloc) => bloc.add(const PaymentGoToNextStep()),
    expect:
        () => [
          isA<PaymentStepsState>()
              .having((state) => state.currentStep, 'currentStep', 0)
              .having(
                (state) => state.validationErrors[0]?['transferFromAccount'],
                'source account validation',
                'select_an_account_to_transfer_from',
              ),
        ],
  );

  blocTest<PaymentStepsBloc, PaymentStepsState>(
    'advances after a source account is selected and validates the PIN length',
    build: createBloc,
    act: (bloc) async {
      bloc
        ..add(
          PaymentSelectCardAccount(
            DepositAccountEntity(
              id: 1,
              number: 'SA-1',
              name: 'Member',
              typeName: 'Savings',
            ),
          ),
        )
        ..add(const PaymentGoToNextStep())
        ..add(const PaymentUpdateStepData(step: 4, data: {'cardPin': '123'}))
        ..add(const PaymentValidateStep(4));
    },
    expect:
        () => [
          isA<PaymentStepsState>(),
          isA<PaymentStepsState>().having(
            (state) => state.currentStep,
            'currentStep',
            1,
          ),
          isA<PaymentStepsState>(),
          isA<PaymentStepsState>().having(
            (state) => state.validationErrors[4]?['cardPin'],
            'PIN error',
            'pin_must_be_4_digits',
          ),
        ],
  );

  blocTest<PaymentStepsBloc, PaymentStepsState>(
    'requires explicit confirmation on the final review step',
    build: createBloc,
    seed: () => const PaymentStepsState(currentStep: 5),
    act: (bloc) => bloc.add(const PaymentGoToNextStep()),
    expect:
        () => [
          isA<PaymentStepsState>()
              .having((state) => state.currentStep, 'currentStep', 5)
              .having(
                (state) => state.validationErrors[5]?['confirmation'],
                'confirmation error',
                'you_must_confirm_to_proceed',
              ),
        ],
  );
}
