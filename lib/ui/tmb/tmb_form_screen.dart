import 'package:execflutter/ui/utils/components/textfield/text_field_component.dart';
import 'package:flutter/material.dart';

class TmbFormScreen extends StatefulWidget {
  @override
  _TmbFormScreenState createState() => _TmbFormScreenState();
}

class _TmbFormScreenState extends State<TmbFormScreen> {
  String _dropdownValue = 'One';

  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TMB"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 16),
              child: Text(
                  "TMB é o calcúlo para descobrir a quantidade calórica que o corpo necessita de acordo com base no seu estilo de vida"),
            ),
            Container(
              margin: EdgeInsets.only(top: 25),
              child: buildNumericTextField("Peso (KG)", _weightController),
            ),
            Container(
              margin: EdgeInsets.only(top: 25),
              child: buildNumericTextField("Altura (CM)", _heightController),
            ),
            Container(
              margin: EdgeInsets.only(top: 25),
              child: buildNumericTextField("Idade", _ageController),
            ),
            Container(
              margin: EdgeInsets.only(top: 25),
              child: _buildDropdownButton(),
            ),
          ],
        ),
      ),
    );
  }

  DropdownButton<String> _buildDropdownButton() {
    return DropdownButton<String>(
      value: _dropdownValue,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.black),
      underline: Container(
        height: 1,
        color: Colors.grey,
      ),
      onChanged: (String newValue) {
        setState(() {
          _dropdownValue = newValue;
          FocusScope.of(context).requestFocus(new FocusNode());
        });
      },
      isExpanded: true,
      items: <String>['One', 'Two', 'Free', 'Four']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
