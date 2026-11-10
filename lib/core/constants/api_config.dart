import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get apiUrl {
    final url = dotenv.env['API_URL'];
    if (url == null || url.isEmpty) {
      throw Exception('Missing API_URL in .env');
    }
    return url;
  }

  static String get productApiUrl {
    final url = dotenv.env['PRODUCT_API_URL'];
    if (url == null || url.isEmpty) {
      throw Exception('Missing PRODUCT_API_URL in .env');
    }

    final uri = Uri.parse(url);
    if (uri.host.toLowerCase() == 'cccul.com') {
      return uri.replace(host: 'www.cccul.com').toString();
    }
    return url;
  }

  static String get apiKey {
    final key = dotenv.env['API_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception('Missing API_KEY in .env');
    }
    return key;
  }

  // Add other config values here as needed
}
