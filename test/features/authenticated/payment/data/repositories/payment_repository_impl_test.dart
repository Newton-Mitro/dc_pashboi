import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/exceptions.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/features/authenticated/payment/data/datasources/payment_remote_datasource.dart';
import 'package:pashboi/features/authenticated/payment/data/models/service_model.dart';
import 'package:pashboi/features/authenticated/payment/data/repositories/payment_repository_impl.dart';
import 'package:pashboi/features/authenticated/payment/domain/usecases/fetch_payment_services_usecase.dart';

class _MockRemoteDataSource extends Mock implements PaymentRemoteDataSource {}

class _MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late _MockRemoteDataSource remote;
  late PaymentRepositoryImpl repository;
  const props = FetchPaymentServicesProps(
    email: 'member@example.com',
    userId: 7,
    rolePermissionId: 'role-1',
    personId: 3,
    employeeCode: 'EMP-3',
    mobileNumber: '01700000000',
  );
  final service = ServiceModel(
    id: 4,
    serviceCode: 'UTIL-1',
    serviceName: 'Utility payment',
    serviceAccount: 'SA-100',
    serviceIcon: '',
    serviceType: 'Utility',
    notifyPersons: const [],
    remarks: '',
  );

  setUp(() {
    remote = _MockRemoteDataSource();
    repository = PaymentRepositoryImpl(
      paymentRemoteDataSource: remote,
      networkInfo: _MockNetworkInfo(),
    );
  });

  test('returns available payment services', () async {
    when(
      () => remote.fetchPaymentServices(props),
    ).thenAnswer((_) async => [service]);

    final result = await repository.fetchPaymentServices(props);

    expect(
      result.fold(
        (_) => false,
        (services) => identical(services.single, service),
      ),
      isTrue,
    );
    verify(() => remote.fetchPaymentServices(props)).called(1);
  });

  test('maps remote service errors to failures', () async {
    when(
      () => remote.fetchPaymentServices(props),
    ).thenThrow(ServerException(message: 'Services unavailable'));

    final result = await repository.fetchPaymentServices(props);

    expect(
      result.fold((failure) => failure, (_) => null),
      isA<ServerFailure>().having(
        (failure) => failure.message,
        'message',
        'Services unavailable',
      ),
    );
  });
}
