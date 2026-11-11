import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/domain/usecases/fetch_collection_ledgers_usecase.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/presentation/bloc/collection_ledger_bloc.dart';

class _MockFetchCollectionLedgersUseCase extends Mock
    implements FetchCollectionLedgersUseCase {}

class _MockGetAuthUserUseCase extends Mock implements GetAuthUserUseCase {}

class _MockLocalizationService extends Mock implements AppLocalizationService {}

void main() {
  late _MockFetchCollectionLedgersUseCase fetchCollectionLedgersUseCase;
  late _MockGetAuthUserUseCase getAuthUserUseCase;
  late _MockLocalizationService localizationService;

  setUpAll(() {
    registerFallbackValue(
      const FetchCollectionLedgersProps(
        email: '',
        userId: 0,
        rolePermissionId: '',
        personId: 0,
        employeeCode: '',
        mobileNumber: '',
        searchText: '',
        moduleCode: '',
      ),
    );
  });

  setUp(() {
    fetchCollectionLedgersUseCase = _MockFetchCollectionLedgersUseCase();
    getAuthUserUseCase = _MockGetAuthUserUseCase();
    localizationService = _MockLocalizationService();
    when(() => localizationService.t(any())).thenAnswer(
      (invocation) => invocation.positionalArguments.single as String,
    );
  });

  CollectionLedgerBloc createBloc() => CollectionLedgerBloc(
    fetchCollectionLedgersUseCase: fetchCollectionLedgersUseCase,
    getAuthUserUseCase: getAuthUserUseCase,
    appLocalizationService: localizationService,
  );

  blocTest<CollectionLedgerBloc, CollectionLedgerState>(
    'rejects an empty account search without loading user details',
    build: createBloc,
    act:
        (bloc) => bloc.add(
          const FetchCollectionLedgersEvent(
            searchText: '  ',
            moduleCode: 'SAV',
          ),
        ),
    expect:
        () => [
          const CollectionLedgerValidationError({
            'searchText': 'please_enter_account_number',
          }),
        ],
    verify: (_) {
      verifyNever(() => getAuthUserUseCase.call(any()));
      verifyNever(() => fetchCollectionLedgersUseCase.call(any()));
    },
  );
}
