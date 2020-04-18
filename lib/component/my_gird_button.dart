import 'package:app/component/public_widget.dart';
import 'package:flutter/material.dart';

//快速创建一个新页面，复制，然后替换GirdViewButton
class GirdViewButton extends StatefulWidget {
  final List datas;
  final Function onChange;
  final num crossAxisCount;
  final double childAspectRatio;
  final bool isShowStatis;
  GirdViewButton(
      {@required this.datas,
      this.onChange,
      this.crossAxisCount = 3,
      this.childAspectRatio = 3,
      this.isShowStatis = true});
  @override
  _GirdViewButtonState createState() => _GirdViewButtonState();
}

class _GirdViewButtonState extends State<GirdViewButton> {
  num _currentSelectIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.crossAxisCount, //每行三列
                childAspectRatio: widget.childAspectRatio //显示区域宽高相等
                ),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.datas.length,
            itemBuilder: (context, i) {
              Map data = widget.datas[i];
              bool isSelected = false;
              if (i == _currentSelectIndex) {
                isSelected = true;
              }
              String str = data['name'] +
                  (data['statis'] != null && widget.isShowStatis
                      ? '(${data['statis']})'
                      : '');

              return Card(
                  shape: PublicWidget.shape(5),
                  child: PublicWidget.serchButton(str, () {
                    if (!isSelected) {
                      _currentSelectIndex = i;
                      setState(() {
                        widget.onChange(data['value']);
                      });
                    }
                  }),
                  color: isSelected ? Colors.blue : Color(0xFFF5F5F5));
            })
      ],
    );
  }
}
