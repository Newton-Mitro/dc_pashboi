import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pashboi/core/services/usb_debug/usb_debugging_service.dart';

class UsbDebuggingGuard extends StatefulWidget {
  final Widget child;

  const UsbDebuggingGuard({super.key, required this.child});

  @override
  State<UsbDebuggingGuard> createState() => _UsbDebuggingGuardState();
}

class _UsbDebuggingGuardState extends State<UsbDebuggingGuard>
    with WidgetsBindingObserver {
  bool _isDialogShowing = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUsbDebugging();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkUsbDebugging();
    }
  }

  Future<void> _checkUsbDebugging() async {
    // TODO: fix this before publish
    // final isEnabled = await UsbDebuggingService.isEnabled();
    final isEnabled = false;

    print('CHECKING USB DEBUGGING: $isEnabled');

    if (!mounted) return;

    if (isEnabled && !_isDialogShowing) {
      _showDialog();
    }
  }

  void _showDialog() {
    _isDialogShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: const Text('USB Debugging Enabled'),
            content: const Text(
              'For security reasons, please disable USB Debugging before using this app.',
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(dialogContext).pop();

                  _isDialogShowing = false;

                  try {
                    await const MethodChannel(
                      'security/device',
                    ).invokeMethod('openDeveloperOptions');
                  } catch (e) {
                    print(e);
                  }
                },
                child: const Text('Open Settings'),
              ),
              TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: const Text('Exit'),
              ),
            ],
          ),
        );
      },
    ).then((_) {
      _isDialogShowing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
