import 'package:execflutter/ui/imc/imc_form_screen.dart';
import 'package:flutter/material.dart';

class OptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Options Screen"),
          centerTitle: true,
        ),
        body: GridView.count(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 2,
          // Generate 100 widgets that display their index in the List.
          children: List.generate(2, (index) {
            return GestureDetector(
              child: Container(
                  color: index == 0 ? Colors.blue : Colors.amberAccent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.announcement,
                          size: 34,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        index == 0 ? "IMC" : "TMB",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      )
                    ],
                  )),
              onTap: () {
                if (index == 0) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ImcFormScreen()));
                  return;
                }


              },
            );
          }),
        ));
  }
}
