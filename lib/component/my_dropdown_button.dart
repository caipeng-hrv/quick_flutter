import 'package:flutter/material.dart';

class MyDropdownButton extends StatefulWidget {
  final List data;
  final Function onselect;
  final bool isExpand;
  final dynamic value;
  MyDropdownButton(
      {Key key,
      @required this.data,
      this.onselect,
      this.value,
      this.isExpand = true});
  @override
  _DropdownButtonState createState() => _DropdownButtonState();
}

class _DropdownButtonState extends State<MyDropdownButton> {
  var value;
  @override
  void initState() {
    super.initState();
    value = widget.value ?? widget.data[0]['value'];
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem> items = [];
    for (var i = 0; i < widget.data.length; i++) {
      items.add(DropdownMenuItem(
        child: Text(widget.data[i]['name']),
        value: widget.data[i]['value'],
      ));
    }
    return Container(
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: DropdownButton(
            items: items,
            isExpanded: widget.isExpand,
            value: value,
            onChanged: (v) {
              value = v;
              if (widget.onselect != null) {
                widget.onselect(v);
              }
              setState(() {});
            },
            underline: Container(),
            style: TextStyle(
              color: Color(0xff4a4a4a),
              fontSize: 14,
            )));
  }
}
