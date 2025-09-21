import 'package:pashboi/features/authenticated/personnel/leave/data/model/leave_info_model.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/leave_summery_model.dart';

class LeaveTypeBalanceDto {
  final LeaveInfoModel leaveInfo;
  final List<LeaveSummeryModel> leaveSummary;
  LeaveTypeBalanceDto({required this.leaveInfo, required this.leaveSummary});
}
