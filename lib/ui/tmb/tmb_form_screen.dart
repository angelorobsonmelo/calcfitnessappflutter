import 'package:execflutter/dao/fitness_dao.dart';
import 'package:execflutter/model/fitness.dart';
import 'package:execflutter/ui/utils/components/alertdialog/alert_dialog_builder.dart';
import 'package:execflutter/ui/utils/components/textfield/text_field_component.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class TmbFormScreen extends StatefulWidget {
  @override
  _TmbFormScreenState createState() => _TmbFormScreenState();
}

class _TmbFormScreenState extends State<TmbFormScreen> {
  String _dropdownValue = '';

  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();

  FitnessDao _fitnessDao = FitnessDao.instance;

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
              margin: EdgeInsets.only(top: 25, bottom: 25),
              child: _buildDropdownButton(),
            ),
            ButtonTheme(
              minWidth: 200.0,
              height: 50,
              child: RaisedButton(
                onPressed: () {
                  if (_validate()) {
                    _handleTmb(context);
                    return;
                  }

                  Toast.show("Todos campos devem ser preenchidos", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                },
                child: Text(
                  "Calcular",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  DropdownButton<String> _buildDropdownButton() {
    return DropdownButton<String>(
      hint: Text("Selecione..."),
      value: _dropdownValue.isEmpty ? null : _dropdownValue,
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
      items: <String>[
        "Pouco ou nenhum exercício",
        'Exercício leve. de 1 a 3 dias por semana',
        'Exercício moderador, 3 a 5 dias por semana',
        'Exercício pesado, 6 a 7 dias por semana',
        'Exercício pesado diariamente e até 2x/dia'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  bool _validate() {
    return !_heightController.text.toString().startsWith("0") &&
        !_weightController.text.toString().startsWith("0") &&
        _heightController.text.isNotEmpty &&
        _heightController.text.isNotEmpty &&
        !_ageController.text.startsWith("0") &&
        _ageController.text.isNotEmpty &&
        _weightController.text.isNotEmpty &&
        _dropdownValue.isNotEmpty;
  }

  void _handleTmb(BuildContext context) {
    double tmb = _getTbm();
    double tmbResult = _tmbResponse(tmb);

    Fitness model = Fitness.full("TMB", tmb, DateTime.now().toIso8601String());

    _showAlertDialog(context, tmbResult.toString(), model, (result) {
      if (result == DialogOptions.yes) {
        _fitnessDao.save(model).then((fitness) {
          if (fitness.id != null) {
            _resetForm();
            Toast.show("Salvo com sucesso!", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
          }
        });
      }
    });
  }

  void _showAlertDialog(BuildContext context, String imcResult, Fitness model,
      Function function) {
    alertDialogComponent(
        "TMB", context, imcResult, (result) => {function(result)});
  }

  double _getTbm() {
    int heigth = int.parse(_heightController.text);
    double weigth = double.parse(_weightController.text);
    int age = int.parse(_weightController.text);
    return _calculateTmb(heigth, weigth, age);
  }

  double _calculateTmb(int height, double weight, int age) {
    return 66 + (weight * 13.8) + (5 * height) - (6.9 * age);
  }

  double _tmbResponse(double tmb) {
    if (_dropdownValue == "Pouco ou nenhum exercício") {
      return tmb * 1.2;
    } else if (_dropdownValue == "Exercício leve. de 1 a 3 dias por semana") {
      return tmb * 1.375;
    } else if (_dropdownValue == "Exercício moderador, 3 a 5 dias por semana") {
      return tmb * 1.55;
    } else if (_dropdownValue == "Exercício pesado, 6 a 7 dias por semana") {
      return tmb * 1.725;
    } else if (_dropdownValue == "Exercício pesado diariamente e até 2x/dia") {
      return tmb * 1.9;
    } else {
      return 0.0;
    }
  }

  void _resetForm() {
    setState(() {
      _weightController.text = "";
      _heightController.text = "";
      _ageController.text = "";
      _dropdownValue = '';
    });
  }
}
