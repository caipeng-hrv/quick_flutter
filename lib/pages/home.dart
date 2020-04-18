import 'package:app/component/public_widget.dart';
import 'package:app/pages/example/example_page.dart';
import 'package:app/pages/user/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'user/personal.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageStata();
  }
}

class _HomePageStata extends State<HomePage> {
  num currentIndex = 0;

  List items = [
    {'name': '登录', 'icon': Icons.notifications, 'page': LoginPage()},
    {'name': '例子', 'icon': Icons.play_circle_outline, 'page': ExamplePage()},
    {'name': '个人中心', 'icon': Icons.person, 'page': PersonalPage()}
  ];
  Color unselectColor = Colors.black38;
  Color selectColor = Colors.blue;
  DateTime _lastPopTime;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _onWillPop() async {
    if (_lastPopTime == null ||
        DateTime.now().difference(_lastPopTime) > Duration(seconds: 2)) {
      _lastPopTime = DateTime.now();
      PublicWidget.showToast('再按一次退出');
      return false;
    } else {
      _lastPopTime = DateTime.now();
      // 退出app
      await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];
    for (var i = 0; i < items.length; i++) {
      rows.add(bottomAppBarItem(i));
    }
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          bottomNavigationBar: BottomAppBar(
              child: Row(
            children: rows,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          )),
          body: items[currentIndex]['page'],
        ));
  }

  Widget bottomAppBarItem(int index) {
    TextStyle style = TextStyle(fontSize: 12, color: unselectColor);
    Color color = unselectColor;
    if (currentIndex == index) {
      //选中的话
      style = TextStyle(fontSize: 13, color: selectColor);
      color = selectColor;
    }
    //构造返回的Widget
    Widget item = Container(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              items[index]['icon'],
              size: 25,
              color: color,
            ),
            Text(
              items[index]['name'],
              style: style,
            )
          ],
        ),
        onTap: () {
          if (currentIndex != index) {
            setState(() {
              currentIndex = index;
            });
          }
        },
      ),
    );
    return item;
  }
}
