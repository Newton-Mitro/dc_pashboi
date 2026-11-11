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
import 'package:pashboi/features/authenticated/payment/domain/entities/service_entity.dart';
import 'package:pashboi/features/authenticated/payment/domain/usecases/fetch_payment_services_usecase.dart';
import 'package:pashboi/features/authenticated/payment/presentation/pages/payment_page/sections/pay_to_section/bloc/payment_service_bloc.dart';

class _MockGetAuthUserUseCase extends Mock implements GetAuthUserUseCase {}

class _MockFetchPaymentServicesUseCase extends Mock
    implements FetchPaymentServicesUseCase {}

class _MockLocalizationService extends Mock implements AppLocalizationService {}

void main() {
  late _MockGetAuthUserUseCase getAuthUserUseCase;
  late _MockFetchPaymentServicesUseCase fetchPaymentServicesUseCase;
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
  final services = <ServiceEntity>[
    ServiceEntity(
      id: 1,
      serviceCode: 'UTIL-1',
      serviceName: 'Utility payment',
      serviceAccount: 'SA-1',
      serviceIcon: '',
      serviceType: 'Utility',
      notifyPersons: const [],
      remarks: '',
    ),
  ];

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(
      const FetchPaymentServicesProps(
        email: '',
        userId: 0,
        rolePermissionId: '',
        personId: 0,
        employeeCode: '',
        mobileNumber: '',
      ),
    );
  });

  setUp(() {
    getAuthUserUseCase = _MockGetAuthUserUseCase();
    fetchPaymentServicesUseCase = _MockFetchPaymentServicesUseCase();
    localizationService = _MockLocalizationService();
    when(() => localizationService.t(any())).thenAnswer(
      (invocation) => invocation.positionalArguments.single as String,
    );
  });

  PaymentServiceBloc createBloc() => PaymentServiceBloc(
    getAuthUserUseCase: getAuthUserUseCase,
    fetchPaymentServicesUseCase: fetchPaymentServicesUseCase,
    appLocalizationService: localizationService,
  );

  blocTest<PaymentServiceBloc, PaymentServiceState>(
    'loads service list using authenticated member context',
    setUp: () {
      when(
        () => getAuthUserUseCase.call(any()),
      ).thenAnswer((_) async => Right<Failure, AuthUserEntity>(authUser));
      when(
        () => fetchPaymentServicesUseCase.call(any()),
      ).thenAnswer((_) async => Right<Failure, List<ServiceEntity>>(services));
    },
    build: createBloc,
    act: (bloc) => bloc.add(const FetchPaymentServicesEvent()),
    expect:
        () => [isA<PaymentServiceLoading>(), PaymentServiceLoaded(services)],
    verify: (_) {
      final props =
          verify(
                () => fetchPaymentServicesUseCase.call(captureAny()),
              ).captured.single
              as FetchPaymentServicesProps;
      expect(props.email, user.loginEmail);
      expect(props.userId, user.userId);
      expect(props.personId, user.personId);
      expect(props.mobileNumber, user.regMobile);
    },
  );

  blocTest<PaymentServiceBloc, PaymentServiceState>(
    'stops with an error when authentication fails',
    setUp: () {
      when(() => getAuthUserUseCase.call(any())).thenAnswer(
        (_) async => const Left<Failure, AuthUserEntity>(
          ServerFailure(message: 'Unauthenticated'),
        ),
      );
    },
    build: createBloc,
    act: (bloc) => bloc.add(const FetchPaymentServicesEvent()),
    expect:
        () => [
          isA<PaymentServiceLoading>(),
          const PaymentServiceError('failed_to_load_user_info'),
        ],
    verify: (_) {
      verifyNever(() => fetchPaymentServicesUseCase.call(any()));
    },
  );
}
