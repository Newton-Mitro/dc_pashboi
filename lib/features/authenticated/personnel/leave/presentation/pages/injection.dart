import 'package:pashboi/core/injection.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/datasource/leave_application_remote_data_source.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/repositories/leave_repositories_impl.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/repositories/leave_repository.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/accepted_fallback_request_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/fallback_request_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/leave_approval_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/leave_history_request_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/leave_type_blance_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/leave_type_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/search_employee_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/submit_leave_application_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/submit_leave_approvel_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/update_leave_application_request_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/presentation/pages/leave_application_page/bloc/search_employee_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/leave/presentation/pages/leave_application_page/bloc/leave_application_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/leave/presentation/pages/leave_approval_page/bloc/leave_approval_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/leave/presentation/pages/leave_approval_page/widget/bloc/submit_leave_approval_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/leave/presentation/pages/leave_fallback_page/bloc/fallback_request_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/leave/presentation/pages/leave_fallback_page/wigets/bloc/accepted_fallback_request_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/leave/presentation/pages/leave_history_page/bloc/leave_history_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/leave/presentation/pages/leave_history_page/wigets/bloc/update_leave_application_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/leave/presentation/pages/leave_info_page/bloc/leave_type_balance_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/leave/presentation/pages/leave_info_page/bloc/leave_type_bloc.dart';

void registerLeaveTypeModule() {
  // Register Data Source
  sl.registerLazySingleton<LeaveApplicationRemoteDataSource>(
    () => LeaveApplicationRemoteDataSourceImpl(apiService: sl<ApiService>()),
  );

  // Register Repository

  sl.registerLazySingleton<LeaveRepository>(
    () => LeaveRepositoriesImpl(
      leaveApplicationRemoteDataSource: sl<LeaveApplicationRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Register Use Cases
  sl.registerLazySingleton<LeaveTypeUseCase>(
    () => LeaveTypeUseCase(leaveRepository: sl<LeaveRepository>()),
  );

  sl.registerLazySingleton<SearchEmployeeUseCase>(
    () => SearchEmployeeUseCase(leaveRepository: sl<LeaveRepository>()),
  );

  sl.registerLazySingleton<SubmitLeaveApplicationUseCase>(
    () => SubmitLeaveApplicationUseCase(leaveRepository: sl<LeaveRepository>()),
  );

  sl.registerLazySingleton<LeaveTypeBalanceUseCase>(
    () => LeaveTypeBalanceUseCase(leaveRepository: sl<LeaveRepository>()),
  );

  sl.registerLazySingleton<FallbackRequestUseCase>(
    () => FallbackRequestUseCase(leaveRepository: sl<LeaveRepository>()),
  );

  sl.registerLazySingleton<AcceptedFallbackUseCase>(
    () => AcceptedFallbackUseCase(leaveRepository: sl<LeaveRepository>()),
  );

  sl.registerLazySingleton<LeaveApprovalUseCase>(
    () => LeaveApprovalUseCase(leaveRepository: sl<LeaveRepository>()),
  );

  sl.registerLazySingleton<SubmitLeaveApprovalUseCase>(
    () => SubmitLeaveApprovalUseCase(leaveRepository: sl<LeaveRepository>()),
  );

  sl.registerLazySingleton<LeaveHistoryRequestUseCase>(
    () => LeaveHistoryRequestUseCase(leaveRepository: sl<LeaveRepository>()),
  );

  sl.registerLazySingleton<UpdateLeaveApplicationRequestUseCase>(
    () => UpdateLeaveApplicationRequestUseCase(
      leaveRepository: sl<LeaveRepository>(),
    ),
  );

  // Register Bloc
  sl.registerFactory<LeaveTypeBloc>(
    () => LeaveTypeBloc(
      leaveTypeUseCase: sl<LeaveTypeUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
    ),
  );

  sl.registerFactory<SearchEmployeeBloc>(
    () => SearchEmployeeBloc(
      searchEmployeeUseCase: sl<SearchEmployeeUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
    ),
  );

  sl.registerFactory<LeaveApplicationBloc>(
    () => LeaveApplicationBloc(
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      submitLeaveApplicationUseCase: sl<SubmitLeaveApplicationUseCase>(),
    ),
  );

  sl.registerFactory<LeaveTypeBalanceBloc>(
    () => LeaveTypeBalanceBloc(
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      leaveTypeBalanceUseCase: sl<LeaveTypeBalanceUseCase>(),
    ),
  );

  sl.registerFactory<FallbackRequestBloc>(
    () => FallbackRequestBloc(
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      fallbackRequestUseCase: sl<FallbackRequestUseCase>(),
    ),
  );

  sl.registerFactory<AcceptedFallbackRequestBloc>(
    () => AcceptedFallbackRequestBloc(
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      acceptedFallbackRequestUseCase: sl<AcceptedFallbackUseCase>(),
    ),
  );

  sl.registerFactory<LeaveApprovalBloc>(
    () => LeaveApprovalBloc(
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      getLeaveApprovalUseCase: sl<LeaveApprovalUseCase>(),
    ),
  );

  sl.registerFactory<SubmitLeaveApprovalBloc>(
    () => SubmitLeaveApprovalBloc(
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      submitLeaveApprovalUseCase: sl<SubmitLeaveApprovalUseCase>(),
    ),
  );

  sl.registerFactory<LeaveHistoryBloc>(
    () => LeaveHistoryBloc(
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      leaveHistoryRequestUseCase: sl<LeaveHistoryRequestUseCase>(),
    ),
  );

  sl.registerFactory<UpdateLeaveApplicationBloc>(
    () => UpdateLeaveApplicationBloc(
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      updateLeaveApplicationRequestUseCase:
          sl<UpdateLeaveApplicationRequestUseCase>(),
    ),
  );
}
