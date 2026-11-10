import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/errors/exceptions.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/features/authenticated/profile/data/models/person_profile_parser.dart';
import 'package:pashboi/features/authenticated/profile/data/models/person_model.dart';
import 'package:pashboi/features/authenticated/profile/domain/usecases/change_password_usecase.dart';
import 'package:pashboi/features/authenticated/profile/domain/usecases/get_profile_usecase.dart';
import 'package:pashboi/features/authenticated/profile/domain/usecases/update_profile_image_usecase.dart';

abstract class ProfileRemoteDataSource {
  Future<PersonModel> getProfile(GetProfileProps props);
  Future<String> updateProfileImage(UpdateProfileImageProps props);
  Future<String> changePassword(ChangePasswordProps props);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiService apiService;

  ProfileRemoteDataSourceImpl({required this.apiService});

  @override
  Future<PersonModel> getProfile(GetProfileProps props) async {
    try {
      final response = await apiService.post(
        ApiUrls.getUserProfile,
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
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        final dataString = response.data?['Data'];
        final errorMessage = response.data?['Message'];
        final statusMessage = response.data?['Status'];
        if (statusMessage == "failed") {
          throw ServerException(
            message:
                errorMessage is String && errorMessage.isNotEmpty
                    ? errorMessage
                    : "Failed to load profile",
          );
        }
        if (dataString is! String || dataString.isEmpty) {
          throw ServerException(
            message: "Server returned invalid profile data",
          );
        }

        return compute<String, PersonModel>(parsePersonProfileJson, dataString);
      } else {
        throw ServerException(message: "Server Error");
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> updateProfileImage(UpdateProfileImageProps props) async {
    try {
      final response = await apiService.post(
        ApiUrls.changeProfileImage,
        data: {
          "UserName": props.email,
          "ImageName": props.imageData,
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
  Future<String> changePassword(ChangePasswordProps props) async {
    try {
      final response = await apiService.post(
        ApiUrls.changePassword,
        data: {
          "UserName": props.email,
          "UID": props.userId,
          "ByUserId": props.userId,
          "RolePermissionId": props.rolePermissionId,
          "PersonId": props.personId,
          "EmployeeCode": props.employeeCode,
          "MobileNumber": props.mobileNumber,
          "MobileNo": props.mobileNumber,
          "Password": props.currentPassword,
          "NewPassword": props.newPassword,
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
