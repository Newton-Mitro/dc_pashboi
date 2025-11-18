import 'package:dartz/dartz.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/utils/failure_mapper.dart';
import 'package:pashboi/features/authenticated/transfer/data/datasources/remote.datasource.dart';
import 'package:pashboi/features/authenticated/transfer/domain/entities/dc_bank_entity.dart';
import 'package:pashboi/features/authenticated/transfer/domain/repositories/transfer_repository.dart';
import 'package:pashboi/features/authenticated/transfer/domain/usecases/fetch_dc_accounts_usecase.dart';
import 'package:pashboi/features/authenticated/transfer/domain/usecases/fetch_transfer_account_usecase.dart';
import 'package:pashboi/features/authenticated/transfer/domain/usecases/submit_fund_transfer_usecase.dart';
import 'package:pashboi/features/authenticated/transfer/domain/usecases/submit_transfer_bank_to_dc_usecase.dart';
import 'package:pashboi/features/authenticated/transfer/domain/usecases/submit_transfer_to_bkash_usecase.dart';

class TransferRepositoryImpl implements TransferRepository {
  final TransferRemoteDataSource transferRemoteDataSource;
  final NetworkInfo networkInfo;

  TransferRepositoryImpl({
    required this.transferRemoteDataSource,
    required this.networkInfo,
  });

  @override
  ResultFuture<String> submitFundTransfer(
    SubmitFundTransferProps params,
  ) async {
    try {
      final result = await transferRemoteDataSource.submitFundTransfer(params);
      return Right(result);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }

  @override
  ResultFuture<String> submitTransferBankToDc(
    SubmitTransferBankToDcProps props,
  ) async {
    try {
      final result = await transferRemoteDataSource.submitTransferBankToDc(
        props,
      );
      return Right(result);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }

  @override
  ResultFuture<String> submitTransferToBkash(
    SubmitTransferToBkashProps props,
  ) async {
    try {
      final result = await transferRemoteDataSource.submitTransferToBkash(
        props,
      );
      return Right(result);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }

  @override
  ResultFuture<List<DcBankEntity>> fetchDcBankAccounts(
    FetchDcBankAccountsProps props,
  ) async {
    try {
      final result = await transferRemoteDataSource.fetchDcBankAccounts(props);
      return Right(result);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }

  @override
  ResultFuture<String> fetchTransferAccount(
    FetchTransferAccountProps props,
  ) async {
    try {
      final result = await transferRemoteDataSource.fetchTransferAccountLedgers(
        props,
      );
      return Right(result);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }
}
