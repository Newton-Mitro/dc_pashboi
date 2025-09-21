import 'package:pashboi/core/injection.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/data/datasource/wooo_remote_data_source.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/data/repositories/wooo_repositories_interface_impl.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/repositories/wooo_repositories.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/get_wooo_approval_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/get_wooo_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/submit_wooo_application_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/update_wooo_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/wooo_approval_submit_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/wooo_type_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/presentation/pages/woo_approval/bloc/get_wooo_approval_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/presentation/pages/woo_approval/wigets/bloc/submit_wooo_approval_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/presentation/pages/wooo_application/bloc/wooo_type_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/presentation/pages/wooo_application/widget/bloc/submit_wooo_application_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/presentation/pages/wooo_history/bloc/get_wooo_data_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/presentation/pages/wooo_history/wigets/bloc/update_wooo_request_bloc.dart';

void registerWoooLeaveTypeModule() {
  // Register Data Source
  sl.registerLazySingleton<WoooRemoteDataSource>(
    () => WoooRemoteDataSourceImpl(apiService: sl<ApiService>()),
  );
  // Register Repository
  sl.registerLazySingleton<WoooRepositories>(
    () => WoooRepositoriesInterfaceImpl(
      woooRemoteDataSource: sl<WoooRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );
  // Register Use Cases
  sl.registerLazySingleton<WoooTypeUseCase>(
    () => WoooTypeUseCase(woooRepositories: sl<WoooRepositories>()),
  );

  sl.registerLazySingleton<SubmitWoooApplicationUseCase>(
    () =>
        SubmitWoooApplicationUseCase(woooRepositories: sl<WoooRepositories>()),
  );

  sl.registerLazySingleton<GetWoooDataUseCase>(
    () => GetWoooDataUseCase(woooRepositories: sl<WoooRepositories>()),
  );

  sl.registerLazySingleton<UpdateWoooUseCase>(
    () => UpdateWoooUseCase(woooRepositories: sl<WoooRepositories>()),
  );

  sl.registerLazySingleton<GetWoooApprovalUsecase>(
    () => GetWoooApprovalUsecase(woooRepositories: sl<WoooRepositories>()),
  );

  sl.registerLazySingleton<WoooApprovalSubmitUseCase>(
    () => WoooApprovalSubmitUseCase(woooRepositories: sl<WoooRepositories>()),
  );
  // Register Bloc
  sl.registerFactory<WoooTypeBloc>(
    () => WoooTypeBloc(
      woooTypeUseCase: sl<WoooTypeUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
    ),
  );

  sl.registerFactory<SubmitWoooApplicationBloc>(
    () => SubmitWoooApplicationBloc(
      submitWoooApplicationUseCase: sl<SubmitWoooApplicationUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
    ),
  );

  sl.registerFactory<GetWoooDataBloc>(
    () => GetWoooDataBloc(
      getWoooDataUseCase: sl<GetWoooDataUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
    ),
  );

  sl.registerFactory<UpdateWoooRequestBloc>(
    () => UpdateWoooRequestBloc(
      updateWoooUseCase: sl<UpdateWoooUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
    ),
  );

  sl.registerFactory<GetWoooApprovalBloc>(
    () => GetWoooApprovalBloc(
      getWoooApprovalUsecase: sl<GetWoooApprovalUsecase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
    ),
  );

  sl.registerFactory<SubmitWoooApprovalBloc>(
    () => SubmitWoooApprovalBloc(
      woooApprovalSubmitUseCase: sl<WoooApprovalSubmitUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
    ),
  );
}
