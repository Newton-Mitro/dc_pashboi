import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:pashboi/core/utils/network_utils.dart';
import 'package:pashboi/shared/widgets/app_dialog.dart';

class NetworkErrorDialog extends StatelessWidget {
  const NetworkErrorDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) => const NetworkErrorDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: Locales.string(context, 'network_error'),
      content: Locales.string(context, 'no_internet_connection'),
      icon: const Icon(Icons.wifi_off, size: 40),
      positiveButtonLabel: Locales.string(context, 'open_settings'),
      negativeButtonLabel: Locales.string(context, 'cancel'),
      onPositiveButtonTap: () {
        Navigator.of(context).pop();
        NetworkUtils.openInternetSettings();
      },
    );
  }
}
