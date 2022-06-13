import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:q4me/utils/string.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../controllers/live_chat_page_controller.dart';

class LiveChatPageView extends GetView<LiveChatPageController> {
  final LiveChatPageController _liveChatPageController =
      Get.put(LiveChatPageController());
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  WebViewController _webViewController;

  loadAsset() async {
    String fileHtmlContents = await rootBundle.loadString('assets/index.html');
    _webViewController.loadUrl(Uri.dataFromString(fileHtmlContents,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    _liveChatPageController.initialize(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GLOBAL_THEME_COLOR,
        title: Text('Chat Support'),
        centerTitle: true,
      ),
      body: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          debuggingEnabled: true,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
            _webViewController = webViewController;

            loadAsset();

//             webViewController.evaluateJavascript("""
// document.addEventListener
//             ("load",function loadData(d, src, c) { var t=d.scripts[d.scripts.length - 1],s=d.createElement('script');s.id='la_x2s6df8d';s.async=true;s.src=src;s.onload=s.onreadystatechange=function(){var rs=this.readyState;if(rs&&(rs!='complete')&&(rs!='loaded')){return;}c(this);};t.parentElement.insertBefore(s,t.nextSibling);})(document,
//     'https://iat-ltd.ladesk.com/scripts/track.js',
//     function(e){ LiveAgent.createForm('wzx2s0qt', e); });
//     loadData();
//             """);
          }),
    );
  }
}
