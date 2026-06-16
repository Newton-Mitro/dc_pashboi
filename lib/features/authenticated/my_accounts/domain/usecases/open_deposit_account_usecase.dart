import 'dart:ffi';

import 'package:pashboi/core/requests/base_request_props.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/entities/nominee_entity.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/repositories/deposit_account_repository.dart';

class AccountHolder {
  final int accountHolderId;
  final bool isOrganization;
  final String savingsACNumber;
  final String membershipNumber;

  const AccountHolder({
    required this.accountHolderId,
    required this.isOrganization,
    required this.savingsACNumber,
    required this.membershipNumber,
  });
}

class Nominee {
  final int personId;
  final int nomineePercentage;

  const Nominee({required this.personId, required this.nomineePercentage});

  Map<String, dynamic> toJson() {
    return {"PersonId": personId, "NomineePercentage": nomineePercentage};
  }
}

class AccountOperator {
  final int accountHolderId;
  final int accountOperatorId;

  const AccountOperator({
    required this.accountHolderId,
    required this.accountOperatorId,
  });

  Map<String, dynamic> toJson() {
    return {
      "AccountHolderId": accountHolderId,
      "AccountOperatorId": accountOperatorId,
    };
  }
}

class OpenDepositAccountParams extends BaseRequestProps {
  final String dMSProductCode;
  final String branchCode;
  final double accountFor;
  final String accountName;
  final double interestRate;
  final int duration;
  final double installmentAmount;
  final String txnAccountNumber;
  final String accountNo;
  final String applicationNo;
  final String interestPostingAccount;
  final String cardNo;
  final String nameOnCard;

  final String secretKey;
  final String otpRegId;
  final String otpValue;
  final List introducers;
  final List<dynamic> accountHolders;
  final List<dynamic> nominees;
  final List<dynamic> accountOperators;

  const OpenDepositAccountParams({
    required this.dMSProductCode,
    required this.branchCode,
    required this.accountFor,
    required this.accountName,
    required this.interestRate,
    required this.duration,
    required this.installmentAmount,
    required this.txnAccountNumber,
    required this.accountNo,
    required this.applicationNo,
    required this.interestPostingAccount,
    required this.cardNo,
    required this.nameOnCard,
    required this.secretKey,
    required this.otpRegId,
    required this.otpValue,
    required this.introducers,
    required this.accountHolders,
    required this.nominees,
    required this.accountOperators,
    required super.email,
    required super.userId,
    required super.rolePermissionId,
    required super.personId,
    required super.employeeCode,
    required super.mobileNumber,
  });
}

class OpenDepositAccountUseCase
    implements UseCase<void, OpenDepositAccountParams> {
  final DepositAccountRepository depositAccountRepository;

  OpenDepositAccountUseCase({required this.depositAccountRepository});

  @override
  ResultFuture call(OpenDepositAccountParams params) async {
    return await depositAccountRepository.openDepositAccount(params);
  }
}
