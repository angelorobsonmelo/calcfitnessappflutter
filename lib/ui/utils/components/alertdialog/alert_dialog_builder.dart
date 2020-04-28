import 'package:flutter/material.dart';


enum DialogOptions { yes, no }

void alertDialogComponent(
    String type, BuildContext context, String result, Function f) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Resultado $type"),
          content: Text("Seu $type está $result. Deseja salvar?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Sim"),
              onPressed: () {
                Navigator.pop(context);
                f(DialogOptions.yes);
              },
            ),
            FlatButton(
              child: Text("Não"),
              onPressed: () {
                Navigator.pop(context);
                f(DialogOptions.no);
              },
            )
          ],
        );
      });
}
