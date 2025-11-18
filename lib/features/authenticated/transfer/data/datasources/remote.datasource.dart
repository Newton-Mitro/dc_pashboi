import 'dart:convert';
import 'dart:io';

import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/errors/exceptions.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/core/utils/json_util.dart';
import 'package:pashboi/features/authenticated/transfer/data/models/dc_bank_model.dart';
import 'package:pashboi/features/authenticated/transfer/domain/entities/dc_bank_entity.dart';
import 'package:pashboi/features/authenticated/transfer/domain/usecases/fetch_dc_accounts_usecase.dart';
import 'package:pashboi/features/authenticated/transfer/domain/usecases/fetch_transfer_account_usecase.dart';
import 'package:pashboi/features/authenticated/transfer/domain/usecases/submit_fund_transfer_usecase.dart';
import 'package:pashboi/features/authenticated/transfer/domain/usecases/submit_transfer_bank_to_dc_usecase.dart';
import 'package:pashboi/features/authenticated/transfer/domain/usecases/submit_transfer_to_bkash_usecase.dart';

abstract class TransferRemoteDataSource {
  Future<String> submitFundTransfer(SubmitFundTransferProps props);
  Future<String> submitTransferBankToDc(SubmitTransferBankToDcProps props);
  Future<String> submitTransferToBkash(SubmitTransferToBkashProps props);
  Future<List<DcBankEntity>> fetchDcBankAccounts(
    FetchDcBankAccountsProps props,
  );
  Future<String> fetchTransferAccountLedgers(FetchTransferAccountProps props);
}

class TransferRemoteDataSourceImpl implements TransferRemoteDataSource {
  final ApiService apiService;

  TransferRemoteDataSourceImpl({required this.apiService});

