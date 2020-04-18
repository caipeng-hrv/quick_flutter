import 'package:app/common/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatefulWidget {
  final String text;
  final String hintText;
  Function onChange;
  FocusNode focusNode;
  MyTextField(
      {Key key, this.text, this.hintText, this.onChange, this.focusNode});
  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    // TextEditingController tc = TextEditingController();
    TextEditingController tc = TextEditingController.fromValue(TextEditingValue(
        text: widget.text,
        selection: TextSelection.fromPosition(TextPosition(
            affinity: TextAffinity.downstream, offset: widget.text.length))));
    return Scaffold(
        backgroundColor: Color(0x00000000),
        body: SingleChildScrollView(
            child: TextField(
                // onTap: ,
                autofocus: false,
                autocorrect: false,
                focusNode: widget.focusNode,
                inputFormatters: [
                  WhitelistingTextInputFormatter(PublicTools.generalText)
                ],
                style: TextStyle(
                    textBaseline: TextBaseline.alphabetic, fontSize: 15),
                controller: tc,
                onChanged: (value) {
                  if (widget.onChange != null) {
                    widget.onChange(value);
                  }
                  setState(() {
                    
                  });
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
                  hintText: widget.hintText,
                  hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                  suffix: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      tc.clear();
                      if (widget.onChange != null) {
                        widget.onChange('');
                      } else {
                        setState(() {
                        });
                      }
                    },
                    child: Image.asset(
                      'assets/images/clean.png',
                      width: 10,
                      height: 10,
                    ),
                  ),
                  border: InputBorder.none,
                ))));
  }
}
