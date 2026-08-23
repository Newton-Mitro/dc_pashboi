import 'package:flutter/services.dart';

class UsbDebuggingService {
  static const MethodChannel _channel = MethodChannel('security/device');

  static Future<bool> isEnabled() async {
    try {
      final result = await _channel.invokeMethod<bool>('isUsbDebuggingEnabled');

      print('USB DEBUGGING RESULT: $result');

      return result ?? false;
    } on PlatformException catch (e) {
      print('USB DEBUGGING ERROR: ${e.message}');
      return false;
    } catch (e) {
      print('USB DEBUGGING UNKNOWN ERROR: $e');
      return false;
    }
  }
}
