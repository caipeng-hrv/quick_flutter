import 'package:app/component/base_page.dart';
import 'package:app/component/my_gird_button.dart';
import 'package:app/component/public_widget.dart';
import 'package:app/pages/example/list_view.dart';
import 'package:flutter/material.dart';

//快速创建一个新页面，复制，然后替换Example
class ExamplePage extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<ExamplePage> {
  String name = 'listview';
  show() {
    switch (name) {
      case 'listview':
        return ListviewExamplePage();
        break;
      default:
        return Container();
    }
  }

  static List datas = [
    {'name': '列表', 'value': 'listview'},
    {'name': '搜索按钮', 'value': 'listview'},
    {'name': '提交按钮', 'value': 'listview'},
    {'name': '输入框', 'value': 'listview'}
  ];
 
  @override
  Widget build(BuildContext context) {
     Widget body = Column(
    // mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      GirdViewButtonPage(datas: datas,onChange: (value){
        setState(() {
          name = value;
        });
      },),
      Container(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      ),
      PublicWidget.divider(),
      Expanded(child: show())
      
    ],
  );
    return BasePage(title: '例子', body: body).build();
  }
}
