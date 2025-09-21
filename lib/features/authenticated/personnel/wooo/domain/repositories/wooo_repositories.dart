import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/entities/wooo_data_entities.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/entities/wooo_type_entities.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/get_wooo_approval_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/get_wooo_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/submit_wooo_application_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/update_wooo_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/wooo_approval_submit_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/wooo_type_usecase.dart';

abstract class WoooRepositories {
  ResultFuture<List<WoooTypeEntities>> getWooType(WooTypeUseCaseProps props);

  ResultFuture<String> submitWoooApplication(
    SubmitWoooApplicationPropsProps props,
  );

  ResultFuture<List<WoooDataEntities>> getWoooData(GetWoooProps props);

  ResultFuture<String> updateWoooRequest(UpdateWoooProps props);

  ResultFuture<List<WoooDataEntities>> getWoooApprovalData(
    GetWoooApprovalProps props,
  );

  ResultFuture<String> submitWoooApprovalRequest(
    WoooApprovalSubmitUseCaseProps props,
  );
}
