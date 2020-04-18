//公共组件
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PublicWidget {
  //横线
  static divider() {
    return Divider(
      height: 2.0,
      indent: 10,
      endIndent: 10,
      color: Colors.black,
    );
  }

  static showToast(String msg, [ToastGravity location]) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: location == null ? ToastGravity.CENTER : location,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.black,
        fontSize: 16.0);
  }

  static shape(double radius) {
    return RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        side: BorderSide(style: BorderStyle.none, width: 0));
  }

  static myForm(Widget widget,
      {Color color = Colors.white70, double height = 40}) {
    return Expanded(
      child: Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          height: height,
          child: Card(
            child: widget,
            shape: PublicWidget.shape(5),
            color: color,
          )),
    );
  }

  static serchButton(
    String name,
    Function onPress,
  ) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: Text(
          name,
          style: TextStyle(color: Colors.black),
        ),
      ),
      onTap: () {
        onPress();
      },
    );
  }
}
