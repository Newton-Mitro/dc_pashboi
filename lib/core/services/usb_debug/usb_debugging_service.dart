import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class UsbDebuggingService {
  static const MethodChannel _channel = MethodChannel('security/device');

  static Future<bool> isEnabled() async {
    try {
      final result = await _channel.invokeMethod<bool>('isUsbDebuggingEnabled');

      debugPrint('USB DEBUGGING RESULT: $result');

      return result ?? false;
    } on PlatformException catch (e) {
      debugPrint('USB DEBUGGING ERROR: ${e.message}');
      return false;
    } catch (e) {
      debugPrint('USB DEBUGGING UNKNOWN ERROR: $e');
      return false;
    }
  }
}
