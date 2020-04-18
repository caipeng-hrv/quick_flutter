import 'package:flutter/material.dart';

class MyDialog {
  String title;
  Function onPressed;
  BuildContext context;
  TextEditingController fileNameController;
  Widget customWidget;
  double height;
  MyDialog(
      {this.context,
      this.onPressed,
      this.title,
      this.fileNameController,
      this.customWidget,
      this.height = 150});
  Future delete() {
    Widget centerWidget = Container(
      // height: 50,
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Text(
        '文件将被永久删除，确定删除？',
        style: TextStyle(color: Color(0xFF999999), fontSize: 14),
      ),
    );
    return _build(centerWidget);
  }

  Future confirm() {
    return _build(Container());
  }

  Future custom() {
    return _build(customWidget);
  }

  Future folder([num length]) {
    Widget centerWidget = _folderWidget(length);
    return _build(centerWidget);
  }

  _build(Widget centerWidget) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return Stack(
            children: <Widget>[
              Positioned(
                top: MediaQuery.of(context).size.height * 0.4,
                left: (MediaQuery.of(context).size.width - 280) / 2,
                width: 280,
                height: height,
                child: Card(
                  color: Color(0xFFFFFFFF),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      side: BorderSide(style: BorderStyle.none, width: 0)),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: Text(
                          title,
                          style:
                              TextStyle(color: Color(0XFF000000), fontSize: 18),
                        ),
                      ),
                      centerWidget,
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: FlatButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop(false);
                                  },
                                  child: Text('取消',
                                      style: TextStyle(
                                          color: Color(0XFF000000),
                                          fontSize: 18)),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: FlatButton(
                                  color: Colors.white,
                                  onPressed: () async {
                                    onPressed();
                                  },
                                  child: Text('确定',
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

  _folderWidget([num length]) {
    return Container(
      // height: 50,
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: TextField(
                controller: fileNameController,
                textAlign: TextAlign.start,
                keyboardType: TextInputType.text,
                maxLength: length ?? 20,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  hintStyle: TextStyle(
                    fontSize: 14,
                  ),
                  suffix: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      fileNameController.clear();
                    },
                    child: Image.asset(
                      'assets/images/clean.png',
                      width: 12,
                      height: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
