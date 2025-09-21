import 'package:pashboi/features/authenticated/personnel/wooo/domain/entities/wooo_type_entities.dart';

class WoooTypeModel extends WoooTypeEntities {
  WoooTypeModel({
    required super.id,
    required super.woooTypeId,
    required super.woooTypeName,
    required super.woooTypeCode,
    required super.backDateDays,
    required super.fromDate,
    required super.toDate,
  });

  factory WoooTypeModel.fromJson(Map<String, dynamic> json) {
    return WoooTypeModel(
      id: json['WoooTypeId'] ?? "",
      woooTypeId: json['WoooTypeId'] ?? 0,
      woooTypeName: json['WoooTypeName'] ?? "",
      woooTypeCode: json['WoooTypeCode'] ?? "",
      backDateDays: json['BackDateDays'] ?? 0,
      fromDate: json['FromDate'] ?? "",
      toDate: json['ToDate'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'WoooTypeId': id,
      'WoooTypeName': woooTypeName,
      'WoooTypeCode': woooTypeCode,
      'BackDateDays': backDateDays,
      'FromDate': fromDate,
      'ToDate': toDate,
    };
  }
}
