import 'dart:io';

import 'package:app/common/http_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isolate_handler/isolate_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:install_plugin/install_plugin.dart';

///自定义dialog
///执行下载操作
///显示下载进度
///下载完成后执行安装操作
class DownloadProgressDialog extends StatefulWidget {
  DownloadProgressDialog(this.version, {Key key}) : super(key: key);

  final String version;

  @override
  _DownloadProgressDialogState createState() => _DownloadProgressDialogState();
}

class _DownloadProgressDialogState extends State<DownloadProgressDialog> {
  //下载进度
  int progress;
  IsolateHandler isolateHandler;
  String taskId;

  @override
  void initState() {
    super.initState();
    //初始化下载进度
    progress = 0;
    downloadApk();
  }

  downloadApk() async {
    var path = (await getExternalStorageDirectory()).path + '/apk/';
    var myDir = new Directory(path);
    myDir.createSync();
    File file = new File(path + 'huicunzheng.update.apk');
    if (file.existsSync()) {
      file.deleteSync();
    }
    var url = '';

    await HttpUtil().download(
      url,
      onReceive: (int count, int total) {
        if (count != total) {
          progress = (count / total * 100).ceil();
          setState(() {});
        } else {
          _installApk();
        }
      },
    );
  }

  void _installApk() async {
    try {
      var path = (await getExternalStorageDirectory()).path + '/apk/';
      InstallPlugin.installApk(
              path + 'huicunzheng.update.apk', 'com.example.huicunquzheng.test')
          .then((result) {})
          .catchError((error) {});
    } on PlatformException catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    //显示下载进度
    return AlertDialog(
      title: Text('更新中'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(widget.version),
            Text(''),
            Text('下载进度 $progress%'),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('安装apk'),
          onPressed: () async {
            var path = (await getExternalStorageDirectory()).path + '/apk/';
            InstallPlugin.installApk(path + 'huicunzheng.update.apk',
                'com.example.huicunquzheng.test');
          },
        ),
        FlatButton(
          child: Text('取消更新'),
          onPressed: () {
            isolateHandler.isolates['downloadApk'].pause();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
