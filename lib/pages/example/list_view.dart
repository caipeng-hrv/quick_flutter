import 'dart:math';

import 'package:app/component/my_list_view.dart';
import 'package:app/component/public_widget.dart';
import 'package:app/component/slide_button.dart';
import 'package:flutter/material.dart';

//快速创建一个新页面，复制，然后替换ListviewExample
class ListviewExamplePage extends StatefulWidget {
  @override
  _ListviewExampleState createState() => _ListviewExampleState();
}

class _ListviewExampleState extends State<ListviewExamplePage> {
  Map searchParam = {};
  bool reload = false;
  bool listIsPressed = false;
  @override
  Widget build(BuildContext context) {
    List buttonParams = [
      {
        'name': '你好',
        'color': Colors.blue,
        'onTap': () {
          PublicWidget.showToast('你好');
          reload = false;
          setState(() {});
        }
      },
      {
        'name': '放屁',
        'color': Colors.red,
        'onTap': () {
          PublicWidget.showToast('放屁');
          reload = false;
          setState(() {});
        }
      }
    ];

    return MyListview(
      reload: reload,
      card: (Map map) {
        GlobalKey<SlideButtonState> key = GlobalKey();
        return SlideButton(
          key: key,
          singleButtonWidth: 70,
          buttons: buttonParams.map((buttonParam) {
            return Container(
                width: 50,
                padding: const EdgeInsets.fromLTRB(0, 1, 0, 1),
                child: GestureDetector(
                    onTap: (){
                      buttonParam['onTap']();
                      key.currentState.close();
                    },
                    child: Card(
                      color: buttonParam['color'],
                        child: Center(
                      child: Text(buttonParam['name']),
                    ))));
          }).toList(),
          child: Container(
            height: 60,
            child: Card(
              child: Text(map['title']),
            ),
          ),
        );
      },
      searchParam: searchParam,
      url: 'notice',
      onTap: (Map map) async{
        print(listIsPressed);
        if(listIsPressed){
          return;
        }else{
          listIsPressed = true;
        }
        await Future.delayed(Duration(seconds: 1));
        PublicWidget.showToast('我被点击了');
        searchParam['type'] = Random().nextInt(5);
        searchParam['type'] == 0 ? searchParam['type'] = 1:searchParam['type']=searchParam['type'];
        reload = true;
        listIsPressed = false;
        setState(() {});
      },
    );
  }
}
