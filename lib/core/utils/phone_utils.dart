class PhoneUtils {
  static String removeCountryCode(String number) {
    final cleanedNumber = number.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanedNumber.startsWith('880')) {
      return '0${cleanedNumber.substring(3)}';
    }

    return cleanedNumber;
  }
}
