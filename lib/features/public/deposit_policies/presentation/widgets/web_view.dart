import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HtmlContentWebView extends StatefulWidget {
  final String htmlContent;

  const HtmlContentWebView({super.key, required this.htmlContent});

  @override
  State<HtmlContentWebView> createState() => _HtmlContentWebViewState();
}

class _HtmlContentWebViewState extends State<HtmlContentWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadHtmlString(widget.htmlContent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: WebViewWidget(controller: _controller)),
    );
  }
}
