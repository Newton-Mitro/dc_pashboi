import 'package:dartz/dartz.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/features/authenticated/personnel/employee_profile/data/datasources/employee_details_remote_datasource.dart';
import 'package:pashboi/features/authenticated/personnel/employee_profile/domain/entities/employee_details_entity.dart';
import 'package:pashboi/features/authenticated/personnel/employee_profile/domain/repositories/employee_details_repository.dart';
import 'package:pashboi/features/authenticated/personnel/employee_profile/domain/usecase/employee_details_usecase.dart';

class EmployeeRepositoriesImpl implements EmployeeDetailsRepository {
  final EmployeeDetailsRemoteDataSource employeeDetailsRemoteDataSource;
  final NetworkInfo networkInfo;

  EmployeeRepositoriesImpl({
    required this.employeeDetailsRemoteDataSource,
    required this.networkInfo,
  });

  @override
  ResultFuture<EmployeeDetailsEntity> getEmployeeDetails(
    EmployeeDetailsProps props,
  ) async {
    try {
      if (!await networkInfo.isConnected) {
        throw Exception("No internet connection");
      }

      final data = await employeeDetailsRemoteDataSource
          .fetchEmployeeDetailsDataSource(props);

      return Right(data);
    } catch (e) {
      return Future.error(e);
    }
  }
}
