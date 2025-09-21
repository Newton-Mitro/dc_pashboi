import 'package:pashboi/core/entities/entity.dart';

class EmployeeDetailsEntity extends Entity<int> {
  final String fullName;
  final String registeredMobile;
  final String email;
  final String bloodGroup;
  final String gender;
  final String maritalStatus;
  final String religion;
  final String nationality;
  final String nid;
  final String rfIdCardNo;
  final String personPhoto;
  final String otherMobileNumber;
  final String employeeMobile;
  final String employeeEmail;
  final String supervisorName;
  final String employeeType;
  final String employeeCategory;
  final String employeeCategoryName;
  final String departmentName;
  final String designationName;
  final String branchName;
  final String joiningDate;
  final String employeeStatus;
  final String mobileNumber;
  final String employeeCode;

  EmployeeDetailsEntity({
    required super.id,
    required this.fullName,
    required this.registeredMobile,
    required this.email,
    required this.bloodGroup,
    required this.gender,
    required this.maritalStatus,
    required this.religion,
    required this.nationality,
    required this.nid,
    required this.rfIdCardNo,

    required this.personPhoto,
    required this.otherMobileNumber,

    required this.employeeMobile,
    required this.employeeEmail,
    required this.supervisorName,
    required this.employeeType,
    required this.employeeCategory,
    required this.employeeCategoryName,
    required this.departmentName,
    required this.designationName,
    required this.branchName,
    required this.joiningDate,
    required this.employeeStatus,
    required this.mobileNumber,
    required this.employeeCode,
  });

  @override
  List<Object?> get props => [
    id,
    fullName,
    registeredMobile,
    email,
    bloodGroup,
    gender,
    maritalStatus,
    religion,
    nationality,
    nid,
    rfIdCardNo,

    personPhoto,
    otherMobileNumber,

    employeeMobile,
    employeeEmail,

    supervisorName,
    employeeType,
    employeeCategory,
    employeeCategoryName,
    employeeCategoryName,
    departmentName,

    designationName,
    branchName,
    joiningDate,

    employeeStatus,
    mobileNumber,
    employeeCode,
  ];
}
