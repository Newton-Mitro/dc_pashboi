import 'dart:io';

import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/errors/exceptions.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/core/utils/json_util.dart';
import 'package:pashboi/features/authenticated/my_loans/data/models/against_loan_interest_model.dart';
import 'package:pashboi/features/authenticated/my_loans/data/models/collateral_info_entity.dart';
import 'package:pashboi/features/authenticated/my_loans/data/models/loan_account_model.dart';
import 'package:pashboi/features/authenticated/my_loans/data/models/loan_product_model.dart';
import 'package:pashboi/features/authenticated/my_loans/data/models/loan_transaction_model.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/fetch_against_loan_interest_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/fetch_eligible_collateral_accounts_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/fetch_loan_details_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/fetch_loan_statement_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/fetch_my_loans_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/fetch_eligible_loan_products_usecase.dart';

abstract class LoanRemoteDataSource {
  Future<List<LoanAccountModel>> fetchMyLoans(FetchMyLoansProps props);
  Future<LoanAccountModel> fetchLoanDetails(FetchLoanDetailsProps props);
  Future<List<LoanProductModel>> fetchEligibleLoanProducts(
    FetchEligibleLoanProductsProps props,
  );
  Future<CollateralInfoModel> fetchEligibleCollateralAccounts(
    FetchEligibleCollateralAccountsProps props,
  );

  Future<AgainstLoanInterestModel> fetchAgainstLoanInterest(
    FetchAgainstLoanInterestProps props,
  );

  Future<List<LoanTransactionModel>> fetchLoanStatement(
    FetchLoanStatementProps props,
  );
}

class LoanRemoteDataSourceImpl implements LoanRemoteDataSource {
  final ApiService apiService;

  LoanRemoteDataSourceImpl({required this.apiService});

  @override
  Future<LoanAccountModel> fetchLoanDetails(FetchLoanDetailsProps props) async {
    try {
      final response = await apiService.post(
        ApiUrls.getLoanDetails,
        data: {
          "UserName": props.email,
          "UID": props.userId,
          "ByUserId": props.userId,
          "RolePermissionId": props.rolePermissionId,
          "PersonId": props.personId,
          "EmployeeCode": props.employeeCode,
          "MobileNumber": props.mobileNumber,
          "MobileNo": props.mobileNumber,
          "LoanId": props.loanNumber,
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
            final jsonResponse = JsonUtil.decodeModelList(dataString);

            final loanDetails = LoanAccountModel.fromJson(jsonResponse.first);

            return loanDetails;
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
  Future<List<LoanTransactionModel>> fetchLoanStatement(
    FetchLoanStatementProps props,
  ) async {
    try {
      final response = await apiService.post(
        ApiUrls.getLoanStatement,
        data: {
          "UserName": props.email,
          "UID": props.userId,
          "ByUserId": props.userId,
          "RolePermissionId": props.rolePermissionId,
          "PersonId": props.personId,
          "EmployeeCode": props.employeeCode,
          "MobileNumber": props.mobileNumber,
          "MobileNo": props.mobileNumber,
          "loanNo": props.loanNumber,
          "StartDate": props.fromDate,
          "EndDate": props.toDate,
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
            final jsonResponse = JsonUtil.decodeModelList(dataString);

            return jsonResponse
                .map((json) => LoanTransactionModel.fromJson(json))
                .toList();
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
  Future<List<LoanAccountModel>> fetchMyLoans(FetchMyLoansProps props) async {
    try {
      final response = await apiService.post(
        ApiUrls.getMyLoans,
        data: {
          "UserName": props.email,
          "UID": props.userId,
          "ByUserId": props.userId,
          "RolePermissionId": props.rolePermissionId,
          "PersonId": props.personId,
          "EmployeeCode": props.employeeCode,
          "MobileNumber": props.mobileNumber,
          "MobileNo": props.mobileNumber,
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
            final jsonResponse = JsonUtil.decodeModelList(dataString);

            final myLoans =
                jsonResponse.map((json) {
                  return LoanAccountModel.fromJson(json);
                }).toList();

            return myLoans;
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
  Future<List<LoanProductModel>> fetchEligibleLoanProducts(
    FetchEligibleLoanProductsProps props,
  ) async {
    try {
      final response = await apiService.post(
        ApiUrls.fetchEligibleLoanProducts,
        data: {
          "UserName": props.email,
          "UID": props.userId,
          "ByUserId": props.userId,
          "RolePermissionId": props.rolePermissionId,
          "PersonId": props.personId,
          "EmployeeCode": props.employeeCode,
          "MobileNumber": props.mobileNumber,
          "MobileNo": props.mobileNumber,
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
            final jsonResponse = JsonUtil.decodeModelList(dataString);

            final myLoans =
                jsonResponse.map((json) {
                  return LoanProductModel.fromJson(json);
                }).toList();

            return myLoans;
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
  Future<CollateralInfoModel> fetchEligibleCollateralAccounts(
    FetchEligibleCollateralAccountsProps props,
  ) async {
    try {
      final response = await apiService.post(
        ApiUrls.fetchEligibleCollateralAccounts,
        data: {
          "UserName": props.email,
          "UID": props.userId,
          "ByUserId": props.userId,
          "RolePermissionId": props.rolePermissionId,
          "PersonId": props.personId,
          "EmployeeCode": props.employeeCode,
          "MobileNumber": props.mobileNumber,
          "MobileNo": props.mobileNumber,
          "ProductCode": props.productCode,
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
            final jsonResponse = JsonUtil.decodeModelList(dataString);

            final collageralAccount = CollateralInfoModel.fromJson(
              jsonResponse.first,
            );

            return collageralAccount;
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
  Future<AgainstLoanInterestModel> fetchAgainstLoanInterest(
    FetchAgainstLoanInterestProps props,
  ) async {
    try {
      final response = await apiService.post(
        ApiUrls.fetchEligibleCollateralAccounts,
        data: {
          "UserName": props.email,
          "UID": props.userId,
          "ByUserId": props.userId,
          "RolePermissionId": props.rolePermissionId,
          "PersonId": props.personId,
          "EmployeeCode": props.employeeCode,
          "MobileNumber": props.mobileNumber,
          "MobileNo": props.mobileNumber,
          "loanApplication": {
            "AccountIds": props.accountIds,
            "LoanProductCode": props.productCode,
            "SuretyAccountIds": props.accountIds,
          },
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
            final jsonResponse = JsonUtil.decodeModelList(dataString);

            final loanInterest = AgainstLoanInterestModel.fromJson(
              jsonResponse.first,
            );

            return loanInterest;
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
