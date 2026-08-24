import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CreateBkashPaymentPage extends StatefulWidget {
  final String? paymentUrl;
  const CreateBkashPaymentPage({super.key, required this.paymentUrl});

  @override
  State<CreateBkashPaymentPage> createState() => _CreateBkashPaymentPageState();
}

class _CreateBkashPaymentPageState extends State<CreateBkashPaymentPage> {
  late final WebViewController _controller;
  bool get isValidUrl =>
      widget.paymentUrl != null && widget.paymentUrl!.isNotEmpty;

  @override
  void initState() {
    super.initState();

    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..addJavaScriptChannel(
            'AndroidNative', // ✅ This matches the name called from JS
            onMessageReceived: (JavaScriptMessage message) {
              Navigator.of(context).pop();
            },
          );
    if (isValidUrl) {
      _controller.loadRequest(Uri.parse(widget.paymentUrl!));
    } else {
      _controller.loadHtmlString(_pageNotFoundHtml);
    }

    // Uri.parse('https://172.16.200.15:9981/Home/bKashPaymentResponse?paymentID=TR0011dnGabij1754199757868&status=cancel&signature=r39TnGKSUU&apiVersion=1.2.0-beta/'),
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Locales.string(context, "create_bkash_payment")),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(child: WebViewWidget(controller: _controller)),
    );
  }
}

const String _pageNotFoundHtml = '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Page Not Found</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    body {
      font-family: Arial, sans-serif;
      text-align: center;
      padding: 60px 20px;
      background-color: #f2f2f2;
    }
    .icon {
      font-size: 80px;
      color: #ff4d4d;
      margin-bottom: 20px;
    }
    h1 {
      font-size: 32px;
      color: #333;
    }
    p {
      font-size: 18px;
      color: #666;
      margin-bottom: 30px;
    }
    button {
      font-size: 18px;
      padding: 12px 24px;
      background-color: #ff4d4d;
      color: white;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      transition: background-color 0.3s ease;
    }
    button:hover {
      background-color: #e60000;
    }
  </style>
</head>
<body>
  <div class="icon">🚫</div>
  <h1>Page Not Found</h1>
  <p>The payment link is missing or invalid.</p>
  <button onclick="handleDone()">Home</button>

  <script>
    function handleDone() {
      if (window.AndroidNative && AndroidNative.postMessage) {
        AndroidNative.postMessage("Payment Failed");
      } else {
        alert("Unable to communicate with app");
      }
    }
  </script>
</body>
</html>
''';
