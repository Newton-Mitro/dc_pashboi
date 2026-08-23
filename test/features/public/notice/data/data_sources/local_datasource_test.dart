import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/features/public/notice/data/data_sources/local_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NoticeLocalDataSource noticeLocalDataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    noticeLocalDataSource = NoticeLocalDataSourceImpl(mockSharedPreferences);
  });

  group("getTestLocalDataSource", () {
    test(
      "should return notice local data source from Shared Preferences when there is on the cash",
      () async {},
    );
  });
}
