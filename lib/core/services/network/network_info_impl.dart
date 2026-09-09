import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:pashboi/core/services/network/network_info.dart';

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl({required this.connectivity});

  @override
  Future<bool> get isConnected async {
    final connectivityResult = await connectivity.checkConnectivity();
    // First, check network type
    if (connectivityResult.contains(ConnectivityResult.none) || connectivityResult.isEmpty) {
      return false;
    }

    // Then, verify real internet access
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}
