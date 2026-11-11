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
import 'package:pashboi/features/authenticated/beneficiaries/domain/entities/beneficiary_entity.dart';
import 'package:pashboi/features/authenticated/beneficiaries/domain/usecases/fetch_beneficiaries_usecase.dart';
import 'package:pashboi/features/authenticated/beneficiaries/domain/usecases/remove_beneficiary_usecase.dart';
import 'package:pashboi/features/authenticated/beneficiaries/presentation/pages/beneficiaries_bloc/beneficiaries_bloc.dart';

class _MockFetchBeneficiariesUseCase extends Mock
    implements FetchBeneficiariesUseCase {}

class _MockGetAuthUserUseCase extends Mock implements GetAuthUserUseCase {}

class _MockRemoveBeneficiaryUseCase extends Mock
    implements RemoveBeneficiaryUseCase {}

class _MockLocalizationService extends Mock implements AppLocalizationService {}

void main() {
  late _MockFetchBeneficiariesUseCase fetchBeneficiariesUseCase;
  late _MockGetAuthUserUseCase getAuthUserUseCase;
  late _MockRemoveBeneficiaryUseCase removeBeneficiaryUseCase;
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
  final beneficiaries = <BeneficiaryEntity>[
    BeneficiaryEntity(id: 2, name: 'Payee', accountNumber: 'SA-2'),
  ];

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(
      const FetchBeneficiariesProps(
        email: '',
        userId: 0,
        rolePermissionId: '',
        personId: 0,
        employeeCode: '',
        mobileNumber: '',
      ),
    );
    registerFallbackValue(
      const RemoveBeneficiaryProps(
        email: '',
        userId: 0,
        rolePermissionId: '',
        personId: 0,
        employeeCode: '',
        mobileNumber: '',
        beneficiaryAccountNumber: '',
      ),
    );
  });

  setUp(() {
    fetchBeneficiariesUseCase = _MockFetchBeneficiariesUseCase();
    getAuthUserUseCase = _MockGetAuthUserUseCase();
    removeBeneficiaryUseCase = _MockRemoveBeneficiaryUseCase();
    localizationService = _MockLocalizationService();
    when(() => localizationService.t(any())).thenAnswer(
      (invocation) => invocation.positionalArguments.single as String,
    );
    when(
      () => getAuthUserUseCase.call(any()),
    ).thenAnswer((_) async => Right<Failure, AuthUserEntity>(authUser));
  });

  BeneficiariesBloc createBloc() => BeneficiariesBloc(
    fetchBeneficiariesUseCase: fetchBeneficiariesUseCase,
    getAuthUserUseCase: getAuthUserUseCase,
    removeBeneficiaryUseCase: removeBeneficiaryUseCase,
    appLocalizationService: localizationService,
  );

  blocTest<BeneficiariesBloc, BeneficiariesState>(
    'loads beneficiaries for the authenticated member',
    setUp: () {
      when(() => fetchBeneficiariesUseCase.call(any())).thenAnswer(
        (_) async => Right<Failure, List<BeneficiaryEntity>>(beneficiaries),
      );
    },
    build: createBloc,
    act: (bloc) => bloc.add(const FetchBeneficiaries()),
    expect:
        () => [
          const BeneficiariesLoading(),
          BeneficiariesLoaded(beneficiaries),
        ],
    verify: (_) {
      final props =
          verify(
                () => fetchBeneficiariesUseCase.call(captureAny()),
              ).captured.single
              as FetchBeneficiariesProps;
      expect(props.email, user.loginEmail);
      expect(props.userId, user.userId);
      expect(props.personId, user.personId);
    },
  );

  blocTest<BeneficiariesBloc, BeneficiariesState>(
    'deletes a beneficiary and reloads the updated list',
    setUp: () {
      when(
        () => removeBeneficiaryUseCase.call(any()),
      ).thenAnswer((_) async => const Right<Failure, String>('Removed'));
      when(() => fetchBeneficiariesUseCase.call(any())).thenAnswer(
        (_) async => Right<Failure, List<BeneficiaryEntity>>(beneficiaries),
      );
    },
    build: createBloc,
    act: (bloc) => bloc.add(const DeleteBeneficiary('SA-2')),
    expect:
        () => [
          const BeneficiariesLoading(),
          const BeneficiariesSuccess(),
          const BeneficiariesLoading(),
          BeneficiariesLoaded(beneficiaries),
        ],
    verify: (_) {
      final props =
          verify(
                () => removeBeneficiaryUseCase.call(captureAny()),
              ).captured.single
              as RemoveBeneficiaryProps;
      expect(props.beneficiaryAccountNumber, 'SA-2');
      verify(() => fetchBeneficiariesUseCase.call(any())).called(1);
    },
  );
}
