import 'dart:ui';

import 'package:app/config/config.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import 'download_progress.dart';


class CheckVersionPage extends StatefulWidget {
  final Widget child;

  const CheckVersionPage({Key key, this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CheckVersionPageStata();
  }
}

class _CheckVersionPageStata extends State<CheckVersionPage> {
  String _newVersion;
  @override
  void initState() {
    super.initState();
    if (Config.env == 'product') {
      _checkVersion();
    }
  }

  _checkVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var currentVersion = packageInfo.version;
    var remoteAppInfo = {};

    if (Comparable.compare(currentVersion, remoteAppInfo['version']) == -1 &&
        remoteAppInfo[Config.env]) {
      _newVersion = remoteAppInfo['version'];
      _show(remoteAppInfo['feature']);
    }
  }

  _show(List data) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return Stack(
            children: <Widget>[
              Positioned(
                top: (MediaQuery.of(context).size.height - 220) / 2 - 20,
                left: (MediaQuery.of(context).size.width - 280) / 2,
                width: 280,
                height: 220,
                child: Card(
                  color: Color(0xFFFFFFFF),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      side: BorderSide(style: BorderStyle.none, width: 0)),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: Text(
                          '发现新版本',
                          style: TextStyle(
                              color: Color(0XFF000000),
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      _updateWidget(data),
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: FlatButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Text('取消',
                                      style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 18)),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: FlatButton(
                                  color: Colors.white,
                                  onPressed: () async {
                                    Navigator.of(ctx).pop();
                                    _showProgress();
                                  },
                                  child: Text('立即更新',
                                      style: TextStyle(
                                          color: Color(0xFF2779F4),
                                          fontSize: 18)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        });
  }

  _updateWidget(List data) {
    List<Widget> list = [];
    list.add(Text('新版本有以下优化'));
    for (var i = 0; i < data.length; i++) {
      if (i != data.length - 1) {
        list.add(Text('${i + 1}.${data[i]};'));
      } else {
        list.add(Text('${i + 1}.${data[i]}.'));
      }
    }
    ScrollController _controller = new ScrollController();
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
        width: 200,
        height: 100,
        child: Scrollbar(
          child: ListView.builder(
              itemCount: list.length,
              controller: _controller,
              itemBuilder: (context, index) {
                return list[index];
              }),
        ));
  }

  _showProgress() {
    // executeDownload();
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      child: DownloadProgressDialog(_newVersion),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
