import 'package:pashboi/core/injection.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/cards/data/datasources/remote.datasource.dart';
import 'package:pashboi/features/authenticated/cards/data/repositories/repository.impl.dart';
import 'package:pashboi/features/authenticated/cards/domain/repositories/card_repository.dart';
import 'package:pashboi/features/authenticated/cards/domain/usecases/get_my_card_usecase.dart';
import 'package:pashboi/features/authenticated/cards/domain/usecases/issue_debit_card_usecase.dart';
import 'package:pashboi/features/authenticated/cards/domain/usecases/lock_the_card_usecase.dart';
import 'package:pashboi/features/authenticated/cards/domain/usecases/re_issue_debit_card_usecase.dart';
import 'package:pashboi/features/authenticated/cards/domain/usecases/verify_card_pin_usecase.dart';
import 'package:pashboi/features/authenticated/cards/presentation/pages/bloc/debit_card_bloc.dart';

void registerCardModule() async {
  // Register Data Sources
  sl.registerLazySingleton<CardRemoteDataSource>(
    () => CardRemoteDataSourceImpl(apiService: sl<ApiService>()),
  );

  // Register Repository
  sl.registerLazySingleton<CardRepository>(
    () => CardRepositoryImpl(
      cardRemoteDataSource: sl<CardRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Register Use Cases
  sl.registerLazySingleton<GetMyCardUseCase>(
    () => GetMyCardUseCase(cardRepository: sl<CardRepository>()),
  );
  sl.registerLazySingleton<IssueDebitCardUseCase>(
    () => IssueDebitCardUseCase(cardRepository: sl<CardRepository>()),
  );
  sl.registerLazySingleton<ReIssueDebitCardUsecase>(
    () => ReIssueDebitCardUsecase(cardRepository: sl<CardRepository>()),
  );
  sl.registerLazySingleton<LockTheCardUseCase>(
    () => LockTheCardUseCase(cardRepository: sl<CardRepository>()),
  );
  sl.registerLazySingleton<VerifyCardPinUseCase>(
    () => VerifyCardPinUseCase(cardRepository: sl<CardRepository>()),
  );

  // Register Bloc
  sl.registerFactory<DebitCardBloc>(
    () => DebitCardBloc(
      getMyCardUseCase: sl<GetMyCardUseCase>(),
      issueDebitCardUseCase: sl<IssueDebitCardUseCase>(),
      reIssueDebitCardUsecase: sl<ReIssueDebitCardUsecase>(),
      lockTheCardUseCase: sl<LockTheCardUseCase>(),
      verifyCardPinUseCase: sl<VerifyCardPinUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      appLocalizationService: sl<AppLocalizationService>(),
    ),
  );
}
