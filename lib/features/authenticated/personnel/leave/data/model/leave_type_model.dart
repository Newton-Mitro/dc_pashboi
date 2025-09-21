import 'package:pashboi/features/authenticated/personnel/leave/domain/entities/leave_type_entity.dart';

class LeaveTypeModel extends LeaveTypeEntity {
  LeaveTypeModel({required super.id, required super.leaveType});

  factory LeaveTypeModel.fromJson(Map<String, dynamic> json) {
    return LeaveTypeModel(
      id: json['LeaveTypeCode'] ?? '',
      leaveType: json['LeaveType'] ?? 'N/A',
    );
  }
  Map<String, dynamic> toJson() {
    return {'LeaveTypeCode': id, 'LeaveType': leaveType};
  }
}
