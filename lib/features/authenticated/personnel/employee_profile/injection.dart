import 'package:pashboi/core/injection.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/employee_profile/data/datasources/employee_details_remote_datasource.dart';
import 'package:pashboi/features/authenticated/personnel/employee_profile/data/repositories/employee_repositories_impl.dart';
import 'package:pashboi/features/authenticated/personnel/employee_profile/domain/repositories/employee_details_repository.dart';
import 'package:pashboi/features/authenticated/personnel/employee_profile/domain/usecase/employee_details_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/employee_profile/presentation/pages/employee_profile_page/bloc/employees_profile_bloc.dart';

void registerEmployeeDetailsModule() {
  // Register Data Sources
  sl.registerLazySingleton<EmployeeDetailsRemoteDataSource>(
    () => EmployeeDetailsRemoteDataSourceImpl(apiService: sl<ApiService>()),
  );

  // Register Repository
  sl.registerLazySingleton<EmployeeDetailsRepository>(
    () => EmployeeRepositoriesImpl(
      employeeDetailsRemoteDataSource: sl<EmployeeDetailsRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Register Use Cases
  sl.registerLazySingleton<EmployeeDetailsUseCase>(
    () => EmployeeDetailsUseCase(
      employeeDetailsRepository: sl<EmployeeDetailsRepository>(),
    ),
  );

  // Register Bloc
  sl.registerFactory<EmployeesProfileBloc>(
    () => EmployeesProfileBloc(
      employeeDetailsUseCase: sl<EmployeeDetailsUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
    ),
  );
}
