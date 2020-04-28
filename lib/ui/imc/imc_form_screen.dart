import 'package:execflutter/dao/fitness_dao.dart';
import 'package:execflutter/model/fitness.dart';
import 'package:execflutter/ui/result_screen.dart';
import 'package:execflutter/ui/utils/components/alertdialog/alert_dialog_builder.dart';
import 'package:execflutter/ui/utils/components/textfield/text_field_component.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

enum ImcMenuItem { imc }

class ImcFormScreen extends StatefulWidget {
  @override
  _ImcFormScreenState createState() => _ImcFormScreenState();
}

class _ImcFormScreenState extends State<ImcFormScreen> {
  final _heightController = TextEditingController();

  final _weightController = TextEditingController();

  final _heightFocus = FocusNode();
  FitnessDao _fitnessDao = FitnessDao.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("IMC"),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<ImcMenuItem>(
            itemBuilder: (context) =>
            <PopupMenuEntry<ImcMenuItem>>[
              const PopupMenuItem<ImcMenuItem>(
                child: Text("Listar Resultados"),
                value: ImcMenuItem.imc,
              )
            ],
            onSelected: (result) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ResultScreen("IMC")));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 80),
            Text(
                "O IMC é reconhecido como padrão internacional para avaliar o grau de sobrepeso e obesidade. É calculado dividindo o peso (em kg) pela altura ao quadrado (em metros)."),
            const SizedBox(height: 30),
            buildNumericTextField("Altura", _heightController,
                focusNode: _heightFocus),
            const SizedBox(height: 10),
            buildNumericTextField("Peso", _weightController),
            const SizedBox(height: 30),
            ButtonTheme(
              minWidth: 200.0,
              height: 50,
              child: RaisedButton(
                onPressed: () {
                  if (_validate()) {
                    _handleImc(context);
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

  void _handleImc(BuildContext context) {
    double imc = _getImc();
    String imcResult = _imcResponse(imc);

    Fitness model = Fitness.full("IMC", imc, DateTime.now().toIso8601String());

    _showAlertDialog(context, imcResult, model, (result) {
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

  double _getImc() {
    int heigth = int.parse(_heightController.text);
    double weigth = double.parse(_weightController.text);
    double imc = calculate(heigth, weigth);
    return imc;
  }

  void _showAlertDialog(BuildContext context, String imcResult, Fitness model,
      Function function) {
    alertDialogComponent(
        "IMC", context, imcResult, (result) => {function(result)});
  }

  void _resetForm() {
    setState(() {
      _weightController.text = "";
      _heightController.text = "";
    });

    FocusScope.of(context).requestFocus(_heightFocus);
  }

  bool _validate() {
    return !_heightController.text.startsWith("0") &&
        !_weightController.text.startsWith("0") &&
        _heightController.text.isNotEmpty &&
        _weightController.text.isNotEmpty;
  }

  double calculate(int heigth, double weigth) {
    return weigth / (heigth / 100 * heigth / 100);
  }

  String _imcResponse(double imc) {
    if (imc < 15) {
      return "Severamente abaixo do peso";
    } else if (imc < 16) {
      return "Muito abaixo do peso";
    } else if (imc < 25) {
      return "normal";
    } else if (imc < 30) {
      return "Acima do peso";
    } else if (imc < 35) {
      return "Muito acima do peso";
    } else if (imc < 40) {
      return "Severamente acima do peso";
    } else {
      return "Extramamente acima do peso";
    }
  }
}
