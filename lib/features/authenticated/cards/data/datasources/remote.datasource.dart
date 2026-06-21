import 'dart:convert';
import 'dart:io';

import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/errors/exceptions.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/features/authenticated/cards/data/models/card_model.dart';
import 'package:pashboi/features/authenticated/cards/domain/entities/debit_card_entity.dart';
import 'package:pashboi/features/authenticated/cards/domain/usecases/get_my_card_usecase.dart';
import 'package:pashboi/features/authenticated/cards/domain/usecases/issue_debit_card_usecase.dart';
import 'package:pashboi/features/authenticated/cards/domain/usecases/lock_the_card_usecase.dart';
import 'package:pashboi/features/authenticated/cards/domain/usecases/re_issue_debit_card_usecase.dart';
import 'package:pashboi/features/authenticated/cards/domain/usecases/verify_card_pin_usecase.dart';

abstract class CardRemoteDataSource {
  Future<String> issueDebitCard(
    IssueDebitCardUseCaseProps issueDebitCardUseCaseProps,
  );

  Future<String> reIssueDebitCard(
    ReIssueDebitCardUsecaseProps reIssueDebitCardUsecaseProps,
  );

  Future<DebitCardEntity> getMyCard(
    GetMyCardUseCaseProps getMyCardUseCaseProps,
  );

  Future<String> lockTheCard(LockTheCardUseCaseProps lockTheCardUseCaseProps);

  Future<String> verifyCardPIN(
    VerifyCardPinUseCaseProps verifyCardPinUseCaseProps,
  );
}

class CardRemoteDataSourceImpl implements CardRemoteDataSource {
  final ApiService apiService;

  CardRemoteDataSourceImpl({required this.apiService});

  @override
  Future<String> issueDebitCard(
    IssueDebitCardUseCaseProps issueDebitCardUseCaseProps,
  ) async {
    try {
      final response = await apiService.post(
        ApiUrls.issueCard,
        data: {
          "UserName": issueDebitCardUseCaseProps.email,
          "CardTypeCode": issueDebitCardUseCaseProps.cardTypeCode,
          "WithCard": issueDebitCardUseCaseProps.withCard,
          "MobileNumber": issueDebitCardUseCaseProps.mobileNumber,
          "RolePermission": issueDebitCardUseCaseProps.rolePermissionId,
          "ByUserId": issueDebitCardUseCaseProps.userId,
          "EmployeeCode": issueDebitCardUseCaseProps.employeeCode,
          "PersonId": issueDebitCardUseCaseProps.personId,
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
  Future<DebitCardEntity> getMyCard(
    GetMyCardUseCaseProps getMyCardUseCaseProps,
  ) async {
    try {
      final response = await apiService.post(
        ApiUrls.getMyCards,
        data: {
          "UserName": getMyCardUseCaseProps.email,
          "MobileNumber": getMyCardUseCaseProps.mobileNumber,
          "RolePermissionId": getMyCardUseCaseProps.rolePermissionId,
          "ByUserId": getMyCardUseCaseProps.userId,
          "EmployeeCode": getMyCardUseCaseProps.employeeCode,
          "PersonId": getMyCardUseCaseProps.personId,
          "UID": getMyCardUseCaseProps.userId,
          "MobileNo": getMyCardUseCaseProps.mobileNumber,
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
            final decoded = jsonDecode(dataString);

            if (decoded is List && decoded.isNotEmpty) {
              final firstItem = decoded.first;
              return DebitCardModel.fromJson(firstItem);
            } else {
              throw ServerException(message: 'Card list is empty or invalid');
            }
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
  Future<String> lockTheCard(
    LockTheCardUseCaseProps lockTheCardUseCaseProps,
  ) async {
    try {
      final response = await apiService.post(
        ApiUrls.lockTheCard,
        data: {
          "UserName": lockTheCardUseCaseProps.email,
          "CardNo": lockTheCardUseCaseProps.cardNumber,
          "AccountNo": lockTheCardUseCaseProps.accountNumber,
          "NameOnCard": lockTheCardUseCaseProps.nameOnCard,
          "MobileNumber": lockTheCardUseCaseProps.mobileNumber,
          "RolePermission": lockTheCardUseCaseProps.rolePermissionId,
          "ByUserId": lockTheCardUseCaseProps.userId,
          "EmployeeCode": lockTheCardUseCaseProps.employeeCode,
          "PersonId": lockTheCardUseCaseProps.personId,
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
  Future<String> reIssueDebitCard(
    ReIssueDebitCardUsecaseProps reIssueDebitCardUsecaseProps,
  ) async {
    try {
      final response = await apiService.post(
        ApiUrls.cardReIssue,
        data: {
          "UserName": reIssueDebitCardUsecaseProps.email,
          "CardTypeCode": reIssueDebitCardUsecaseProps.cardTypeCode,
          "CardNumber": reIssueDebitCardUsecaseProps.cardNumber,
          "IsVirtual": reIssueDebitCardUsecaseProps.virtualCard,
          "NameOnCard": reIssueDebitCardUsecaseProps.nameOnCard,
          "MobileNumber": reIssueDebitCardUsecaseProps.mobileNumber,
          "RolePermission": reIssueDebitCardUsecaseProps.rolePermissionId,
          "ByUserId": reIssueDebitCardUsecaseProps.userId,
          "EmployeeCode": reIssueDebitCardUsecaseProps.employeeCode,
          "PersonId": reIssueDebitCardUsecaseProps.personId,
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
  Future<String> verifyCardPIN(
    VerifyCardPinUseCaseProps verifyCardPinUseCaseProps,
  ) async {
    try {
      final response = await apiService.post(
        ApiUrls.verifyCardPIN,
        data: {
          "UserName": verifyCardPinUseCaseProps.email,
          "CardNo": verifyCardPinUseCaseProps.cardNumber,
          "AccountNo": verifyCardPinUseCaseProps.accountNumber,
          "SecretKey": verifyCardPinUseCaseProps.cardPIN,
          "NameOnCard": verifyCardPinUseCaseProps.nameOnCard,
          "MobileNumber": verifyCardPinUseCaseProps.mobileNumber,
          "MobileNo": verifyCardPinUseCaseProps.mobileNumber,
          "RolePermissionId": verifyCardPinUseCaseProps.rolePermissionId,
          "ByUserId": verifyCardPinUseCaseProps.userId,
          "UID": verifyCardPinUseCaseProps.userId,
          "EmployeeCode": verifyCardPinUseCaseProps.employeeCode,
          "PersonId": verifyCardPinUseCaseProps.personId,
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
            final Map<String, dynamic> data = jsonDecode(dataString);
            final String otpRegId = data['OTPRegId'] ?? '';

            return otpRegId;
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
