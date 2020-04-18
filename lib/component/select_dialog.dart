library select_dialog;

import 'package:flutter/material.dart';

class SelectDialog<T> extends StatefulWidget {
  final Function(String text) onFind;
  final Widget searchResult;
  final String hintText;
  const SelectDialog(
      {Key key,
      @required this.searchResult,
      @required this.onFind,
      this.hintText})
      : super(key: key);

  static Future<T> showModal<T>(BuildContext context,
      {String label,
      Widget searchResult,
      String hintText,
      Function(String text) onFind}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            label ?? "",
          ),
          content: SelectDialog<T>(
            searchResult: searchResult,
            hintText: hintText,
            onFind: onFind,
          ),
        );
      },
    );
  }

  @override
  _SelectDialogState<T> createState() => _SelectDialogState<T>();
}

class _SelectDialogState<T> extends State<SelectDialog<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .9,
      height: MediaQuery.of(context).size.height * .7,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                widget.onFind(value);
              },
              decoration: InputDecoration(
                hintText: widget.hintText,
                contentPadding: const EdgeInsets.all(2.0),
              ),
            ),
          ),
          Expanded(
            child: Scrollbar(
              child: widget.searchResult,
            ),
          ),
        ],
      ),
    );
  }
}
