class ApiUrls {
  // Auth
  static const String login = 'Auth_V2/UserLogin';
  static const String register = 'Auth_V1/UserRegister';
  static const String resetPassword = 'securities_v1/forgotPassword';
  static const String verifyMobileNumber = 'Auth_V1/verifyMobileNumber';
  static const String verifyOTP = 'Auth_V1/verifyOTP';

  // Info
  static const String getUserProfile = 'info_V1/getUserProfile';
  static const String changeProfileImage = 'info_V1/changeProfileImage';
  static const String changePassword = 'securities_v1/changePassword';

  static const String getRelationshipTypes = 'info_V1/getRelationshipTypes';
  static const String getFamilyAndRelatives = 'info_V1/getFamilyAndRelatives';
  static const String addFamilyOrRelative = 'info_V1/addFamilyOrRelative';

  // Accounts
  static const String getMyAccounts = 'accounts_V1/getMyAccounts';
  static const String getAccountDetails = 'accounts_V1/GetAccountDetails';
  static const String getAccountStatement = 'accounts_V2/getAccountStatement';

  static const String addDependent = 'info_V1/AddAccountOperator';
  static const String getDependentAccounts = 'Accounts_V1/getDependentAccounts';

  static const String getApplicableDepositAccountTypes =
      'Accounts_V1/getApplicableDepositAccountTypes';
  static const String getApplicantInfo = 'Accounts_V1/getApplicantInformation';
  static const String createDepositAccount = 'Accounts_V1/createDepositAccount';
  static const String getDurations = 'Accounts_V1/getDurations';
  static const String getDurationAmounts = 'Accounts_V1/getDurationAmounts';
  static const String getAccountOpeningEligibility =
      'Accounts_V1/getAccountOpeningEligibility';

  // Cards
  static const String getMyCards = 'cards_V2/myCards';
  static const String issueCard = 'cards_V1/applyForCardIssue';
  static const String cardReIssue = 'cards_V1/applyForCardReIssue';
  static const String lockTheCard = 'cards_V1/lockTheCard';
  static const String verifyCardPIN = 'cards_V1/verifyCardPIN';

  // Loans
  static const String getMyLoans = 'loans_v1/getMyLoans';
  static const String getLoanDetails = 'loans_V1/getLoanDetails';
  static const String getLoanStatement = 'loans_v2/getLoanStatement';
  static const String getLoanSureties = 'sureties_v1/getLoanSuretyGiven';
  static const String fetchEligibleLoanProducts =
      'loans_v1/getEligibleLoanProducts';
  static const String fetchEligibleCollateralAccounts =
      'loans_v1/getEligibleCollateralAccounts';
  static const String fetchInterestOnAgainstLoan =
      'loans_v1/getInterestOnAgainstLoan';

  // Loan Repayment
  static const String fetchLoanRepayment = 'loans_V1/calculateLoanPayment';

  // Deposit
  static const String getCollectionAccounts =
      'deposits_V1/getCollectionAccount';
  static const String submitDepositNow = 'deposits_V1/submitDepositNow';
  static const String submitDepositLater = 'deposits_V2/submitDepositLater';
  static const String getDepositRequests =
      'deposits_V1/getDepositLaterRequests';
  static const String getEReceipts = 'deposits_V1/getEReceipts';
  static const String getVoucherDetails = 'deposits_V1/getVoucherDetails';
  static const String bkashServiceCharge =
      'Deposit_Bkash_V1/GetbKashPaymentServiceCharge';
  static const String bkashCreatePayment =
      'Deposit_bKash_V1/CreatebKashPayment';

  // Transfer
  static const String submitFundTransfer = 'transfers_v2/submitFundTransfer';
  static const String createBkashPayment =
      'Withdrawal_bKash_V1/CreatebKashWithdrawal';
  static const String verifyRecepient = 'transfers_v2/verifyRecepient_v2';
  static const String getBankAccounts = 'deposits_V1/getDcBankAccounts';
  static const String bKashWithdrawal =
      'Withdrawal_bKash_V1/CreatebKashWithdrawal';

  // Payment
  static const String getPaymentServices = 'payments_v1/getPaymentServices';
  static const String submitPayment = 'payments_v2/submitPayment';

  // Beneficiary
  static const String getBeneficiaries = 'beneficiaries_V1/getBeneficiaries';
  static const String addBeneficiary = 'beneficiaries_V1/addBeneficiary';
  static const String removeBeneficiary = 'beneficiaries_V1/removeBeneficiary';

  // Withddraw
  static const String generateWithdrawalOTQR =
      'withdraw_v1/generateOneTimeWithdrawQR';

  // Professionals

  // Others
  static const String getPolicy = 'others_v1/GetMfsPolicy';
  static const String getAppConfig = 'LoginApi/MFSAppConfig';
  static const String getAgmCounterInfo = 'MFSAPI/GetAGMAttendenceReport';

  // API URLs for Others service
  static const String getDepositPolicies = 'GetAllProductByCategoryId';

  static const String getNotices = 'getAllNotice';

  static const String getProject = 'getAllProject';

  static const String getAllBranch = 'getAllBranch';

  static const String getPageByPageSlug = 'GetPageBySlug';

  static const String getDevTeams = 'getDevTeams';

  static const String fetchTermAndCondition = 'others_v1/GetMfsPolicy';
}
