import 'package:execflutter/dao/fitness_dao.dart';
import 'package:execflutter/model/fitness.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  final String type;

  ResultScreen(this.type);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  FitnessDao _fitnessDao = FitnessDao();
  List<Fitness> _fitness = List();

  @override
  void initState() {
    super.initState();
    _getResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resultados ${widget.type}"),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: _fitness.length,
          padding: EdgeInsets.all(5.0),
          itemBuilder: (context, index) {
            return _resultCard(index);
          }),
    );
  }

  void _getResults() {
    _fitnessDao.getAll().then((results) {
      setState(() {
        _fitness = results;
      });
    });
  }

  Widget _resultCard(int index) {
    Fitness fitness = _fitness[index];
    return Row(children: <Widget>[
      Expanded(
        child: Card(
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 8, right: 8),
                child: Text(
                  fitness.res.toString(),
                  style: TextStyle(fontSize: 25),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 8, right: 8),
                child: Text(
                  fitness.createdAt.toString(),
                  style: TextStyle(fontSize: 25),
                ),
              )
            ],
          ),
        ),
      )
    ]);
  }
}
