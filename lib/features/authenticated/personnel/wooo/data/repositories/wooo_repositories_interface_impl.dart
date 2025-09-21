import 'package:dartz/dartz.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/utils/failure_mapper.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/data/datasource/wooo_remote_data_source.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/data/model/wooo_data_model.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/data/model/wooo_type_model.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/repositories/wooo_repositories.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/get_wooo_approval_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/get_wooo_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/submit_wooo_application_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/update_wooo_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/wooo_approval_submit_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/wooo_type_usecase.dart';

class WoooRepositoriesInterfaceImpl implements WoooRepositories {
  final WoooRemoteDataSource woooRemoteDataSource;
  final NetworkInfo networkInfo;

  WoooRepositoriesInterfaceImpl({
    required this.woooRemoteDataSource,
    required this.networkInfo,
  });

  @override
  ResultFuture<List<WoooTypeModel>> getWooType(
    WooTypeUseCaseProps params,
  ) async {
    try {
      final result = await woooRemoteDataSource.fetchWoooTypes(params);
      return Right(result);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }

  @override
  ResultFuture<String> submitWoooApplication(
    SubmitWoooApplicationPropsProps params,
  ) async {
    try {
      final result = await woooRemoteDataSource.submitWoooApplication(params);
      return Right(result);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }

  @override
  ResultFuture<List<WoooDataModel>> getWoooData(GetWoooProps params) async {
    try {
      final result = await woooRemoteDataSource.getWoooData(params);
      return Right(result);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }

  @override
  ResultFuture<String> updateWoooRequest(UpdateWoooProps params) async {
    try {
      final result = await woooRemoteDataSource.updateWoooData(params);
      return Right(result);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }

  @override
  ResultFuture<List<WoooDataModel>> getWoooApprovalData(
    GetWoooApprovalProps params,
  ) async {
    try {
      final result = await woooRemoteDataSource.fetchWoooApprovalData(params);
      return Right(result);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }

  @override
  ResultFuture<String> submitWoooApprovalRequest(
    WoooApprovalSubmitUseCaseProps params,
  ) async {
    try {
      final result = await woooRemoteDataSource.submitWoooApprovalData(params);
      return Right(result);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }
}
