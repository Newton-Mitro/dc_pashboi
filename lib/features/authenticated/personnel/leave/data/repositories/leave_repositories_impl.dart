import 'package:dartz/dartz.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/utils/failure_mapper.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/datasource/leave_application_remote_data_source.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/get_leave_type_blance_dto.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/leave_type_model.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/search_employee_model.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/entities/leave_application_entites.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/repositories/leave_repository.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/fallback_request_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/leave_approval_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/leave_history_request_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/leave_type_usecase.dart';

class LeaveRepositoriesImpl implements LeaveRepository {
  final LeaveApplicationRemoteDataSource leaveApplicationRemoteDataSource;
  final NetworkInfo networkInfo;

  LeaveRepositoriesImpl({
    required this.leaveApplicationRemoteDataSource,
    required this.networkInfo,
  });

  @override
  ResultFuture<List<LeaveTypeModel>> getLeaveType(LeaveTypeProps props) async {
    try {
      final result = await leaveApplicationRemoteDataSource.fetchLeaveType(
        props,
      );
      return Right(result);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }

  @override
  ResultFuture<LeaveTypeBalanceDto> getLeaveTypeBalance(props) async {
    try {
      final result = await leaveApplicationRemoteDataSource
          .fetchLeaveTypeBalance(props);
      return Right(result);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }

  @override
  ResultFuture<List<SearchEmployeeModel>> getSearchEmployee(params) async {
    try {
      final result = await leaveApplicationRemoteDataSource.fetchEmployee(
        params,
      );
      return Right(result);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }

  @override
  ResultFuture<String> submitLeaveApplication(params) async {
    try {
      final result = await leaveApplicationRemoteDataSource
          .submitLeaveApplication(params);
      return Right(result);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }

  @override
  ResultFuture<List<LeaveApplicationEntities>> getFallbackRequest(
    FallbackRequestUseCaseProps params,
  ) async {
    try {
      final result = await leaveApplicationRemoteDataSource
          .fetchFallbackRequest(params);

      final fallbackApplications =
          result.map((e) => e as LeaveApplicationEntities).toList();

      return Right(fallbackApplications);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }

  @override
  ResultFuture<String> getAcceptedFallbackRequest(params) async {
    try {
      final result = await leaveApplicationRemoteDataSource.acceptedFallback(
        params,
      );
      return Right(result);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }

  @override
  ResultFuture<List<LeaveApplicationEntities>> getLeaveApproval(
    LeaveApprovalProps props,
  ) async {
    try {
      final result = await leaveApplicationRemoteDataSource.fetchLeaveApproval(
        props,
      );

      final leaveApplications =
          result.map((e) => e as LeaveApplicationEntities).toList();

      return Right(leaveApplications);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }

  @override
  ResultFuture<String> submitLeaveApproval(params) async {
    try {
      final result = await leaveApplicationRemoteDataSource.submitLeaveApproval(
        params,
      );
      return Right(result);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }

  //
  @override
  ResultFuture<List<LeaveApplicationEntities>> getLeaveHistory(
    LeaveHistoryRequestProps props,
  ) async {
    try {
      final result = await leaveApplicationRemoteDataSource.fetchLeaveHistory(
        props,
      );

      final leaveApplications =
          result.map((e) => e as LeaveApplicationEntities).toList();

      return Right(leaveApplications);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }

  @override
  ResultFuture<String> updateLeaveApplication(params) async {
    try {
      final result = await leaveApplicationRemoteDataSource
          .updateLeaveApplication(params);
      return Right(result);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }
}
