import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:webview_flutter/webview_flutter.dart';

//加载静态html
class BrowserPage extends StatefulWidget {
  BrowserPage({Key key}) : super(key: key);

  @override
  _BrowserPageState createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  Future<String> _getFile(fileName) async {
    return await rootBundle.loadString('assets/html/$fileName.html');
  }

  Map titleName = {
    'service_item': '用户协议',
    'private_police': '隐私政策',
    'operation_manual': '操作手册',
  };
  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    return FutureBuilder<String>(
      future: _getFile(args['title']),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: Text("${titleName[args['title']]}")),
            body: WebView(
              initialUrl: new Uri.dataFromString(snapshot.data,
                      mimeType: 'text/html',
                      encoding: Encoding.getByName('utf-8'))
                  .toString(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("${snapshot.error}"),
            ),
          );
        } else {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
