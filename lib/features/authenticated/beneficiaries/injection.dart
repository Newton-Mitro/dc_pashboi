import 'package:pashboi/core/injection.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/beneficiaries/data/datasources/remote.datasource.dart';
import 'package:pashboi/features/authenticated/beneficiaries/data/repositories/beneficiary_repository.impl.dart';
import 'package:pashboi/features/authenticated/beneficiaries/domain/repositories/beneficiary_repository.dart';
import 'package:pashboi/features/authenticated/beneficiaries/domain/usecases/add_beneficiary_usecase.dart';
import 'package:pashboi/features/authenticated/beneficiaries/domain/usecases/fetch_beneficiaries_usecase.dart';
import 'package:pashboi/features/authenticated/beneficiaries/domain/usecases/remove_beneficiary_usecase.dart';
import 'package:pashboi/features/authenticated/beneficiaries/presentation/pages/add_beneficiary_bloc/add_beneficiary_bloc.dart';
import 'package:pashboi/features/authenticated/beneficiaries/presentation/pages/beneficiaries_bloc/beneficiaries_bloc.dart';

void registerBeneficiaryModule() async {
  // Register Data Sources
  sl.registerLazySingleton<BeneficiaryRemoteDataSource>(
    () => BeneficiaryRemoteDataSourceImpl(apiService: sl<ApiService>()),
  );

  // Register Repository
  sl.registerLazySingleton<BeneficiaryRepository>(
    () => BeneficiaryRepositoryImpl(
      beneficiaryRemoteDataSource: sl<BeneficiaryRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Register Use Cases
  sl.registerLazySingleton<FetchBeneficiariesUseCase>(
    () => FetchBeneficiariesUseCase(
      beneficiaryRepository: sl<BeneficiaryRepository>(),
    ),
  );
  sl.registerLazySingleton<AddBeneficiaryUseCase>(
    () => AddBeneficiaryUseCase(
      beneficiaryRepository: sl<BeneficiaryRepository>(),
    ),
  );
  sl.registerLazySingleton<RemoveBeneficiaryUseCase>(
    () => RemoveBeneficiaryUseCase(
      beneficiaryRepository: sl<BeneficiaryRepository>(),
    ),
  );
  // Register Bloc
  sl.registerFactory<BeneficiariesBloc>(
    () => BeneficiariesBloc(
      fetchBeneficiariesUseCase: sl<FetchBeneficiariesUseCase>(),
      removeBeneficiaryUseCase: sl<RemoveBeneficiaryUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      appLocalizationService: sl<AppLocalizationService>(),
    ),
  );

  sl.registerFactory<AddBeneficiaryBloc>(
    () => AddBeneficiaryBloc(
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      addBeneficiaryUseCase: sl<AddBeneficiaryUseCase>(),
      appLocalizationService: sl<AppLocalizationService>(),
    ),
  );
}
