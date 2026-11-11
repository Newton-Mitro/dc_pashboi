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
import 'package:pashboi/features/authenticated/loan_payment/domain/entities/loan_payment_entity.dart';
import 'package:pashboi/features/authenticated/loan_payment/domain/usecases/fetch_loan_payment_usecase.dart';
import 'package:pashboi/features/authenticated/loan_payment/presentation/pages/bloc/loan_payment_bloc.dart';

class _MockFetchLoanPaymentUseCase extends Mock
    implements FetchLoanPaymentUseCase {}

class _MockGetAuthUserUseCase extends Mock implements GetAuthUserUseCase {}

class _MockLocalizationService extends Mock implements AppLocalizationService {}

void main() {
  late _MockFetchLoanPaymentUseCase fetchLoanPaymentUseCase;
  late _MockGetAuthUserUseCase getAuthUserUseCase;
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
  final payment = LoanPaymentEntity(
    id: 5,
    loanNumber: 'LN-205',
    loanRefundAmount: 5000,
    interestAmount: 300,
    loanFineAmount: 50,
    loanLpsAmount: 200,
    loanLpsRenewalFeeAmount: 25,
    shareFineAmount: 10,
  );
  const event = FetchLoanPayment(
    loanNumber: 'LN-205',
    interestDays: 45,
    interestRate: 8.5,
    loanBalance: 25000,
    loanRefundAmount: 5000,
    moduleCode: 'LN',
    issuedDate: '2024-01-01',
    lastPaidDate: '2025-01-01',
  );

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(
      const FetchLoanPaymentProps(
        email: '',
        userId: 0,
        rolePermissionId: '',
        personId: 0,
        employeeCode: '',
        mobileNumber: '',
        loanNumber: '',
        interestDays: 0,
        interestRate: 0,
        loanBalance: 0,
        loanRefundAmount: 0,
        moduleCode: '',
        issuedDate: null,
        lastPaidDate: null,
      ),
    );
  });

  setUp(() {
    fetchLoanPaymentUseCase = _MockFetchLoanPaymentUseCase();
    getAuthUserUseCase = _MockGetAuthUserUseCase();
    localizationService = _MockLocalizationService();
  });

  LoanPaymentBloc createBloc() => LoanPaymentBloc(
    fetchLoanPaymentUseCase: fetchLoanPaymentUseCase,
    getAuthUserUseCase: getAuthUserUseCase,
    appLocalizationService: localizationService,
  );

  blocTest<LoanPaymentBloc, LoanPaymentState>(
    'emits an authentication error when no user is available',
    setUp: () {
      when(() => getAuthUserUseCase.call(any())).thenAnswer(
        (_) async => const Left<Failure, AuthUserEntity>(
          ServerFailure(message: 'Unauthenticated'),
        ),
      );
    },
    build: createBloc,
    act: (bloc) => bloc.add(event),
    expect:
        () => [
          isA<LoanPaymentLoading>(),
          const LoanPaymentError(message: 'Failed to authenticate user'),
        ],
    verify: (_) {
      verifyNever(() => fetchLoanPaymentUseCase.call(any()));
    },
  );

  blocTest<LoanPaymentBloc, LoanPaymentState>(
    'loads repayment amounts using the authenticated member request',
    setUp: () {
      when(
        () => getAuthUserUseCase.call(any()),
      ).thenAnswer((_) async => Right<Failure, AuthUserEntity>(authUser));
      when(
        () => fetchLoanPaymentUseCase.call(any()),
      ).thenAnswer((_) async => Right<Failure, LoanPaymentEntity>(payment));
    },
    build: createBloc,
    act: (bloc) => bloc.add(event),
    expect:
        () => [
          isA<LoanPaymentLoading>(),
          LoanPaymentLoaded(loanPayment: payment),
        ],
    verify: (_) {
      final props =
          verify(
                () => fetchLoanPaymentUseCase.call(captureAny()),
              ).captured.single
              as FetchLoanPaymentProps;
      expect(props.loanNumber, event.loanNumber);
      expect(props.interestDays, event.interestDays);
      expect(props.loanBalance, event.loanBalance);
      expect(props.email, user.loginEmail);
      expect(props.userId, user.userId);
      expect(props.personId, user.personId);
    },
  );
}
