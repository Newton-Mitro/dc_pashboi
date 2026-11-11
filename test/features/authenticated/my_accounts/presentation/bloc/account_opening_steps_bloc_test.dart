import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/entities/deposit_account_entity.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/entities/nominee_entity.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/usecases/open_deposit_account_usecase.dart';
import 'package:pashboi/features/authenticated/my_accounts/presentation/pages/account_openning_page/bloc/account_opening_steps_bloc.dart';

class _MockGetAuthUserUseCase extends Mock implements GetAuthUserUseCase {}

class _MockOpenDepositAccountUseCase extends Mock
    implements OpenDepositAccountUseCase {}

class _MockLocalizationService extends Mock implements AppLocalizationService {}

void main() {
  late _MockGetAuthUserUseCase getAuthUserUseCase;
  late _MockOpenDepositAccountUseCase openDepositAccountUseCase;
  late _MockLocalizationService localizationService;

  setUp(() {
    getAuthUserUseCase = _MockGetAuthUserUseCase();
    openDepositAccountUseCase = _MockOpenDepositAccountUseCase();
    localizationService = _MockLocalizationService();
    when(() => localizationService.t(any())).thenAnswer(
      (invocation) => invocation.positionalArguments.single as String,
    );
  });

  AccountOpeningStepsBloc createBloc() => AccountOpeningStepsBloc(
    getAuthUserUseCase: getAuthUserUseCase,
    openDepositAccountUseCase: openDepositAccountUseCase,
    appLocalizationService: localizationService,
  );

  group('account opening step navigation', () {
    blocTest<AccountOpeningStepsBloc, AccountOpeningStepsState>(
      'starts at step zero with the default account purpose',
      build: createBloc,
      verify: (bloc) {
        expect(bloc.state.currentStep, 0);
        expect(bloc.state.stepData[1], {'accountFor': 'Personal'});
      },
    );

    blocTest<AccountOpeningStepsBloc, AccountOpeningStepsState>(
      'blocks progression when no transfer account is selected',
      build: createBloc,
      act: (bloc) => bloc.add(const AccountOpeningGoToNextStep()),
      expect:
          () => [
            isA<AccountOpeningStepsState>()
                .having((state) => state.currentStep, 'currentStep', 0)
                .having(
                  (state) => state.validationErrors[0]?['transferFromAccount'],
                  'transfer account error',
                  'select_an_account_to_transfer_from',
                ),
          ],
    );

    blocTest<AccountOpeningStepsBloc, AccountOpeningStepsState>(
      'merges updated data and permits progression through an optional step',
      build: createBloc,
      act: (bloc) async {
        bloc
          ..add(
            AccountOpeningSelectCardAccount(
              DepositAccountEntity(
                id: 1,
                number: 'SA-1',
                name: 'Savings account',
                typeName: 'Savings',
              ),
            ),
          )
          ..add(const AccountOpeningGoToNextStep())
          ..add(
            const AccountOpeningUpdateStepData(
              step: 1,
              data: {'extra': 'value'},
            ),
          )
          ..add(const AccountOpeningGoToNextStep());
      },
      expect:
          () => [
            isA<AccountOpeningStepsState>(),
            isA<AccountOpeningStepsState>().having(
              (state) => state.currentStep,
              'currentStep',
              1,
            ),
            isA<AccountOpeningStepsState>().having(
              (state) => state.stepData[1],
              'merged step data',
              {'accountFor': 'Personal', 'extra': 'value'},
            ),
            isA<AccountOpeningStepsState>().having(
              (state) => state.currentStep,
              'currentStep',
              2,
            ),
          ],
    );

    blocTest<AccountOpeningStepsBloc, AccountOpeningStepsState>(
      'resets step data and validation state',
      build: createBloc,
      act: (bloc) async {
        bloc
          ..add(
            const AccountOpeningUpdateStepData(
              step: 0,
              data: {'field': 'value'},
            ),
          )
          ..add(const AccountOpeningFlowReset());
      },
      expect:
          () => [
            isA<AccountOpeningStepsState>(),
            isA<AccountOpeningStepsState>()
                .having((state) => state.currentStep, 'currentStep', 0)
                .having((state) => state.stepData, 'stepData', isEmpty)
                .having(
                  (state) => state.validationErrors,
                  'validationErrors',
                  isEmpty,
                ),
          ],
    );
  });

  blocTest<AccountOpeningStepsBloc, AccountOpeningStepsState>(
    'does not add a nominee when the total share would exceed 100 percent',
    build: createBloc,
    act: (bloc) async {
      bloc
        ..add(
          AccountOpeningAddNominee(
            NomineeEntity(
              id: 1,
              name: 'First nominee',
              relation: 'Sibling',
              phone: '01700000000',
              nationalId: '123',
              percentage: 60,
            ),
          ),
        )
        ..add(
          AccountOpeningAddNominee(
            NomineeEntity(
              id: 2,
              name: 'Second nominee',
              relation: 'Parent',
              phone: '01700000001',
              nationalId: '456',
              percentage: 50,
            ),
          ),
        );
    },
    expect:
        () => [
          isA<AccountOpeningStepsState>().having(
            (state) => state.nominees.map((nominee) => nominee.id).toList(),
            'nominee IDs',
            [1],
          ),
        ],
  );
}
