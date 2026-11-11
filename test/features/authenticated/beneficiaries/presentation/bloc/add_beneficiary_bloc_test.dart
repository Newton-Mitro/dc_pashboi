import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/entities/auth_user_entity.dart';
import 'package:pashboi/features/auth/domain/entities/user_entity.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/beneficiaries/domain/usecases/add_beneficiary_usecase.dart';
import 'package:pashboi/features/authenticated/beneficiaries/presentation/pages/add_beneficiary_bloc/add_beneficiary_bloc.dart';

class _MockGetAuthUserUseCase extends Mock implements GetAuthUserUseCase {}

class _MockAddBeneficiaryUseCase extends Mock
    implements AddBeneficiaryUseCase {}

class _MockLocalizationService extends Mock implements AppLocalizationService {}

void main() {
  late _MockGetAuthUserUseCase getAuthUserUseCase;
  late _MockAddBeneficiaryUseCase addBeneficiaryUseCase;
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
      const AddBeneficiaryProps(
        email: '',
        userId: 0,
        rolePermissionId: '',
        personId: 0,
        employeeCode: '',
        mobileNumber: '',
        beneficiaryName: '',
        beneficiaryAccountNumber: '',
      ),
    );
  });

  setUp(() {
    getAuthUserUseCase = _MockGetAuthUserUseCase();
    addBeneficiaryUseCase = _MockAddBeneficiaryUseCase();
    localizationService = _MockLocalizationService();
    when(() => localizationService.t(any())).thenAnswer(
      (invocation) => invocation.positionalArguments.single as String,
    );
  });

  AddBeneficiaryBloc createBloc() => AddBeneficiaryBloc(
    getAuthUserUseCase: getAuthUserUseCase,
    addBeneficiaryUseCase: addBeneficiaryUseCase,
    appLocalizationService: localizationService,
  );

  blocTest<AddBeneficiaryBloc, AddBeneficiaryState>(
    'reports missing beneficiary name and account number',
    build: createBloc,
    act:
        (bloc) => bloc.add(
          const AddBeneficiarySubmit(beneficiaryName: ' ', accountNumber: ''),
        ),
    expect:
        () => [
          const AddBeneficiaryValidationError({
            'beneficiaryName': 'please_enter_beneficiary_name',
            'accountNumber': 'please_enter_account_number',
          }),
        ],
    verify: (_) {
      verifyNever(() => getAuthUserUseCase.call(any()));
    },
  );

  blocTest<AddBeneficiaryBloc, AddBeneficiaryState>(
    'adds a valid beneficiary and forwards authenticated member details',
    setUp: () {
      when(
        () => getAuthUserUseCase.call(any()),
      ).thenAnswer((_) async => Right<Failure, AuthUserEntity>(authUser));
      when(
        () => addBeneficiaryUseCase.call(any()),
      ).thenAnswer((_) async => const Right<Failure, String>('Added'));
    },
    build: createBloc,
    act:
        (bloc) => bloc.add(
          const AddBeneficiarySubmit(
            beneficiaryName: 'Payee',
            accountNumber: 'SA-2',
          ),
        ),
    expect:
        () => [const AddBeneficiaryLoading(), const AddBeneficiarySuccess()],
    verify: (_) {
      final props =
          verify(() => addBeneficiaryUseCase.call(captureAny())).captured.single
              as AddBeneficiaryProps;
      expect(props.beneficiaryName, 'Payee');
      expect(props.beneficiaryAccountNumber, 'SA-2');
      expect(props.userId, user.userId);
      expect(props.email, user.loginEmail);
    },
  );
}
