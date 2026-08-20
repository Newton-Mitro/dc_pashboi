import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

class CryptoHelper {
  static const String secretKey = "JhnhSN7RaaWGgWfzeZeJdIMALLlZ1FQ2";
  static const String ivValue = "JhnhSN7RaaWGgWfz";

  static String encrypt(String valueToEncrypt) {
    try {
      if (valueToEncrypt.isEmpty) {
        throw Exception("Empty string");
      }

      final key = Key.fromUtf8(secretKey);
      final iv = IV.fromUtf8(ivValue);

      final encrypter = Encrypter(
        AES(key, mode: AESMode.cbc, padding: "PKCS7"),
      );

      final encrypted = encrypter.encrypt(valueToEncrypt, iv: iv);

      return "00*${encrypted.base64}";
    } catch (e) {
      return "01*${e.toString()}";
    }
  }

  /// AES Decryption
  static String decrypt(String encryptedValue) {
    try {
      final key = Key.fromUtf8(secretKey);
      final iv = IV.fromUtf8(ivValue);

      final encrypter = Encrypter(
        AES(key, mode: AESMode.cbc, padding: "PKCS7"),
      );

      return encrypter.decrypt64(encryptedValue, iv: iv);
    } catch (e) {
      return "01*${e.toString()}";
    }
  }

  /// MD5 Hash
  static String md5Hash(String value) {
    return md5.convert(utf8.encode(value)).toString();
  }
}
