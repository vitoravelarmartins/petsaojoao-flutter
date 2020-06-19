import 'package:flutter/material.dart';

class ButtonConfirmForm extends StatelessWidget {
  var onPressedFunction;
  ButtonConfirmForm(onPressedFunction) {
    this.onPressedFunction = onPressedFunction;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
          right: 15,
        ),
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: onPressedFunction,
          child: Icon(Icons.keyboard_arrow_right),
        ));
  }
}
