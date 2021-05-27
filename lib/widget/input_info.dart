import 'package:flutter/material.dart';

class InputInfo extends StatefulWidget {
  final String labelText;
  final Color color;
  final TextEditingController controller;

  InputInfo(
      {@required this.controller,
      @required this.labelText,
      @required this.color});

  @override
  _InputInfoState createState() => _InputInfoState();
}

class _InputInfoState extends State<InputInfo> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 7),
        child: TextField(
          controller: widget.controller,
          enabled: false,
          style: TextStyle(fontSize: 14),
          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: TextStyle(color: widget.color),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(width: 1, color: widget.color),
            ),
          ),
        ));
  }
}
