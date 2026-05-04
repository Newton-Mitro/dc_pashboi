import 'dart:convert';
import 'dart:io';

import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/errors/exceptions.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/core/utils/json_util.dart';
import 'package:pashboi/features/authenticated/my_loans/data/models/against_loan_interest_model.dart';
import 'package:pashboi/features/authenticated/my_loans/data/models/collateral_info_entity.dart';
import 'package:pashboi/features/authenticated/my_loans/data/models/deposit_loan_eligibility_model.dart';
import 'package:pashboi/features/authenticated/my_loans/data/models/eligible_conditions_model.dart';
import 'package:pashboi/features/authenticated/my_loans/data/models/instant_loan_eligibility_model.dart';
import 'package:pashboi/features/authenticated/my_loans/data/models/loan_account_model.dart';
import 'package:pashboi/features/authenticated/my_loans/data/models/loan_product_model.dart';
import 'package:pashboi/features/authenticated/my_loans/data/models/loan_transaction_model.dart';
import 'package:pashboi/features/authenticated/my_loans/data/models/product_loan_collateral_account_model.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/product_loan_collateral_accounts_dto.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/check_instant_loan_eligibility_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/deposit_loan_eligibility_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/fetch_against_loan_interest_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/fetch_eligible_collateral_accounts_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/fetch_loan_details_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/fetch_loan_statement_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/fetch_my_loans_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/fetch_eligible_loan_products_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/fetch_product_loan_collateral%20_account_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/submit_instant_loan_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/submit_loan_against_deposit_product_usecase.dart';

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

  Future<InstantLoanEligibilityModel> fetchInstantLoanEligibility(
    InstantLoanEligibilityProps props,
  );

  Future<String> submitInstantLoanApplication(SubmitInstantLoansProps props);

  Future<List<DepositLoanEligibilityModel>> fetchDepositLoanEligibility(
    DepositLoanEligibilityProps props,
  );

  Future<ProductLoanEligibleCollateralAccountDto>
  fetchProductLoanCollateralAccount(
    FetchProductLoanCollateralAccountProps props,
  );

  Future<String> submitLoanAgainstDepositProductDatasource(
    SubmitLoanAgainstDepositProductProps props,
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
        ApiUrls.fetchAgainstLoanInterest,
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

  @override
  Future<InstantLoanEligibilityModel> fetchInstantLoanEligibility(
    InstantLoanEligibilityProps props,
  ) async {
    try {
      final response = await apiService.post(
        ApiUrls.fetchInstantLoanEligibility,
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
            Map<String, dynamic> decoded = jsonDecode(dataString);

            String eligibleConditionsString = decoded['EligibleConditions'];

            var eligibilityMessage = decoded['EligibilityMessage'];
            var eligibleConditionsList = jsonDecode(eligibleConditionsString);
            var eligibleConditionsLists =
                (eligibleConditionsList)
                    .map((e) => EligibleConditionsModel.fromJson(e))
                    .toList();

            return InstantLoanEligibilityModel(
              eligibilityMessage: eligibilityMessage,
              eligibleConditions: eligibleConditionsLists,
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

  @override
  Future<String> submitInstantLoanApplication(
    SubmitInstantLoansProps props,
  ) async {
    try {
      final response = await apiService.post(
        ApiUrls.submitInstantLoans,
        data: {
          "ByUserId": props.userId,
          "EmployeeCode": props.employeeCode,
          "MobileNo": props.mobileNumber,
          "MobileNumber": props.mobileNumber,
          "PersonId": props.personId,
          "RequestFrom": "MobileApp",
          "RolePermissionId": props.rolePermissionId,
          "UID": props.userId,
          "UserName": props.email,
          "ModuleCode": props.moduleCode,
          "NameOnCard": props.nameOnCard,
          "SecretKey": props.secretKey,
          "CardNo": props.cardNo,
          "AccountNo": props.accountNo,
          "AppliedAmount": props.appliedAmount,
          "OTPRegId": props.otpRegId,
          "OTPValue": props.otpValue,
          "IsTopUp": props.isTopUp,
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
  // submitInstantLoans

  Future<List<DepositLoanEligibilityModel>> fetchDepositLoanEligibility(
    DepositLoanEligibilityProps props,
  ) async {
    final response = await apiService.post(
      ApiUrls.fetchDepositLoanEligibility,
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
      final body = response.data as Map<String, dynamic>;
      final statusMessage = body['Status'];
      final errorMessage = body['Message'];

      final dataField = body['Data'];

      if (dataField == null) {
        throw ServerException(message: "No Data field in response");
      }

      dynamic decodedData;
      if (dataField is String) {
        decodedData = jsonDecode(dataField);
      } else {
        decodedData = dataField;
      }

      if (statusMessage != null &&
          statusMessage.toString().toLowerCase() == "failed") {
        throw ServerException(message: errorMessage ?? "Request failed");
      }

      if (decodedData is List) {
        return decodedData
            .map(
              (e) => DepositLoanEligibilityModel.fromJson(
                e as Map<String, dynamic>,
              ),
            )
            .toList();
      } else {
        throw ServerException(message: "Unexpected data format for Data");
      }
    } else {
      throw ServerException(message: "Server Error: ${response.statusCode}");
    }
  }

  @override
  Future<ProductLoanEligibleCollateralAccountDto>
  fetchProductLoanCollateralAccount(
    FetchProductLoanCollateralAccountProps props,
  ) async {
    try {
      final response = await apiService.post(
        ApiUrls.eligibleCollateralAccount,
        data: {
          "ByUserId": props.userId,
          "EmployeeCode": props.employeeCode,
          "MobileNo": props.mobileNumber,
          "MobileNumber": props.mobileNumber,
          "PersonId": props.personId,
          "RequestFrom": "MobileApp",
          "RolePermissionId": props.rolePermissionId,
          "UID": props.userId,
          "UserName": props.email,
          "ModuleCode": "50",
          "ProductCode": props.productCode,
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        final data = response.data?['Data'];
        final errorMessage = response.data?['Message'];
        final statusMessage = response.data?['Status'];

        if (data == null || data.isEmpty) {
          if (statusMessage != null && statusMessage == "failed") {
            throw ServerException(message: errorMessage ?? 'Request failed');
          } else {
            throw ServerException(message: 'Unexpected null or empty data');
          }
        }

        final jsonData = jsonDecode(data);

        final List<ProductLoanCollateralAccountModel> collateralAccounts =
            (jsonData['CollateralAccounts'] as List)
                .map((e) => ProductLoanCollateralAccountModel.fromJson(e))
                .toList();

        // final accountId = jsonData['accountId'];
        final maximumLoanAmount = jsonData['MaximumLoanAmount'];
        final interestRate = jsonData['InterestRate'];
        final numberOfInstallment = jsonData['NumberOfInstallment'];
        final totalApplyLoan = jsonData['TotalApplyLoan'];

        return ProductLoanEligibleCollateralAccountDto(
          // id: accountId,
          maximumLoanAmount: maximumLoanAmount,
          interestRate: interestRate,
          totalApplyLoan: totalApplyLoan,
          numberOfInstallment: numberOfInstallment,
          collateralAccounts: collateralAccounts,
        );
      } else {
        throw ServerException(
          message: 'Server responded with status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> submitLoanAgainstDepositProductDatasource(
    SubmitLoanAgainstDepositProductProps props,
  ) async {
    try {
      final collateralAccounts =
          props.collateralAccounts
              ?.map(
                (ledger) =>
                    ProductLoanCollateralAccountModel.fromEntity(
                      ledger,
                    ).toJson(),
              )
              .toList();

      final response = await apiService.post(
        ApiUrls.submitLoansAgainstDepositProduct,
        data: {
          "ByUserId": props.userId,
          "UID": props.userId,
          "RolePermissionId": props.rolePermissionId,
          "PersonId": props.personId,
          "EmployeeCode": props.employeeCode,
          "MobileNo": props.mobileNumber,
          "MobileNumber": props.mobileNumber,
          "RequestFrom": "MobileApp",
          "UserName": props.email,
          "LoanProductCode": props.loanProductCode,
          "AccountNo": props.accountNo,
          "NameOnCard": props.nameOnCard,
          "MaximumLoanAmount": props.maximumLoanAmount,
          "InterestRate": props.interestRate,
          "NumberOfInstallment": props.numberOfInstallment,
          "CollateralAccounts": collateralAccounts,
          "TotalApplyLoan": props.totalApplyLoan,
          "SecretKey": props.secretKey,
          "CardNo": props.cardNo,
          "OTPRegId": props.oTPRegId,
          "OTPValue": props.oTPValue,
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
