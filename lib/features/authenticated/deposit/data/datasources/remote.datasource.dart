import 'dart:convert';
import 'dart:io';

import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/errors/exceptions.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/features/authenticated/deposit/data/models/voucher_model.dart';
import 'package:pashboi/features/authenticated/deposit/domain/entities/bkash_payment_entity.dart';
import 'package:pashboi/features/authenticated/deposit/domain/entities/voucher_entity.dart';
import 'package:pashboi/features/authenticated/deposit/domain/usecases/fetch_bkash_service_charge_usecase.dart';
import 'package:pashboi/features/authenticated/deposit/domain/usecases/fetch_scheduled_deposits_usecase.dart';
import 'package:pashboi/features/authenticated/deposit/domain/usecases/submit_deposit_from_bkash_usecase.dart';
import 'package:pashboi/features/authenticated/deposit/domain/usecases/submit_deposit_later_usecase.dart';
import 'package:pashboi/features/authenticated/deposit/domain/usecases/submit_deposit_now_usecase.dart';

abstract class DepositRemoteDataSource {
  Future<String> submitDepositNow(SubmitDepositNowProps props);
  Future<List<DepositRequestEntity>> fetchScheduledDeposits(
    FetchScheduledDepositsProps props,
  );
  Future<String> submitDepositLater(SubmitDepositLaterProps props);
  Future<BkashPaymentEntity> submitDepositFromBkash(
    SubmitDepositFromBkashProps props,
  );
  Future<double> fetchBkashServiceCharge(FetchBkashServiceChargeProps props);
}

class DepositRemoteDataSourceImpl implements DepositRemoteDataSource {
  final ApiService apiService;

  DepositRemoteDataSourceImpl({required this.apiService});

  @override
  Future<String> submitDepositNow(SubmitDepositNowProps props) async {
    try {
      final jsonList =
          props.collectionLedgers?.map((ledger) => ledger.toJson()).toList();

      final response = await apiService.post(
        ApiUrls.submitDepositNow,
        data: {
          "AccountHolderName": props.accountHolderName,
          "AccountId": props.accountId,
          "AccountType": props.accountType,
          "CardNo": props.cardNumber,
          "DepositDate": props.depositDate,
          "FromAccountNo": props.accountNumber,
          "LedgerId": props.ledgerId,
          "Remarks": "",
          "RepeatMonths": 0,
          "SecretKey": props.cardPin,
          "ServiceCharge": 0.0,
          "TotalAmount": props.totalDepositAmount,
          "TotalDepositAmount": props.totalDepositAmount,
          "TransactionMethod": props.transactionMethod,
          "OTPRegId": props.otpRegId,
          "OTPValue": props.otpValue,
          "TransactionType": props.transactionType,
          "AccountNo": props.accountNumber,
          "TransactionModels": jsonList,
          "ByUserId": props.userId,
          "EmployeeCode": props.employeeCode,
          "MobileNo": props.mobileNumber,
          "MobileNumber": props.mobileNumber,
          "PersonId": props.personId,
          "RequestFrom": "MobileApp",
          "RolePermissionId": props.rolePermissionId,
          "UID": props.userId,
          "UserName": props.email,
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
  Future<String> submitDepositLater(SubmitDepositLaterProps props) async {
    try {
      final jsonList =
          props.collectionLedgers?.map((ledger) => ledger.toJson()).toList();
      var requestBody = {
        "AccountHolderName": props.accountHolderName,
        "CardNo": props.cardNumber,
        "DepositDate": props.depositDate,
        "FromAccountNo": props.accountNumber,
        "AccountNo": props.accountNumber,
        "AccountId": 0,
        "LedgerId": props.ledgerId,
        "Remarks": "",
        "EffectiveDay": props.dayOfMonth,
        "RepeatMonths": props.repeatMonths,
        "SecretKey": props.cardPin,
        "TotalDepositAmount": props.totalDepositAmount,
        "TransactionMethod": "11",
        "TransactionModels": jsonList,
        "TransactionNumber": '0',
        "TransactionType": "DepositRequest",
        "ByUserId": props.userId,
        "EmployeeCode": props.employeeCode,
        "MobileNo": props.mobileNumber,
        "MobileNumber": props.mobileNumber,
        "OTPRegId": props.otpRegId,
        "OTPValue": props.otpValue,
        "PersonId": props.personId,
        "RequestFrom": "MobileApp",
        "RolePermissionId": props.rolePermissionId,
        "UID": props.userId,
        "UserName": props.email,
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
  Future<BkashPaymentEntity> submitDepositFromBkash(
    SubmitDepositFromBkashProps props,
  ) async {
    try {
      final jsonList =
          props.collectionLedgers?.map((ledger) => ledger.toJson()).toList();

      final response = await apiService.post(
        ApiUrls.bkashCreatePayment,
        data: {
          "TransactionType": props.transactionType,
          "TotalDepositAmount": props.totalDepositAmount,
          "TransactionMethod": props.transactionMethod,
          "TransactionModels": jsonList,
          "ServiceCharge": props.serviceCharge,
          "RolePermissionId": props.rolePermissionId,
          "UID": props.userId,
          "UserName": props.email,
          "ByUserId": props.userId,
          "EmployeeCode": props.employeeCode,
          "MobileNo": props.mobileNumber,
          "MobileNumber": props.mobileNumber,
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
  Future<double> fetchBkashServiceCharge(
    FetchBkashServiceChargeProps props,
  ) async {
    try {
      final response = await apiService.post(
        ApiUrls.bkashServiceCharge,
        data: {
          "UserName": props.email,
          "MobileNo": props.mobileNumber,
          "MobileNumber": props.mobileNumber,
          "RolePermissionId": props.rolePermissionId,
          "ByUserId": props.userId,
          "UID": props.userId,
          "EmployeeCode": props.employeeCode,
          "PersonId": props.personId,
          "RequestFrom": "MobileApp",
          "TotalAmount": props.amount,
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
            final decoded = jsonDecode(dataString);
            return decoded['ServiceCharge']?.toDouble();
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
  Future<List<DepositRequestEntity>> fetchScheduledDeposits(
    FetchScheduledDepositsProps props,
  ) async {
    try {
      final response = await apiService.post(
        ApiUrls.getDepositRequests,
        data: {
          "UserName": props.email,
          "MobileNo": props.mobileNumber,
          "MobileNumber": props.mobileNumber,
          "RolePermissionId": props.rolePermissionId,
          "ByUserId": props.userId,
          "UID": props.userId,
          "EmployeeCode": props.employeeCode,
          "PersonId": props.personId,
          "RequestFrom": "MobileApp",
          "TransactionType": "DepositRequest",
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
            final decoded = jsonDecode(dataString);
            return List<DepositRequestEntity>.from(
              decoded.map((x) => DepositRequestModel.fromJson(x)),
            );
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
