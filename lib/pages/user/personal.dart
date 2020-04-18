import 'dart:io';
import 'dart:typed_data';

import 'package:app/component/my_dialog.dart';
import 'package:app/common/global.dart';
import 'package:app/component/public_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class PersonalPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PersonalPageState();
  }
}

class _PersonalPageState extends State<PersonalPage> {
  DateTime lastPopTime;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          '个人中心',
          style: new TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 16,
          ),
        ),
        flexibleSpace: Container(
          padding: const EdgeInsets.fromLTRB(12, 74, 12, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  child: Image.asset('assets/images/touxiang.png',
                      width: 75.0, height: 75.0, fit: BoxFit.fill)),
              Expanded(
                child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            Global.user.account,
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          ),
                        ])),
              ),
            ],
          ),
        ),
        bottom: PreferredSize(
          child: Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          ),
          preferredSize: Size(30, 100),
        ),
      ),
      body: Container(
        color: Colors.grey,
        child: Column(
          children: <Widget>[
            Container(
              height: 10,
              color: Color(0xFFefeff4),
            ),
            Container(
              // height: 183,
              color: Color(0xFFFFFFFF),
              child: Column(
                children: <Widget>[
                  item('operation_manual'),
                  item('service_item'),
                  item('private_police'),
                ],
              ),
            ),
            Container(
              height: 30,
              color: Color(0xFFefeff4),
            ),
            logoutWidget(),
            Expanded(
              child: Container(
                color: Color(0xFFefeff4),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget card(String text, String imageName, String count) {
    var width = MediaQuery.of(context).size.width / 2.5;
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          side: BorderSide(style: BorderStyle.none, width: 0)),
      child: Container(
        height: 67,
        width: width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/personal/$imageName.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: <Widget>[
            Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                child: Text(text,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFFFFFFF),
                    ))),
            Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                child: Text(count,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFFFFFFF),
                    ))),
          ],
        ),
      ),
    );
  }

  Widget item(String name, [bool hasInputBorder]) {
    Map titleName = {
      'service_item': '用户协议',
      'private_police': '隐私政策',
      'operation_manual': '操作手册',
    };
    TextEditingController controller =
        TextEditingController(text: titleName[name]);
    return GestureDetector(
        onTap: () async {},
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Image.asset(
                'assets/personal/$name.png',
                height: 20,
                width: 20,
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: TextField(
                  // enabled: false,
                  readOnly: true,
                  onTap: () async {
                    if (name == 'operation_manual') {
                      if (Platform.isIOS) {
                        return;
                      }
                      await Permission.storage.request();
                      var status = await Permission.storage.status;
                      if (!status.isGranted) {
                        PublicWidget.showToast('请开启存储权限');
                        return;
                      }
                      String filename = '操作指南-检查员.pdf';
                      ByteData content =
                          await rootBundle.load('assets/html/checker.pdf');
                      print(content);
                      File(Global.downloadPath + filename)
                          .writeAsBytes(content.buffer.asUint8List());
                      filename = '操作指南-企事业.pdf';
                      content =
                          await rootBundle.load('assets/html/interprise.pdf');
                      File(Global.downloadPath + filename)
                          .writeAsBytes(content.buffer.asUint8List());
                      PublicWidget.showToast('操作指南已保存到系统目录徐州文旅目录下');
                    } else {
                      Navigator.of(context)
                          .pushNamed("browser", arguments: {'title': name});
                    }
                  },
                  controller: controller,
                  decoration: hasInputBorder == null
                      ? InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 0.5, color: Color(0xFFE2DEDE))),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 0.5, color: Color(0xFFE2DEDE))),
                          // enabled: false,
                          suffixIcon: Icon(
                            Icons.keyboard_arrow_right,
                            color: Color(0xFFCCCCCC),
                          ))
                      : InputDecoration(
                          border: InputBorder.none,
                          suffixIcon: Icon(
                            Icons.keyboard_arrow_right,
                            color: Color(0xFFCCCCCC),
                          )),
                ),
              ),
            ),
          ],
        ));
  }

  Widget logoutWidget() {
    return GestureDetector(
        onTap: _logout,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 49,
          alignment: Alignment.center,
          color: Color(0xFFFFFFFF),
          child: Text(
            '退出登录',
            style: TextStyle(
              color: Color(0xFF323232),
              fontSize: 15,
            ),
          ),
        ));
  }

  _logout() async {
    MyDialog(
            context: context,
            height: 150,
            onPressed: () {
              Global.logout();
              Navigator.of(context).pushNamed('login');
            },
            title: '确认退出登录')
        .confirm();
  }
}
