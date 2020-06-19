import 'package:flutter/material.dart';

class DataSecurityInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(children: <Widget>[
        FlatButton(
            onPressed: () {
              AlertInfo().showAlert(context);
            },
            child: Container(
              height: 30,
              width: 270,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Icon(
                      Icons.info,
                      color: Colors.green,
                    ),
                    Text("Por que precisamos desses dados?"),
                  ]),
            ))
      ]),
    );
  }
}

class AlertInfo {
  var icon = Icons.info;
  var title = "Importância dos dados";
  var content =
      "É muito importante informar todos os dados possíveis, para ajudar localizar seu Pet.";
  void showAlert(context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Center(
                child: Column(children: [
              Icon(
                icon,
                size: 30,
                color: Colors.green,
              ),
              Text(
                title,
                style: TextStyle(fontSize: 15),
              ),
            ])),
            content: Text(
              content,
              style: TextStyle(color: Colors.black54),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("ok"),
              ),
            ],
          ),
      barrierDismissible: true);
}
