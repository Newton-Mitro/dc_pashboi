import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/exceptions.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/features/authenticated/cards/data/datasources/remote.datasource.dart';
import 'package:pashboi/features/authenticated/cards/data/repositories/repository.impl.dart';
import 'package:pashboi/features/authenticated/cards/domain/entities/debit_card_entity.dart';
import 'package:pashboi/features/authenticated/cards/domain/usecases/get_my_card_usecase.dart';

class _MockRemoteDataSource extends Mock implements CardRemoteDataSource {}

class _MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late _MockRemoteDataSource remote;
  late CardRepositoryImpl repository;
  const props = GetMyCardUseCaseProps(
    email: 'member@example.com',
    userId: 7,
    rolePermissionId: 'role-1',
    personId: 3,
    employeeCode: 'EMP-3',
    mobileNumber: '01700000000',
  );
  final card = DebitCardEntity(
    id: 4,
    cardsAccounts: const [],
    isActive: true,
    nameOnCard: 'Member',
    cardNumber: '1111222233334444',
    type: 'Debit',
    expiryDate: '30/06/2028',
    isVirtual: false,
    isBlock: false,
    stageCode: 'ACTIVE',
    stageName: 'Active',
  );

  setUp(() {
    remote = _MockRemoteDataSource();
    repository = CardRepositoryImpl(
      cardRemoteDataSource: remote,
      networkInfo: _MockNetworkInfo(),
    );
  });

  test('getMyCard returns the remote card', () async {
    when(() => remote.getMyCard(props)).thenAnswer((_) async => card);

    final result = await repository.getMyCard(props);

    expect(result, Right<Failure, DebitCardEntity>(card));
    verify(() => remote.getMyCard(props)).called(1);
  });

  test('getMyCard maps remote exceptions to failures', () async {
    when(
      () => remote.getMyCard(props),
    ).thenThrow(ServerException(message: 'Card unavailable'));

    final result = await repository.getMyCard(props);

    expect(
      result.fold((failure) => failure, (_) => null),
      isA<ServerFailure>().having(
        (failure) => failure.message,
        'message',
        'Card unavailable',
      ),
    );
  });
}
