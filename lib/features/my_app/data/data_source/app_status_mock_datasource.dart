import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/features/my_app/data/data_source/app_status_remote_datasource.dart';
import 'package:pashboi/features/my_app/data/models/advertisement_model.dart';
import 'package:pashboi/features/my_app/data/models/app_status_model.dart';

class AppStatusMockDataSourceImpl implements AppStatusRemoteDataSource {
  final ApiService apiService;

  AppStatusMockDataSourceImpl({required this.apiService});

  @override
  Future<AppStatusModel> getAppStatus(int version) async {
    // throw UnimplementedError();
    final model = AppStatusModel.fromJson({
      "Id": 1,
      "IsUpdated": true,
      "UpdateMessage":
          "An update is available. Please update your app to the latest version.",
      "Version": "63",
      "VersionDate": "2023-12-07T22:10:59",
      "IsMaintenance": false,
      "MaintenanceDate": "2023-06-30T15:42:59",
      "MaintenanceMessage":
          "Dear Member,\nPlease be informed that due to system upgradation our ATM and MMS Services will remain temporarily unavailable, rnuntill further notice. We are sorry for the inconvenience.rn rnFor any enquiry, please call our 24-hour Member Services Hotline 09678156156.rnrnThank YournDhaka Credit",
    });
    return model;
  }

  @override
  Future<List<AdvertisementModel>> getAdds() {
    // TODO: implement getAdds
    throw UnimplementedError();
  }
}
