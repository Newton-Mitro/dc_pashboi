import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/get_leave_type_blance_dto.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/entities/leave_application_entites.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/entities/leave_type_entity.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/entities/search_employee_entity.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/fallback_request_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/leave_approval_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/leave_history_request_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/leave_type_blance_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/leave_type_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/submit_leave_approvel_usecase.dart';

abstract class LeaveRepository {
  ResultFuture<LeaveTypeBalanceDto> getLeaveTypeBalance(
    LeaveTypeBalanceProps props,
  );

  ResultFuture<List<LeaveTypeEntity>> getLeaveType(LeaveTypeProps props);

  ResultFuture<List<SearchEmployeeEntity>> getSearchEmployee(props);

  ResultFuture<String> submitLeaveApplication(props);

  ResultFuture<List<LeaveApplicationEntities>> getFallbackRequest(
    FallbackRequestUseCaseProps props,
  );

  ResultFuture<String> getAcceptedFallbackRequest(props);

  ResultFuture<List<LeaveApplicationEntities>> getLeaveApproval(
    LeaveApprovalProps props,
  );

  ResultFuture<String> submitLeaveApproval(SubmitLeaveApprovalProps props);

  ResultFuture<List<LeaveApplicationEntities>> getLeaveHistory(
    LeaveHistoryRequestProps props,
  );
  ResultFuture<String> updateLeaveApplication(props);
}
