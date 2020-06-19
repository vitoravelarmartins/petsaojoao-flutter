import 'package:flutter/material.dart';
import 'package:path/path.dart';

class AppBarFoundation extends StatelessWidget {
  var icon;
  AppBarFoundation(icon) {
    this.icon = icon;
  }
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      automaticallyImplyLeading: false,
      leading: FlatButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
      elevation: 0.0,
    );
  }
}
