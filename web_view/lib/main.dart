import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              'Akshit Website')),
        ),
        body: WebView(
          initialUrl: "https://www.youtube.com",
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          javascriptMode: JavascriptMode.unrestricted,
        ),
        bottomNavigationBar: Container(
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20, right: 20),
            child: ButtonBar(
              children: [
                navigationButton(Icons.chevron_left, _goBack),
                navigationButton(Icons.chevron_right, _goForward)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget navigationButton(IconData icon, Function(WebViewController) onPressed) {
    return FutureBuilder<WebViewController>(
        future: _controller.future,
        builder: (context, AsyncSnapshot<WebViewController> snapshot) {
          final controller = snapshot.data;
          return IconButton(
            icon: Icon(
              icon, 
              color: Colors.white),
            onPressed: controller != null &&
             snapshot.connectionState == ConnectionState.done
                ? () => onPressed(controller)
                : null,
          );
        });
  }

  void _goBack(WebViewController controller) async {
    if (await controller.canGoBack()) {
      controller.goBack();
    }
  }

  void _goForward(WebViewController controller) async {
    if (await controller.canGoForward()) {
      controller.goForward();
    }
  }
}

