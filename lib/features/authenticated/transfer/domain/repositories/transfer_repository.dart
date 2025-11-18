import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/domain/entities/collection_aggregate.dart';
import 'package:pashboi/features/authenticated/transfer/domain/entities/dc_bank_entity.dart';
import 'package:pashboi/features/authenticated/transfer/domain/usecases/fetch_dc_accounts_usecase.dart';
import 'package:pashboi/features/authenticated/transfer/domain/usecases/fetch_transfer_account_usecase.dart';
import 'package:pashboi/features/authenticated/transfer/domain/usecases/submit_fund_transfer_usecase.dart';
import 'package:pashboi/features/authenticated/transfer/domain/usecases/submit_transfer_bank_to_dc_usecase.dart';
import 'package:pashboi/features/authenticated/transfer/domain/usecases/submit_transfer_to_bkash_usecase.dart';

abstract class TransferRepository {
  ResultFuture<String> submitFundTransfer(SubmitFundTransferProps props);
  ResultFuture<String> submitTransferBankToDc(
    SubmitTransferBankToDcProps props,
  );
  ResultFuture<String> submitTransferToBkash(SubmitTransferToBkashProps props);
  ResultFuture<List<DcBankEntity>> fetchDcBankAccounts(
    FetchDcBankAccountsProps props,
  );

  ResultFuture<String> fetchTransferAccount(FetchTransferAccountProps props);
}