  @override
  Future<String> submitFundTransfer(SubmitFundTransferProps props) async {
    try {
      final response = await apiService.post(
        ApiUrls.submitFundTransfer,
        data: {
          "AccHolder": props.accountNumber,
          "AccountNo": props.accountNumber,
          "AccTransfer": props.toAccountNumber,
          "AccType": props.accountType,
          "Amount": props.amount,
          "OTPRegId": props.otpRegId,
          "OTPValue": props.otpValue,
          "CardNo": props.cardNumber,
          "NameOnCard": props.nameOnCard,
          "SecretKey": props.cardPin,
          "UserName": props.email,
          "MobileNo": props.mobileNumber,
          "MobileNumber": props.mobileNumber,
          "RolePermissionId": props.rolePermissionId,
          "ByUserId": props.userId,
          "UID": props.userId,
          "EmployeeCode": props.employeeCode,
          "PersonId": props.personId,
          "RequestFrom": "MobileApp",
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        final dataString = response.data?['Data'];
        final errorMessage = response.data?['Message'];
        final statusMessage = response.data?['Status'];
        if (dataString == null || dataString.isNotEmpty) {
          if (statusMessage != null && statusMessage == "failed") {
            throw ServerException(message: errorMessage);
          } else {
            return dataString;
          }
        }
        throw ServerException(message: "Server Error");
      } else {
        throw ServerException(message: "Server Error");
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> submitTransferBankToDc(
    SubmitTransferBankToDcProps props,
  ) async {
    try {
      var requestBody = {
        "AccountHolderName": props.nameOnCard,
        "AccountId": props.accountId,
        "AccountType": "Bank Account",
        "FromAccountNo": props.accountNumber, // Bank account number
        "TransactionType": "DepositRequest",
        "DepositDate": props.depositDate,
        "LedgerId": props.ledgerId,
        "Remarks": "",
        "RepeatMonths": 0,
        "ReferenceAccountNo": props.accountNumber, // Bank account number
        "TransactionNumber": props.transactionNumber,
        "bankRoutingNumber": props.bankRoutingNumber,
        "TransactionReceipt": props.transactionReceipt,
        "TotalDepositAmount": props.totalDepositAmount,
        "TransactionMethod": "12",

        "NameOnCard": props.nameOnCard,
        "TotalAmount": props.totalDepositAmount,
        "CardNo": props.cardNumber,
        "AccountNo": props.accountNumber, // Deposit saving account
        "EffectiveDay": 0,
        "SecretKey": props.cardPin,
        "TransactionModels": props.collectionLedgers,

        "ByUserId": props.userId,
        "EmployeeCode": props.employeeCode,
        "MobileNo": props.mobileNumber,
        "MobileNumber": props.mobileNumber,
        "OTPRegId": props.otpRegId,
        "OTPValue": props.otpValue,
        "PersonId": props.personId,
        "RolePermissionId": props.rolePermissionId,
        "UID": props.userId,
        "UserName": props.email,
        "RequestFrom": "MobileApp",
      };
      final response = await apiService.post(
        ApiUrls.submitDepositLater,
        data: requestBody,
      );

      if (response.statusCode == HttpStatus.ok) {
        final dataString = response.data?['Data'];
        final errorMessage = response.data?['Message'];
        final statusMessage = response.data?['Status'];
        if (dataString == null || dataString.isNotEmpty) {
          if (statusMessage != null && statusMessage == "failed") {
            throw ServerException(message: errorMessage);
          } else {
            return dataString;
          }
        }
        throw ServerException(message: "Server Error");
      } else {
        throw ServerException(message: "Server Error");
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> submitTransferToBkash(SubmitTransferToBkashProps props) async {
    try {
      final response = await apiService.post(
        ApiUrls.bKashWithdrawal,
        data: {
          "TransactionType": "bKashWithdrawalRequest",
          "TransactionMethod": "17",
          "FromAccountNo": props.accountNumber,
          "TransactionModels": [
            {
              "AccountNo": props.toBkashNumber,
              "AccountType": "bKash Account",
              "LedgerId": 0,
              "Amount": props.amount,
              "Balance": 0,
              "AccountId": -1,
              "AccountTypeCode": "-1",
              "PlType": 0,
            },
          ],
          "TotalDepositAmount": props.amount,
          "OTPRegId": props.otpRegId,
          "OTPValue": props.otpValue,
          "CardNo": props.cardNumber,
          "NameOnCard": props.nameOnCard,
          "SecretKey": props.cardPin,
          "UserName": props.email,
          "MobileNo": props.mobileNumber,
          "MobileNumber": props.mobileNumber,
          "RolePermissionId": props.rolePermissionId,
          "ByUserId": props.userId,
          "UID": props.userId,
          "EmployeeCode": props.employeeCode,
          "PersonId": props.personId,
          "RequestFrom": "MobileApp",
        },
      );

      // return "Transaction Initiated Successfully";

      if (response.statusCode == HttpStatus.ok) {
        final dataString = response.data?['Data'];
        final errorMessage = response.data?['Message'];
        final statusMessage = response.data?['Status'];
        if (dataString == null || dataString.isNotEmpty) {
          if (statusMessage != null && statusMessage == "failed") {
            throw ServerException(message: errorMessage);
          } else {
            return dataString;
          }
        }
        throw ServerException(message: "Server Error");
      } else {
        throw ServerException(message: "Server Error");
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<DcBankEntity>> fetchDcBankAccounts(
    FetchDcBankAccountsProps props,
  ) async {
    try {
      var requestBody = {
        "UserName": props.email,
        "UID": props.userId,
        "ByUserId": props.userId,
        "RolePermissionId": props.rolePermissionId,
        "PersonId": props.personId,
        "EmployeeCode": props.employeeCode,
        "MobileNumber": props.mobileNumber,
        "MobileNo": props.mobileNumber,
        "RequestFrom": "MobileApp",
      };

      var jsonEncodedRequestBody = jsonEncode(requestBody);

      final response = await apiService.post(
        ApiUrls.getBankAccounts,
        data: requestBody,
      );

      if (response.statusCode == HttpStatus.ok) {
        final dataString = response.data?['Data'];
        final errorMessage = response.data?['Message'];
        final statusMessage = response.data?['Status'];
        if (dataString == null || dataString.isNotEmpty) {
          if (statusMessage != null && statusMessage == "failed") {
            throw ServerException(message: errorMessage);
          } else {
            final jsonResponse = JsonUtil.decodeModelList(dataString);

            final depositAccounts =
                jsonResponse.map((json) {
                  return DcBankModel.fromJson(json);
                }).toList();

            return depositAccounts;
          }
        }
        throw ServerException(message: "Server Error");
      } else {
        throw ServerException(message: "Server Error");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> fetchTransferAccountLedgers(
    FetchTransferAccountProps props,
  ) async {
    try {
      final response = await apiService.post(
        ApiUrls.fetchTransferAccount,
        data: {
          "UserName": props.email,
          "TransferToAcc": props.searchText,
          "ModuleCode": props.moduleCode,
          "MobileNumber": props.mobileNumber,
          "RolePermission": props.rolePermissionId,
          "ByUserId": props.userId,
          "EmployeeCode": props.employeeCode,
          "PersonId": props.personId,
          "RequestFrom": "MobileApp",
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        final dataString = response.data?['Data'];
        final errorMessage = response.data?['Message'];
        final statusMessage = response.data?['Status'];
        if (dataString == null || dataString.isNotEmpty) {
          if (statusMessage != null && statusMessage == "failed") {
            throw ServerException(message: errorMessage);
          } else {
            return dataString;
          }
        }
        throw ServerException(message: "Server Error");
      } else {
        throw ServerException(message: "Server Error");
      }
    } catch (e) {
      rethrow;
    }
  }
}
