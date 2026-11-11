import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/domain/entities/collection_ledger_entity.dart';
import 'package:pashboi/features/authenticated/deposit/domain/usecases/submit_deposit_now_usecase.dart';
import 'package:pashboi/features/authenticated/deposit/presentation/pages/deposit_now_page/bloc/deposit_now_steps_bloc.dart';

class _MockGetAuthUserUseCase extends Mock implements GetAuthUserUseCase {}

class _MockSubmitDepositNowUseCase extends Mock
    implements SubmitDepositNowUseCase {}

class _MockLocalizationService extends Mock implements AppLocalizationService {}

CollectionLedgerEntity _ledger({
  required int amount,
  int depositAmount = 0,
  bool isSelected = false,
  bool multiplier = false,
}) => CollectionLedgerEntity(
  id: 1,
  accountId: 2,
  accountNumber: 'SA-1',
  accountName: 'Member',
  accountTypeCode: '01',
  moduleCode: 'SAV',
  accountType: 'Savings',
  ledgerId: 3,
  ledgerName: 'Monthly savings',
  subledger: false,
  plType: 0,
  collectionType: 'Savings',
  defaultAccount: false,
  amount: amount,
  depositAmount: depositAmount,
  multiplier: multiplier,
  editable: true,
  loanBalance: 0,
  lps: false,
  intrestRate: 0,
  lastPaidDate: DateTime(2025, 1, 1),
  refundBased: false,
  accountFor: 'Personal',
  isSelected: isSelected,
  isRefundBased: false,
);

void main() {
  late _MockGetAuthUserUseCase getAuthUserUseCase;
  late _MockSubmitDepositNowUseCase submitDepositNowUseCase;
  late _MockLocalizationService localizationService;

  setUp(() {
    getAuthUserUseCase = _MockGetAuthUserUseCase();
    submitDepositNowUseCase = _MockSubmitDepositNowUseCase();
    localizationService = _MockLocalizationService();
    when(() => localizationService.t(any())).thenAnswer(
      (invocation) => invocation.positionalArguments.single as String,
    );
  });

  DepositNowStepsBloc createBloc() => DepositNowStepsBloc(
    getAuthUserUseCase: getAuthUserUseCase,
    submitDepositNowUseCase: submitDepositNowUseCase,
    appLocalizationService: localizationService,
  );

  blocTest<DepositNowStepsBloc, DepositNowStepsState>(
    'requires a source account before continuing',
    build: createBloc,
    act: (bloc) => bloc.add(const DepositNowGoToNextStep()),
    expect:
        () => [
          isA<DepositNowStepsState>()
              .having((state) => state.currentStep, 'currentStep', 0)
              .having(
                (state) => state.validationErrors[0]?['transferFromAccount'],
                'source account validation',
                'select_an_account_to_transfer_from',
              ),
        ],
  );

  blocTest<DepositNowStepsBloc, DepositNowStepsState>(
    'reports a selected ledger amount that violates its multiplier',
    build: createBloc,
    act: (bloc) async {
      final ledger = _ledger(amount: 1000, multiplier: true);
      bloc
        ..add(SetCollectionLedgers(ledgers: [ledger]))
        ..add(ToggleSelectAllLedgers(true))
        ..add(UpdateLedgerAmount(ledger: ledger, newAmount: 1500))
        ..add(const DepositNowValidateStep(2));
    },
    expect:
        () => [
          isA<DepositNowStepsState>(),
          isA<DepositNowStepsState>(),
          isA<DepositNowStepsState>(),
          isA<DepositNowStepsState>().having(
            (state) => state.validationErrors[2]?['amounts'],
            'ledger amount errors',
            {'3': 'deposit_amount_must_be_a_multiple_of1000'},
          ),
        ],
  );

  blocTest<DepositNowStepsBloc, DepositNowStepsState>(
    'resets selected ledgers and step state when the flow resets',
    build: createBloc,
    act: (bloc) async {
      bloc
        ..add(SetCollectionLedgers(ledgers: [_ledger(amount: 500)]))
        ..add(const ToggleSelectAllLedgers(true))
        ..add(const ResetDepositNowFlow());
    },
    expect:
        () => [
          isA<DepositNowStepsState>(),
          isA<DepositNowStepsState>(),
          isA<DepositNowStepsState>()
              .having((state) => state.currentStep, 'currentStep', 0)
              .having((state) => state.collectionLedgers, 'ledgers', isEmpty)
              .having((state) => state.validationErrors, 'errors', isEmpty),
        ],
  );
}
