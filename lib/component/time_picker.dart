import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimePickerPage extends StatefulWidget {
  final DateTime date;
  final Function onPick;
  TimePickerPage({Key key, this.date,this.onPick});
  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePickerPage> {
  //调起日期选择器
  _showDatePicker() async {
    // 第二种方式：async+await
    //await的作用是等待异步方法showDatePicker执行完毕之后获取返回值
    var result = await showDatePicker(
        context: context,
        initialDate: widget.date, //选中的日期
        firstDate: DateTime(1980), //日期选择器上可选择的最早日期
        lastDate: DateTime(2100),
        locale: Locale("zh"));
    //将选中的值传递出来
    if(widget.onPick !=null && result != null){
      widget.onPick(result);
    }
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: //可以通过在外面包裹一层InkWell来让某组件可以响应用户事件
          InkWell(
              onTap: () {
                //调起日期选择器
                _showDatePicker();
              },
              child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        DateFormat('yyyy-MM-dd').format(widget.date??DateTime.now()),
                        style:
                            TextStyle(fontSize: 13, color: Color(0xff4a4a4a)),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Icon(Icons.arrow_drop_down)
                    ],
                  ))),
    );
  }
}
