import 'package:pashboi/core/injection.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/data/datasource/attendance_remote_data_source.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/data/repositories/attendance_repository_interface_impl.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/domain/repositories/attendance_repository_interface.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/domain/usecase/get_attandance_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/domain/usecase/today_punch_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/presentation/pages/attendance_calender/bloc/attendance_calender_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/presentation/pages/todays_punch/bloc/today_punch_bloc.dart';

void registerAttendanceModule() {
  // Register Data Source
  sl.registerLazySingleton<AttendanceRemoteDataSource>(
    () => AttendanceRemoteDataSourceImpl(apiService: sl<ApiService>()),
  );

  // Register Repository
  sl.registerLazySingleton<AttendanceRepositoryInterface>(
    () => AttendanceRepositoryInterfaceImpl(
      attendanceRemoteDataSource: sl<AttendanceRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Register Use Cases
  sl.registerLazySingleton<AttendanceUseCase>(
    () => AttendanceUseCase(
      attendanceRepository: sl<AttendanceRepositoryInterface>(),
    ),
  );

  sl.registerLazySingleton<TodayPunchUseCase>(
    () => TodayPunchUseCase(
      repositoryInterface: sl<AttendanceRepositoryInterface>(),
    ),
  );

  // Register Bloc
  sl.registerFactory<AttendanceCalenderBloc>(
    () => AttendanceCalenderBloc(
      attendanceUseCase: sl<AttendanceUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
    ),
  );

  sl.registerFactory<TodayPunchBloc>(
    () => TodayPunchBloc(
      todayPunchUseCase: sl<TodayPunchUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
    ),
  );
}
