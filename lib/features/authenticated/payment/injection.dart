import 'package:pashboi/core/injection.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/payment/data/datasources/payment_remote_datasource.dart';
import 'package:pashboi/features/authenticated/payment/data/repositories/payment_repository_impl.dart';
import 'package:pashboi/features/authenticated/payment/domain/repositories/payment_repository.dart';
import 'package:pashboi/features/authenticated/payment/domain/usecases/fetch_payment_services_usecase.dart';
import 'package:pashboi/features/authenticated/payment/domain/usecases/submit_payment_usecase.dart';
import 'package:pashboi/features/authenticated/payment/presentation/pages/payment_page/bloc/payment_steps_bloc.dart';
import 'package:pashboi/features/authenticated/payment/presentation/pages/payment_page/sections/pay_to_section/bloc/payment_service_bloc.dart';

void registerPaymentModule() async {
  // Register Data Sources
  sl.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImpl(apiService: sl<ApiService>()),
  );

  // Register Repository
  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(
      networkInfo: sl<NetworkInfo>(),
      paymentRemoteDataSource: sl<PaymentRemoteDataSource>(),
    ),
  );

  // Register Use Cases
  sl.registerLazySingleton<SubmitPaymentUseCase>(
    () => SubmitPaymentUseCase(paymentRepository: sl<PaymentRepository>()),
  );
  sl.registerLazySingleton<FetchPaymentServicesUseCase>(
    () =>
        FetchPaymentServicesUseCase(paymentRepository: sl<PaymentRepository>()),
  );

  // Register Bloc
  sl.registerFactory<PaymentStepsBloc>(
    () => PaymentStepsBloc(
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      submitPaymentUseCase: sl<SubmitPaymentUseCase>(),
      appLocalizationService: sl<AppLocalizationService>(),
    ),
  );
  sl.registerFactory<PaymentServiceBloc>(
    () => PaymentServiceBloc(
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      fetchPaymentServicesUseCase: sl<FetchPaymentServicesUseCase>(),
      appLocalizationService: sl<AppLocalizationService>(),
    ),
  );
}
