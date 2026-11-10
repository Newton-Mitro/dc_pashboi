import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pashboi/core/constants/api_config.dart';

void main() {
  group('AppConfig.productApiUrl', () {
    test('uses the working www host for the bare CCCUL host', () {
      dotenv.testLoad(fileInput: 'PRODUCT_API_URL=https://cccul.com/api/');

      expect(AppConfig.productApiUrl, 'https://www.cccul.com/api/');
    });

    test('preserves other configured product API hosts', () {
      dotenv.testLoad(
        fileInput: 'PRODUCT_API_URL=https://api.example.com/api/',
      );

      expect(AppConfig.productApiUrl, 'https://api.example.com/api/');
    });
  });
}
